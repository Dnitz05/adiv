import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:uuid/uuid.dart';
import '../../shared/models/contracts.dart';
import '../../shared/models/prompts.dart';
import '../../shared/services/api_service.dart';
import '../history/session_repository.dart';

enum ChatState {
  idle,
  waitingForTechnique,
  waitingForTopic,
  performingDivination,
  providingInterpretation,
  waitingForFollowUp,
  generatingSummary,
  completed,
  error,
}

class ChatOrchestrator extends StateNotifier<SessionState> {
  final ApiService _apiService;
  final SessionRepository _sessionRepository;
  static const _uuid = Uuid();

  ChatState _currentState = ChatState.idle;
  String? _pendingToolCall;
  
  ChatOrchestrator(this._apiService, this._sessionRepository)
      : super(_createInitialSession());

  static SessionState _createInitialSession() {
    final now = DateTime.now();
    return SessionState(
      sessionId: _uuid.v4(),
      userId: 'anonymous', // Will be set by auth
      technique: null,
      locale: 'en', // Will be detected from device
      topic: null,
      messages: [],
      isPremium: false,
      createdAt: now,
      lastActivity: now,
    );
  }

  // Public API
  Future<void> startSession({String? userId, String? locale, bool isPremium = false}) async {
    final now = DateTime.now();
    final sessionId = _uuid.v4();
    
    state = SessionState(
      sessionId: sessionId,
      userId: userId ?? 'anonymous',
      technique: null,
      locale: locale ?? _detectDeviceLocale(),
      topic: null,
      messages: [],
      isPremium: isPremium,
      createdAt: now,
      lastActivity: now,
    );

    _currentState = ChatState.waitingForTechnique;
    await _addMessage(ChatRole.assistant, _getWelcomeMessage());
  }

  Future<void> sendMessage(String content) async {
    await _addMessage(ChatRole.user, content);
    await _processUserMessage(content);
  }

  Future<void> selectTechnique(DivinationTechnique technique) async {
    state = state.copyWith(technique: technique);
    _currentState = ChatState.waitingForTopic;
    
    await _addMessage(
      ChatRole.assistant, 
      _getTechniqueSelectedMessage(technique),
    );
  }

  Future<void> setTopic(String? topic) async {
    state = state.copyWith(topic: topic);
    await _startDivination();
  }

  Future<void> replayWithSeed(String seed) async {
    if (state.technique == null) return;
    
    _currentState = ChatState.performingDivination;
    await _performToolCall(state.technique!, seed: seed);
  }

  // Private methods
  Future<void> _processUserMessage(String content) async {
    switch (_currentState) {
      case ChatState.waitingForTechnique:
        final technique = _parseTechniqueFromMessage(content);
        if (technique != null) {
          await selectTechnique(technique);
        } else {
          await _addMessage(ChatRole.assistant, _getTechniquePrompt());
        }
        break;
        
      case ChatState.waitingForTopic:
        final topic = content.trim().isEmpty ? null : content;
        await setTopic(topic);
        break;
        
      case ChatState.waitingForFollowUp:
        await _handleFollowUp(content);
        break;
        
      default:
        // Generic response or redirect to appropriate state
        await _addMessage(
          ChatRole.assistant, 
          _getGenericResponse(),
        );
    }
  }

  Future<void> _startDivination() async {
    _currentState = ChatState.performingDivination;
    
    await _addMessage(
      ChatRole.assistant,
      _getRitualMessage(state.technique!),
    );

    // Perform the divination tool call
    await _performToolCall(state.technique!);
  }

  Future<void> _performToolCall(DivinationTechnique technique, {String? seed}) async {
    try {
      ToolResponse response;
      ToolRequest request;

      switch (technique) {
        case DivinationTechnique.tarot:
          request = DrawCardsRequest(count: 3, seed: seed);
          response = await _apiService.drawCards(request as DrawCardsRequest);
          break;
        case DivinationTechnique.iching:
          request = TossCoinsRequest(seed: seed);
          response = await _apiService.tossCoins(request as TossCoinsRequest);
          break;
        case DivinationTechnique.runes:
          request = DrawRunesRequest(count: 3, seed: seed);
          response = await _apiService.drawRunes(request as DrawRunesRequest);
          break;
      }

      // Add tool result to conversation
      await _addMessage(
        ChatRole.assistant,
        _formatToolResult(technique, response),
        toolResult: response.toJson(),
      );

      // Get AI interpretation
      await _getInterpretation(technique, response);

    } catch (e) {
      _currentState = ChatState.error;
      await _addMessage(
        ChatRole.assistant,
        _getErrorMessage(e.toString()),
      );
    }
  }

