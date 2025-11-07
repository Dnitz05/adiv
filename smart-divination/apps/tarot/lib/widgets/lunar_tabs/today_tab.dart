import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../../models/chat_message.dart';
import '../../models/lunar_day.dart';
import '../../screens/chat_screen.dart';
import '../../state/lunar_cycle_controller.dart';
import '../../theme/tarot_theme.dart';
import '../lunar_ai_advisor.dart';

class TodayTab extends StatelessWidget {
  const TodayTab({
    super.key,
    required this.day,
    required this.controller,
    required this.strings,
    this.userId,
    this.onSelectSpread,
  });

  final LunarDayModel day;
  final LunarCycleController controller;
  final CommonStrings strings;
  final String? userId;
  final void Function(String spreadId)? onSelectSpread;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _buildPhaseGuide(context),
          const SizedBox(height: 16),
          LunarAiAdvisor(
            strings: strings,
            userId: userId,
            locale: strings.localeName,
            onShareAdvice: (message) => _openAdviceInChat(context, message),
          ),
          const SizedBox(height: 16),
          _buildPowerHours(context),
        ],
      ),
    );
  }

  Widget _buildPhaseGuide(BuildContext context) {
    final activities = _getOptimalActivities(day.phaseId, day.zodiac.element);

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.2),
            TarotTheme.cosmicPurple.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [TarotTheme.cosmicBlue, TarotTheme.cosmicAccent],
                  ),
                ),
                child: const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                _localisedLabel('phase_guide'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),

          // Phase Description
          Text(
            _getPhaseDescription(day.phaseId),
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.white.withValues(alpha: 0.95),
                  height: 1.5,
                ),
          ),
          const SizedBox(height: 12),

          // Keywords
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: _getPhaseKeywords(day.phaseId).map((keyword) {
              return Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: TarotTheme.cosmicAccent.withValues(alpha: 0.5),
                  ),
                ),
                child: Text(
                  keyword,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 16),
          const Divider(color: Colors.white24, height: 1),
          const SizedBox(height: 16),

          // Optimal Activities - Compact format
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.check_circle, color: Colors.greenAccent, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _localisedLabel('optimal'),
                      style: const TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      activities['favored']!.join(' • '),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: Colors.white.withValues(alpha: 0.9),
                            height: 1.4,
                          ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          if (activities['avoid']!.isNotEmpty) ...[
            const SizedBox(height: 12),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(Icons.warning_amber_rounded,
                    color: Colors.orangeAccent, size: 16),
                const SizedBox(width: 8),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _localisedLabel('avoid'),
                        style: const TextStyle(
                          color: Colors.orangeAccent,
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        activities['avoid']!.join(' • '),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.7),
                              height: 1.4,
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildPowerHours(BuildContext context) {
    if (day.sessions.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            TarotTheme.cosmicBlue.withValues(alpha: 0.2),
            TarotTheme.cosmicPurple.withValues(alpha: 0.2),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
      ),
      padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: LinearGradient(
                    colors: [TarotTheme.cosmicBlue, TarotTheme.cosmicAccent],
                  ),
                ),
                child: const Icon(Icons.schedule, color: Colors.white, size: 18),
              ),
              const SizedBox(width: 12),
              Text(
                _localisedLabel('power_hours'),
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            _localisedLabel('power_hours_subtitle'),
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.white70,
                ),
          ),
          const SizedBox(height: 12),
          ...day.sessions.take(3).map((session) {
            return Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                children: [
                  const Icon(Icons.access_time, color: Colors.white70, size: 16),
                  const SizedBox(width: 8),
                  Text(
                    _formatSessionTime(session.createdAt),
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }

  List<String> _getPhaseKeywords(String phaseId) {
    final locale = strings.localeName;
    final keywords = {
      'new_moon': {
        'en': ['New Beginnings', 'Intention Setting', 'Fresh Start'],
        'es': ['Nuevos Comienzos', 'Intenciones', 'Inicio Fresco'],
        'ca': ['Nous Inicis', 'Intencions', 'Començament Fresc'],
      },
      'waxing_crescent': {
        'en': ['Growth', 'Building', 'Momentum'],
        'es': ['Crecimiento', 'Construcción', 'Impulso'],
        'ca': ['Creixement', 'Construcció', 'Impuls'],
      },
      'first_quarter': {
        'en': ['Action', 'Decision', 'Commitment'],
        'es': ['Acción', 'Decisión', 'Compromiso'],
        'ca': ['Acció', 'Decisió', 'Compromís'],
      },
      'waxing_gibbous': {
        'en': ['Refinement', 'Adjustment', 'Perfection'],
        'es': ['Refinamiento', 'Ajuste', 'Perfección'],
        'ca': ['Refinament', 'Ajust', 'Perfecció'],
      },
      'full_moon': {
        'en': ['Illumination', 'Culmination', 'Gratitude'],
        'es': ['Iluminación', 'Culminación', 'Gratitud'],
        'ca': ['Il·luminació', 'Culminació', 'Gratitud'],
      },
      'waning_gibbous': {
        'en': ['Sharing', 'Teaching', 'Reflection'],
        'es': ['Compartir', 'Enseñar', 'Reflexión'],
        'ca': ['Compartir', 'Ensenyar', 'Reflexió'],
      },
      'last_quarter': {
        'en': ['Release', 'Forgiveness', 'Letting Go'],
        'es': ['Liberación', 'Perdón', 'Soltar'],
        'ca': ['Alliberament', 'Perdó', 'Deixar Anar'],
      },
      'waning_crescent': {
        'en': ['Rest', 'Surrender', 'Preparation'],
        'es': ['Descanso', 'Rendición', 'Preparación'],
        'ca': ['Descans', 'Rendició', 'Preparació'],
      },
    };

    return keywords[phaseId]?[locale] ?? keywords[phaseId]?['en'] ?? [];
  }

  Map<String, List<String>> _getOptimalActivities(String phaseId, String element) {
    final locale = strings.localeName;

    // Base activities by phase
    final phaseActivities = _getPhaseActivities(phaseId, locale);

    // Modify based on element
    // Fire adds passion/creativity, Earth adds grounding, Air adds communication, Water adds emotion

    return phaseActivities;
  }

  Map<String, List<String>> _getPhaseActivities(String phaseId, String locale) {
    final activities = {
      'new_moon': {
        'en': {
          'favored': [
            'Setting clear intentions',
            'Starting new projects',
            'Inner reflection and meditation',
            'Vision boarding'
          ],
          'avoid': ['Major confrontations', 'Rushing decisions']
        },
        'es': {
          'favored': [
            'Establecer intenciones claras',
            'Iniciar nuevos proyectos',
            'Reflexión interior y meditación',
            'Crear tableros de visión'
          ],
          'avoid': ['Confrontaciones importantes', 'Apresurar decisiones']
        },
        'ca': {
          'favored': [
            'Establir intencions clares',
            'Iniciar nous projectes',
            'Reflexió interior i meditació',
            'Crear taulers de visió'
          ],
          'avoid': ['Confrontacions importants', 'Prendre decisions precipitades']
        },
      },
      'waxing_crescent': {
        'en': {
          'favored': [
            'Taking first steps toward goals',
            'Building momentum',
            'Learning new skills',
            'Networking'
          ],
          'avoid': ['Giving up too soon', 'Overcommitting']
        },
        'es': {
          'favored': [
            'Dar primeros pasos hacia objetivos',
            'Construir impulso',
            'Aprender nuevas habilidades',
            'Hacer networking'
          ],
          'avoid': ['Rendirse demasiado pronto', 'Sobrecomprometerse']
        },
        'ca': {
          'favored': [
            'Fer els primers passos cap als objectius',
            'Construir impuls',
            'Aprendre noves habilitats',
            'Fer networking'
          ],
          'avoid': ['Rendir-se massa aviat', 'Comprometre\'s en excés']
        },
      },
      'first_quarter': {
        'en': {
          'favored': [
            'Making important decisions',
            'Taking bold action',
            'Overcoming obstacles',
            'Problem-solving'
          ],
          'avoid': ['Procrastination', 'Avoiding challenges']
        },
        'es': {
          'favored': [
            'Tomar decisiones importantes',
            'Actuar con audacia',
            'Superar obstáculos',
            'Resolver problemas'
          ],
          'avoid': ['Procrastinación', 'Evitar desafíos']
        },
        'ca': {
          'favored': [
            'Prendre decisions importants',
            'Actuar amb audàcia',
            'Superar obstacles',
            'Resoldre problemes'
          ],
          'avoid': ['Procrastinació', 'Evitar reptes']
        },
      },
      'full_moon': {
        'en': {
          'favored': [
            'Celebrating achievements',
            'Expressing gratitude',
            'Completing projects',
            'Emotional release'
          ],
          'avoid': ['Starting major new ventures', 'Suppressing emotions']
        },
        'es': {
          'favored': [
            'Celebrar logros',
            'Expresar gratitud',
            'Completar proyectos',
            'Liberar emociones'
          ],
          'avoid': ['Iniciar grandes proyectos nuevos', 'Reprimir emociones']
        },
        'ca': {
          'favored': [
            'Celebrar èxits',
            'Expressar gratitud',
            'Completar projectes',
            'Alliberar emocions'
          ],
          'avoid': ['Iniciar grans projectes nous', 'Reprimir emocions']
        },
      },
      'waning_gibbous': {
        'en': {
          'favored': [
            'Sharing knowledge',
            'Teaching others',
            'Giving back',
            'Reflecting on lessons'
          ],
          'avoid': ['Hoarding resources', 'Ignoring insights']
        },
        'es': {
          'favored': [
            'Compartir conocimiento',
            'Enseñar a otros',
            'Devolver a la comunidad',
            'Reflexionar sobre lecciones'
          ],
          'avoid': ['Acaparar recursos', 'Ignorar conocimientos']
        },
        'ca': {
          'favored': [
            'Compartir coneixement',
            'Ensenyar altres',
            'Retornar a la comunitat',
            'Reflexionar sobre lliçons'
          ],
          'avoid': ['Acaparar recursos', 'Ignorar coneixements']
        },
      },
      'last_quarter': {
        'en': {
          'favored': [
            'Releasing what no longer serves',
            'Forgiveness work',
            'Decluttering',
            'Endings and closures'
          ],
          'avoid': ['Clinging to the past', 'Starting new commitments']
        },
        'es': {
          'favored': [
            'Soltar lo que ya no sirve',
            'Trabajo de perdón',
            'Ordenar y limpiar',
            'Finales y cierres'
          ],
          'avoid': ['Aferrarse al pasado', 'Iniciar nuevos compromisos']
        },
        'ca': {
          'favored': [
            'Deixar anar allò que ja no serveix',
            'Treball de perdó',
            'Ordenar i netejar',
            'Finals i tancaments'
          ],
          'avoid': ['Aferrar-se al passat', 'Iniciar nous compromisos']
        },
      },
      'waning_crescent': {
        'en': {
          'favored': [
            'Rest and recuperation',
            'Deep introspection',
            'Spiritual practices',
            'Preparing for new cycle'
          ],
          'avoid': ['Overexertion', 'Making major plans']
        },
        'es': {
          'favored': [
            'Descanso y recuperación',
            'Introspección profunda',
            'Prácticas espirituales',
            'Prepararse para nuevo ciclo'
          ],
          'avoid': ['Sobresfuerzo', 'Hacer planes importantes']
        },
        'ca': {
          'favored': [
            'Descans i recuperació',
            'Introspecció profunda',
            'Pràctiques espirituals',
            'Preparar-se per nou cicle'
          ],
          'avoid': ['Esforç excessiu', 'Fer plans importants']
        },
      },
    };

    final Map<String, List<String>> defaults = {
      'favored': ['Inner work', 'Meditation'],
      'avoid': <String>[]
    };

    return activities[phaseId]?[locale] ?? activities[phaseId]?['en'] ?? defaults;
  }

  String _localisedLabel(String key) {
    final locale = strings.localeName;
    final labels = {
      'phase_guide': {
        'en': 'Phase Guide',
        'es': 'Guía de Fase',
        'ca': 'Guia de Fase'
      },
      'optimal': {
        'en': 'OPTIMAL',
        'es': 'ÓPTIMO',
        'ca': 'ÒPTIM'
      },
      'avoid': {
        'en': 'AVOID',
        'es': 'EVITAR',
        'ca': 'EVITAR'
      },
      'phase_essence': {
        'en': 'Phase Essence',
        'es': 'Esencia de la Fase',
        'ca': 'Essència de la Fase'
      },
      'optimal_activities': {
        'en': 'Optimal Activities',
        'es': 'Actividades Óptimas',
        'ca': 'Activitats Òptimes'
      },
      'power_hours': {
        'en': 'Power Hours',
        'es': 'Horas de Poder',
        'ca': 'Hores de Poder'
      },
      'power_hours_subtitle': {
        'en': 'Best times today for important activities',
        'es': 'Mejores momentos hoy para actividades importantes',
        'ca': 'Millors moments avui per activitats importants'
      },
    };
    return labels[key]?[locale] ?? labels[key]?['en'] ?? key;
  }

  void _openAdviceInChat(BuildContext context, String advice) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => ChatScreen(
          strings: strings,
          userId: userId ?? 'guest',
          initialMessages: [
            ChatMessage(
              id: DateTime.now().millisecondsSinceEpoch.toString(),
              kind: ChatMessageKind.text,
              isUser: false,
              text: advice,
              timestamp: DateTime.now(),
            ),
          ],
        ),
      ),
    );
  }

  String _getPhaseDescription(String phaseId) {
    final locale = strings.localeName;
    final descriptions = {
      'new_moon': {
        'en': 'A time of new beginnings and fresh starts. Plant the seeds of your intentions.',
        'es': 'Un tiempo de nuevos comienzos y comienzos frescos. Planta las semillas de tus intenciones.',
        'ca': 'Un temps de nous començaments i inicis frescos. Planta les llavors de les teves intencions.'
      },
      'waxing_crescent': {
        'en': 'Building energy and momentum. Take action on your goals.',
        'es': 'Construyendo energía y momentum. Toma acción en tus objetivos.',
        'ca': 'Construint energia i momentum. Pren acció en els teus objectius.'
      },
      'first_quarter': {
        'en': 'A time of decision and action. Overcome obstacles with determination.',
        'es': 'Un tiempo de decisión y acción. Supera obstáculos con determinación.',
        'ca': 'Un temps de decisió i acció. Supera obstacles amb determinació.'
      },
      'waxing_gibbous': {
        'en': 'Refine and adjust your plans. Perfect your approach.',
        'es': 'Refina y ajusta tus planes. Perfecciona tu enfoque.',
        'ca': 'Refina i ajusta els teus plans. Perfecciona el teu enfocament.'
      },
      'full_moon': {
        'en': 'Peak energy and illumination. Celebrate achievements and harvest results.',
        'es': 'Energía e iluminación máxima. Celebra logros y cosecha resultados.',
        'ca': 'Energia i il·luminació màxima. Celebra assoliments i collita resultats.'
      },
      'waning_gibbous': {
        'en': 'Share wisdom and gratitude. Give back to others.',
        'es': 'Comparte sabiduría y gratitud. Devuelve a otros.',
        'ca': 'Comparteix saviesa i gratitud. Retorna als altres.'
      },
      'last_quarter': {
        'en': 'Release what no longer serves. Forgive and let go.',
        'es': 'Libera lo que ya no sirve. Perdona y deja ir.',
        'ca': 'Allibera el que ja no serveix. Perdona i deixa anar.'
      },
      'waning_crescent': {
        'en': 'Rest, reflect, and prepare. Turn inward for wisdom.',
        'es': 'Descansa, reflexiona y prepárate. Gira hacia adentro por sabiduría.',
        'ca': 'Descansa, reflexiona i prepara\'t. Gira cap a dins per saviesa.'
      },
    };
    return descriptions[phaseId]?[locale] ?? descriptions[phaseId]?['en'] ??
           'The current lunar phase offers unique energies and opportunities.';
  }

  String _formatSessionTime(DateTime createdAt) {
    final hour = createdAt.hour;
    final minute = createdAt.minute.toString().padLeft(2, '0');
    final period = hour >= 12 ? 'PM' : 'AM';
    final displayHour = hour > 12 ? hour - 12 : (hour == 0 ? 12 : hour);
    return '$displayHour:$minute $period';
  }
}
