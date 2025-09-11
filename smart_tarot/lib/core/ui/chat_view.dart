import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../shared/models/contracts.dart';
import '../../shared/services/api_service.dart';
import '../../shared/infrastructure/app_config.dart';
import '../chat/chat_orchestrator.dart';
import '../history/session_repository.dart';
import 'message_bubble.dart';
import 'technique_selector.dart';
import 'divination_result_widget.dart';

// Providers
final apiServiceProvider = Provider<ApiService>((ref) {
  final config = ref.read(appConfigProvider);
  final apiService = ApiService(baseUrl: config.apiBaseUrl);
  
  // Ensure proper disposal
  ref.onDispose(() {
    apiService.dispose();
  });
  
  return apiService;
});

final sessionRepositoryProvider = Provider<SessionRepository>((ref) {
  return SessionRepository(); // Implementation needed
});

final chatOrchestratorProvider = StateNotifierProvider<ChatOrchestrator, SessionState>((ref) {
  final apiService = ref.read(apiServiceProvider);
  final sessionRepository = ref.read(sessionRepositoryProvider);
  return ChatOrchestrator(apiService, sessionRepository);
});

class ChatView extends ConsumerStatefulWidget {
  const ChatView({super.key});

  @override
  ConsumerState<ChatView> createState() => _ChatViewState();
}

class _ChatViewState extends ConsumerState<ChatView> {
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  bool _isInitialized = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _initializeSession();
    });
  }

  void _initializeSession() async {
    if (!_isInitialized) {
      _isInitialized = true;
      await ref.read(chatOrchestratorProvider.notifier).startSession();
    }
  }

  @override
  void dispose() {
    _messageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      ref.read(chatOrchestratorProvider.notifier).sendMessage(message);
      _messageController.clear();
      _scrollToBottom();
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  void _selectTechnique(DivinationTechnique technique) {
    ref.read(chatOrchestratorProvider.notifier).selectTechnique(technique);
    _scrollToBottom();
  }

  @override
  Widget build(BuildContext context) {
    final sessionState = ref.watch(chatOrchestratorProvider);
    final orchestrator = ref.read(chatOrchestratorProvider.notifier);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(_getAppBarTitle(sessionState.technique)),
        backgroundColor: _getThemeColor(sessionState.technique),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          if (sessionState.technique != null)
            IconButton(
              icon: const Icon(Icons.refresh),
              onPressed: () => _initializeSession(),
              tooltip: 'New session',
            ),
          IconButton(
            icon: const Icon(Icons.history),
            onPressed: () {
              // Navigate to history
            },
            tooltip: 'History',
          ),
        ],
      ),
      body: Column(
        children: [
          // Technique selector (shown when no technique selected)
          if (sessionState.technique == null)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceVariant,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(16),
                ),
              ),
              child: TechniqueSelector(
                onTechniqueSelected: _selectTechnique,
                locale: sessionState.locale,
              ),
            ),

          // Messages list
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              itemCount: sessionState.messages.length + (orchestrator.isLoading ? 1 : 0),
              itemBuilder: (context, index) {
                if (index == sessionState.messages.length) {
                  // Loading indicator
                  return const Padding(
                    padding: EdgeInsets.all(16),
                    child: Center(
                      child: CircularProgressIndicator(),
                    ),
                  );
                }

                final message = sessionState.messages[index];
                
                // Special handling for tool results
                if (message.toolResult != null) {
                  return DivinationResultWidget(
                    technique: sessionState.technique!,
                    toolResult: message.toolResult!,
                    seed: _extractSeedFromToolResult(message.toolResult!),
                    onReplay: (seed) {
                      orchestrator.replayWithSeed(seed);
                    },
                  );
                }

                return MessageBubble(
                  message: message,
                  technique: sessionState.technique,
                );
              },
            ),
          ),

          // Input area
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).colorScheme.outlineVariant,
                  width: 1,
                ),
              ),
            ),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _messageController,
                    enabled: !orchestrator.isLoading,
                    decoration: InputDecoration(
                      hintText: _getInputHint(sessionState, orchestrator.currentState),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                      contentPadding: const EdgeInsets.symmetric(
                        horizontal: 20,
                        vertical: 12,
                      ),
                    ),
                    maxLines: 3,
                    minLines: 1,
                    onSubmitted: (_) => _sendMessage(),
                  ),
                ),
                const SizedBox(width: 8),
                FloatingActionButton.small(
                  onPressed: orchestrator.isLoading ? null : _sendMessage,
                  backgroundColor: _getThemeColor(sessionState.technique),
                  child: const Icon(Icons.send, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _getAppBarTitle(DivinationTechnique? technique) {
    switch (technique) {
      case DivinationTechnique.tarot:
        return 'Tarot Reading';
      case DivinationTechnique.iching:
        return 'I Ching Consultation';
      case DivinationTechnique.runes:
        return 'Runes Reading';
      case null:
        return 'Divination Oracle';
    }
  }

  Color _getThemeColor(DivinationTechnique? technique) {
    switch (technique) {
      case DivinationTechnique.tarot:
        return const Color(0xFF4C1D95);
      case DivinationTechnique.iching:
        return const Color(0xFFDC2626);
      case DivinationTechnique.runes:
        return const Color(0xFF059669);
      case null:
        return const Color(0xFF6366F1);
    }
  }

  String _getInputHint(SessionState state, ChatState currentState) {
    switch (currentState) {
      case ChatState.waitingForTechnique:
        return 'Choose: Tarot, I Ching, or Runes';
      case ChatState.waitingForTopic:
        return 'What would you like guidance on? (optional)';
      case ChatState.waitingForFollowUp:
        return 'Share your thoughts or ask a follow-up...';
      case ChatState.idle:
      case ChatState.completed:
        return 'Start a new consultation...';
      case ChatState.performingDivination:
      case ChatState.providingInterpretation:
      case ChatState.generatingSummary:
        return 'Please wait...';
      case ChatState.error:
        return 'Try sending another message...';
    }
  }

  String _extractSeedFromToolResult(Map<String, dynamic> toolResult) {
    return toolResult['seed'] as String? ?? '';
  }
}