  Future<void> _getInterpretation(DivinationTechnique technique, ToolResponse toolResponse) async {
    _currentState = ChatState.providingInterpretation;

    try {
      String prompt;
      switch (technique) {
        case DivinationTechnique.tarot:
          final cards = (toolResponse as DrawCardsResponse).cards.map((c) => c.toJson()).toList();
          prompt = PromptTemplates.getTarotPrompt(state.locale, cards, state.topic, 'Three Card Reading');
          break;
        case DivinationTechnique.iching:
          final result = (toolResponse as TossCoinsResponse).result;
          prompt = PromptTemplates.getIChingPrompt(state.locale, result.toJson(), state.topic);
          break;
        case DivinationTechnique.runes:
          final runes = (toolResponse as DrawRunesResponse).runes.map((r) => r.toJson()).toList();
          prompt = PromptTemplates.getRunesPrompt(state.locale, runes, state.topic);
          break;
      }

      final interpretation = await _apiService.getInterpretation(
        messages: [
          ChatMessage(
            role: ChatRole.system,
            content: PromptTemplates.getSystemPrompt(state.locale),
            timestamp: DateTime.now(),
          ),
          ChatMessage(
            role: ChatRole.user,
            content: prompt,
            timestamp: DateTime.now(),
          ),
        ],
      );

      await _addMessage(ChatRole.assistant, interpretation);
      
      _currentState = ChatState.waitingForFollowUp;
      await _addMessage(
        ChatRole.assistant,
        PromptTemplates.getFollowUpQuestion(state.locale, technique.name),
      );

    } catch (e) {
      _currentState = ChatState.error;
      await _addMessage(
        ChatRole.assistant,
        _getErrorMessage(e.toString()),
      );
    }
  }

  Future<void> _handleFollowUp(String content) async {
    // Process follow-up and move to summary
    _currentState = ChatState.generatingSummary;
    
    await _addMessage(
      ChatRole.assistant,
      _generateSessionSummary(),
    );
    
    _currentState = ChatState.completed;
    
    // Save session to history
    await _sessionRepository.saveSession(state);
  }

  Future<void> _addMessage(ChatRole role, String content, {Map<String, dynamic>? toolResult}) async {
    final message = ChatMessage(
      role: role,
      content: content,
      timestamp: DateTime.now(),
      toolResult: toolResult,
    );

    state = state.copyWith(
      messages: [...state.messages, message],
      lastActivity: DateTime.now(),
    );
  }

  // Message templates
  String _getWelcomeMessage() {
    final messages = {
      'ca': '🔮 Benvingut/da! Sóc el teu guia en les arts divinatòries.\n\nQuina tècnica t\'agradaria explorar avui?\n• **Tarot** - Cartes per a orientació\n• **I Ching** - Saviesa ancestral xinesa  \n• **Runes** - Símbols nòrdics de poder',
      'es': '🔮 ¡Bienvenido/a! Soy tu guía en las artes adivinatorias.\n\n¿Qué técnica te gustaría explorar hoy?\n• **Tarot** - Cartas para orientación\n• **I Ching** - Sabiduría ancestral china\n• **Runas** - Símbolos nórdicos de poder',
      'en': '🔮 Welcome! I\'m your guide in the divination arts.\n\nWhich technique would you like to explore today?\n• **Tarot** - Cards for guidance\n• **I Ching** - Ancient Chinese wisdom\n• **Runes** - Nordic symbols of power',
    };
    return messages[state.locale] ?? messages['en']!;
  }

  String _getTechniqueSelectedMessage(DivinationTechnique technique) {
    final messages = {
      'tarot': {
        'ca': '🃏 Excel·lent elecció! El Tarot ens revelarà insights profunds.\n\nTens alguna pregunta o tema específic en ment, o prefereixes una lectura general?',
        'es': '🃏 ¡Excelente elección! El Tarot nos revelará insights profundos.\n\n¿Tienes alguna pregunta o tema específico en mente, o prefieres una lectura general?',
        'en': '🃏 Excellent choice! Tarot will reveal deep insights.\n\nDo you have a specific question or topic in mind, or would you prefer a general reading?',
      },
      'iching': {
        'ca': '☯️ Sàvia elecció! L\'I Ching ens connectarà amb la saviesa ancestral.\n\nQuè t\'agradaria explorar amb les monedes de l\'oracle?',
        'es': '☯️ ¡Sabia elección! El I Ching nos conectará con la sabiduría ancestral.\n\n¿Qué te gustaría explorar con las monedas del oráculo?',
        'en': '☯️ Wise choice! I Ching will connect us with ancient wisdom.\n\nWhat would you like to explore with the oracle coins?',
      },
      'runes': {
        'ca': 'ᚱ Poderosa elecció! Les runes ens portaran la saviesa nòrdica.\n\nQuina energia vols despertar amb les pedres ancestrals?',
        'es': 'ᚱ ¡Poderosa elección! Las runas nos traerán la sabiduría nórdica.\n\n¿Qué energía quieres despertar con las piedras ancestrales?',
        'en': 'ᚱ Powerful choice! Runes will bring us Nordic wisdom.\n\nWhat energy do you want to awaken with the ancestral stones?',
      },
    };
    return messages[technique.name]?[state.locale] ?? messages[technique.name]?['en'] ?? '';
  }

  String _getRitualMessage(DivinationTechnique technique) {
    final messages = {
      'tarot': {
        'ca': '✨ Iniciem el ritual... Les cartes s\'estan consagrant amb energia pura...',
        'es': '✨ Iniciamos el ritual... Las cartas se están consagrando con energía pura...',
        'en': '✨ Beginning the ritual... The cards are being consecrated with pure energy...',
      },
      'iching': {
        'ca': '🪙 Les monedes de l\'oracle danzen... Escoltant la veu del Tao...',
        'es': '🪙 Las monedas del oráculo danzan... Escuchando la voz del Tao...',
        'en': '🪙 The oracle coins are dancing... Listening to the voice of the Tao...',
      },
      'runes': {
        'ca': '🗿 Despertant les pedres ancestrals... Invocant els esperits nòrdics...',
        'es': '🗿 Despertando las piedras ancestrales... Invocando los espíritus nórdicos...',
        'en': '🗿 Awakening the ancestral stones... Invoking the Nordic spirits...',
      },
    };
    return messages[technique.name]?[state.locale] ?? messages[technique.name]?['en'] ?? '';
  }

  String _formatToolResult(DivinationTechnique technique, ToolResponse response) {
    // This will show the visual result (cards drawn, lines, runes, etc.)
    // Implementation will depend on UI components
    return '🎯 **Seed**: ${response.seed}\n*Timestamp*: ${response.timestamp.toIso8601String()}';
  }

  String _generateSessionSummary() {
    // Generate a comprehensive summary based on the session
    return PromptTemplates.getSummaryTemplate(state.locale)
        .replaceAll('{{technique}}', state.technique?.name ?? '')
        .replaceAll('{{topic}}', state.topic ?? 'General consultation')
        .replaceAll('{{key_message}}', 'Trust your intuition')
        .replaceAll('{{actions}}', '• Reflect on the guidance received\n• Take one small action today');
  }

  DivinationTechnique? _parseTechniqueFromMessage(String message) {
    final lower = message.toLowerCase();
    if (lower.contains('tarot') || lower.contains('carta')) {
      return DivinationTechnique.tarot;
    } else if (lower.contains('ching') || lower.contains('moneda')) {
      return DivinationTechnique.iching;
    } else if (lower.contains('runa') || lower.contains('rune')) {
      return DivinationTechnique.runes;
    }
    return null;
  }

  String _getTechniquePrompt() {
    final messages = {
      'ca': 'Si us plau, escull una de les tres tècniques: **Tarot**, **I Ching** o **Runes**.',
      'es': 'Por favor, elige una de las tres técnicas: **Tarot**, **I Ching** o **Runas**.',
      'en': 'Please choose one of the three techniques: **Tarot**, **I Ching**, or **Runes**.',
    };
    return messages[state.locale] ?? messages['en']!;
  }

  String _getGenericResponse() {
    final messages = {
      'ca': 'Interessant perspectiva. Com puc ajudar-te més amb la teva consulta?',
      'es': 'Perspectiva interesante. ¿Cómo puedo ayudarte más con tu consulta?',
      'en': 'Interesting perspective. How can I help you more with your consultation?',
    };
    return messages[state.locale] ?? messages['en']!;
  }

  String _getErrorMessage(String error) {
    final messages = {
      'ca': 'Ho sento, ha ocorregut un problema amb l\'oracle. Provem de nou?',
      'es': 'Lo siento, ha ocurrido un problema con el oráculo. ¿Intentamos de nuevo?',
      'en': 'Sorry, there was a problem with the oracle. Shall we try again?',
    };
    return messages[state.locale] ?? messages['en']!;
  }

  String _detectDeviceLocale() {
    // This should integrate with Flutter's locale detection
    return 'en';
  }

  // Getters for UI
  bool get canUsePremiumFeatures => state.isPremium;
  ChatState get currentState => _currentState;
  bool get isLoading => [
    ChatState.performingDivination,
    ChatState.providingInterpretation,
    ChatState.generatingSummary,
  ].contains(_currentState);
}