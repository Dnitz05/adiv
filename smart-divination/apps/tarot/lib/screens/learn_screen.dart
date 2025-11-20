import 'package:flutter/material.dart';
import 'package:common/l10n/common_strings.dart';

import '../theme/tarot_theme.dart';

class LearnScreen extends StatelessWidget {
  const LearnScreen({
    super.key,
    required this.strings,
    required this.onNavigateToCards,
    required this.onNavigateToKnowledge,
    required this.onNavigateToSpreads,
    required this.onNavigateToAstrology,
    required this.onNavigateToKabbalah,
    required this.onNavigateToMoonPowers,
  });

  final CommonStrings strings;
  final VoidCallback onNavigateToCards;
  final VoidCallback onNavigateToKnowledge;
  final VoidCallback onNavigateToSpreads;
  final VoidCallback onNavigateToAstrology;
  final VoidCallback onNavigateToKabbalah;
  final VoidCallback onNavigateToMoonPowers;

  @override
  Widget build(BuildContext context) {
    final locale = strings.localeName;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        const SizedBox(height: 8),

        // Welcome Section
        _WelcomeCard(locale: locale),

        const SizedBox(height: 20),

        // Featured: Lunar Academy
        _FeaturedLunarAcademyCard(
          locale: locale,
          onTap: onNavigateToMoonPowers,
        ),

        const SizedBox(height: 28),

        // Section Title
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 16),
          child: Text(
            _getLearningJourneysTitle(locale),
            style: const TextStyle(
              color: TarotTheme.deepNavy,
              fontSize: 20,
              fontWeight: FontWeight.w700,
              letterSpacing: 0.3,
            ),
          ),
        ),

        // Learning Journeys
        _LearningJourneyCard(
          icon: '🎴',
          title: _getCardsTitle(locale),
          description: _getCardsDescription(locale),
          lessonsInfo: _getCardsInfo(locale),
          progress: 0.45,
          color: const Color(0xFF8B5CF6),
          onTap: onNavigateToCards,
          isLocked: false,
        ),

        const SizedBox(height: 16),

        _LearningJourneyCard(
          icon: '⭐',
          title: _getAstrologyTitle(locale),
          description: _getAstrologyDescription(locale),
          lessonsInfo: _getAstrologyInfo(locale),
          progress: 0.15,
          color: const Color(0xFF3B82F6),
          onTap: onNavigateToAstrology,
          isLocked: false,
        ),

        const SizedBox(height: 16),

        _LearningJourneyCard(
          icon: '📚',
          title: _getKnowledgeTitle(locale),
          description: _getKnowledgeDescription(locale),
          lessonsInfo: _getKnowledgeInfo(locale),
          progress: 0.30,
          color: const Color(0xFFF59E0B),
          onTap: onNavigateToKnowledge,
          isLocked: false,
        ),

        const SizedBox(height: 16),

        _LearningJourneyCard(
          icon: '🎯',
          title: _getSpreadsTitle(locale),
          description: _getSpreadsDescription(locale),
          lessonsInfo: _getSpreadsInfo(locale),
          progress: 0.0,
          color: const Color(0xFF06B6D4),
          onTap: onNavigateToSpreads,
          isLocked: false,
        ),

        const SizedBox(height: 16),

        _LearningJourneyCard(
          icon: '🔯',
          title: _getKabbalahTitle(locale),
          description: _getKabbalahDescription(locale),
          lessonsInfo: _getKabbalahInfo(locale),
          progress: 0.0,
          color: const Color(0xFF7C3AED),
          onTap: onNavigateToKabbalah,
          isLocked: true,
        ),

        const SizedBox(height: 28),

        // Your Journey Section
        _YourJourneyCard(locale: locale),

        const SizedBox(height: 24),
      ],
    );
  }

  String _getLearningJourneysTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Camins de Descobriment';
      case 'es':
        return 'Caminos de Descubrimiento';
      default:
        return 'Paths of Discovery';
    }
  }

  String _getCardsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Les 78 Cartes del Tarot';
      case 'es':
        return 'Las 78 Cartas del Tarot';
      default:
        return 'The 78 Tarot Cards';
    }
  }

  String _getCardsDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Explora el simbolisme profund de cada arcà. Descobreix les connexions entre símbols, colors i significats per enriquir les teves lectures.';
      case 'es':
        return 'Explora el simbolismo profundo de cada arcano. Descubre las conexiones entre símbolos, colores y significados para enriquecer tus lecturas.';
      default:
        return 'Explore the deep symbolism of each arcana. Discover connections between symbols, colors and meanings to enrich your readings.';
    }
  }

  String _getCardsInfo(String locale) {
    switch (locale) {
      case 'ca':
        return '22 arcans majors • 56 arcans menors';
      case 'es':
        return '22 arcanos mayores • 56 arcanos menores';
      default:
        return '22 major arcana • 56 minor arcana';
    }
  }

  String _getAstrologyTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Astrologia i Tarot';
      case 'es':
        return 'Astrología y Tarot';
      default:
        return 'Astrology & Tarot';
    }
  }

  String _getAstrologyDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Connecta amb les influències astrals. Aprèn com els signes zodiacals, planetes i cases astrològiques s\'entrellacen amb el tarot.';
      case 'es':
        return 'Conecta con las influencias astrales. Aprende cómo los signos zodiacales, planetas y casas astrológicas se entrelazan con el tarot.';
      default:
        return 'Connect with astral influences. Learn how zodiac signs, planets and astrological houses intertwine with tarot.';
    }
  }

  String _getAstrologyInfo(String locale) {
    switch (locale) {
      case 'ca':
        return '12 signes • 7 planetes • Cicles lunars';
      case 'es':
        return '12 signos • 7 planetas • Ciclos lunares';
      default:
        return '12 signs • 7 planets • Lunar cycles';
    }
  }

  String _getKnowledgeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Saviesa i Tradició';
      case 'es':
        return 'Sabiduría y Tradición';
      default:
        return 'Wisdom & Tradition';
    }
  }

  String _getKnowledgeDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Descobreix la història mil·lenària del tarot. Des dels seus orígens fins a la pràctica contemporània, amb ètica i respecte.';
      case 'es':
        return 'Descubre la historia milenaria del tarot. Desde sus orígenes hasta la práctica contemporánea, con ética y respeto.';
      default:
        return 'Discover the millenary history of tarot. From its origins to contemporary practice, with ethics and respect.';
    }
  }

  String _getKnowledgeInfo(String locale) {
    switch (locale) {
      case 'ca':
        return 'Història • Ètica • Pràctica conscient';
      case 'es':
        return 'Historia • Ética • Práctica consciente';
      default:
        return 'History • Ethics • Conscious practice';
    }
  }

  String _getSpreadsTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Tirades i Mètodes';
      case 'es':
        return 'Tiradas y Métodos';
      default:
        return 'Spreads & Methods';
    }
  }

  String _getSpreadsDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Aprèn diferents tècniques de lectura. Des de tirades senzilles fins a mètodes avançats per a preguntes complexes.';
      case 'es':
        return 'Aprende diferentes técnicas de lectura. Desde tiradas sencillas hasta métodos avanzados para preguntas complejas.';
      default:
        return 'Learn different reading techniques. From simple spreads to advanced methods for complex questions.';
    }
  }

  String _getSpreadsInfo(String locale) {
    switch (locale) {
      case 'ca':
        return 'De 3 a 12 cartes • Tots els nivells';
      case 'es':
        return 'De 3 a 12 cartas • Todos los niveles';
      default:
        return '3 to 12 cards • All levels';
    }
  }

  String _getKabbalahTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Kabbalah i Mística';
      case 'es':
        return 'Kabbalah y Mística';
      default:
        return 'Kabbalah & Mysticism';
    }
  }

  String _getKabbalahDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Explora l\'Arbre de la Vida i les correspondències místiques. Aprofundeix en la dimensió espiritual del tarot.';
      case 'es':
        return 'Explora el Árbol de la Vida y las correspondencias místicas. Profundiza en la dimensión espiritual del tarot.';
      default:
        return 'Explore the Tree of Life and mystical correspondences. Deepen into the spiritual dimension of tarot.';
    }
  }

  String _getKabbalahInfo(String locale) {
    switch (locale) {
      case 'ca':
        return '10 Sephirot • 22 Camins • Simbolisme sagrat';
      case 'es':
        return '10 Sephirot • 22 Caminos • Simbolismo sagrado';
      default:
        return '10 Sephirot • 22 Paths • Sacred symbolism';
    }
  }
}

// ============================================================================
// Welcome Card
// ============================================================================

class _WelcomeCard extends StatelessWidget {
  const _WelcomeCard({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final hour = DateTime.now().hour;
    final greeting = _getGreeting(locale, hour);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TarotTheme.cosmicAccent.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    colors: [
                      TarotTheme.cosmicBlue,
                      TarotTheme.cosmicAccent,
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                ),
                child: const Icon(
                  Icons.auto_stories,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      greeting,
                      style: const TextStyle(
                        color: TarotTheme.softBlueGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _getWelcomeTitle(locale),
                      style: const TextStyle(
                        color: TarotTheme.deepNavy,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 0.3,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Description
          Text(
            _getWelcomeDescription(locale),
            style: const TextStyle(
              color: TarotTheme.softBlueGrey,
              fontSize: 14,
              height: 1.6,
            ),
          ),

          const SizedBox(height: 20),

          // Progress - very subtle
          Row(
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: LinearProgressIndicator(
                    value: 0.28,
                    backgroundColor: TarotTheme.skyBlueLight,
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      TarotTheme.cosmicAccent,
                    ),
                    minHeight: 6,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                '28%',
                style: const TextStyle(
                  color: TarotTheme.softBlueGrey,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _getGreeting(String locale, int hour) {
    if (hour < 12) {
      switch (locale) {
        case 'ca':
          return 'Bon dia ☀️';
        case 'es':
          return 'Buenos días ☀️';
        default:
          return 'Good morning ☀️';
      }
    } else if (hour < 18) {
      switch (locale) {
        case 'ca':
          return 'Bona tarda 🌤️';
        case 'es':
          return 'Buenas tardes 🌤️';
        default:
          return 'Good afternoon 🌤️';
      }
    } else {
      switch (locale) {
        case 'ca':
          return 'Bon vespre 🌙';
        case 'es':
          return 'Buenas noches 🌙';
        default:
          return 'Good evening 🌙';
      }
    }
  }

  String _getWelcomeTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Benvingut al teu espai d\'aprenentatge';
      case 'es':
        return 'Bienvenido a tu espacio de aprendizaje';
      default:
        return 'Welcome to your learning space';
    }
  }

  String _getWelcomeDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Creix amb el tarot dia a dia. Aquí trobaràs guies, històries i saviesa per acompanyar-te en el teu camí.';
      case 'es':
        return 'Crece con el tarot día a día. Aquí encontrarás guías, historias y sabiduría para acompañarte en tu camino.';
      default:
        return 'Grow with tarot day by day. Here you\'ll find guides, stories and wisdom to accompany you on your path.';
    }
  }
}

// ============================================================================
// Featured Lunar Academy Card
// ============================================================================

class _FeaturedLunarAcademyCard extends StatelessWidget {
  const _FeaturedLunarAcademyCard({
    required this.locale,
    required this.onTap,
  });

  final String locale;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4),
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF6366F1).withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Badge and Moon
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: const Color(0xFF6366F1).withValues(alpha: 0.3),
                      width: 1,
                    ),
                  ),
                  child: Text(
                    _getNewBadge(locale),
                    style: const TextStyle(
                      color: Color(0xFF6366F1),
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.8,
                    ),
                  ),
                ),
                const Text('🌙', style: TextStyle(fontSize: 32)),
              ],
            ),

            const SizedBox(height: 16),

            // Title
            Text(
              _getTitle(locale),
              style: const TextStyle(
                color: TarotTheme.deepNavy,
                fontSize: 22,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.3,
              ),
            ),

            const SizedBox(height: 10),

            // Description
            Text(
              _getDescription(locale),
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 15,
                height: 1.6,
              ),
            ),

            const SizedBox(height: 18),

            // Info
            Text(
              _getInfo(locale),
              style: TextStyle(
                color: const Color(0xFF6366F1).withValues(alpha: 0.8),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getNewBadge(String locale) {
    switch (locale) {
      case 'ca':
        return 'NOU';
      case 'es':
        return 'NUEVO';
      default:
        return 'NEW';
    }
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'Acadèmia Lunar';
      case 'es':
        return 'Academia Lunar';
      default:
        return 'Lunar Academy';
    }
  }

  String _getDescription(String locale) {
    switch (locale) {
      case 'ca':
        return 'Un espai per explorar les 8 fases de la Lluna, els seus cicles i rituals ancestrals. Aprèn a sincronitzar-te amb l\'energia lunar.';
      case 'es':
        return 'Un espacio para explorar las 8 fases de la Luna, sus ciclos y rituales ancestrales. Aprende a sincronizarte con la energía lunar.';
      default:
        return 'A space to explore the 8 phases of the Moon, its cycles and ancestral rituals. Learn to synchronize with lunar energy.';
    }
  }

  String _getInfo(String locale) {
    switch (locale) {
      case 'ca':
        return '8 Fases lunars • 4 Estacions • Rituals verificables';
      case 'es':
        return '8 Fases lunares • 4 Estaciones • Rituales verificables';
      default:
        return '8 Lunar phases • 4 Seasons • Verifiable rituals';
    }
  }
}

// ============================================================================
// Learning Journey Card
// ============================================================================

class _LearningJourneyCard extends StatelessWidget {
  const _LearningJourneyCard({
    required this.icon,
    required this.title,
    required this.description,
    required this.lessonsInfo,
    required this.progress,
    required this.color,
    required this.onTap,
    required this.isLocked,
  });

  final String icon;
  final String title;
  final String description;
  final String lessonsInfo;
  final double progress;
  final Color color;
  final VoidCallback onTap;
  final bool isLocked;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(
            color: color.withValues(alpha: 0.25),
            width: 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon, Title and Lock
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: color.withValues(alpha: 0.1),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Text(
                    icon,
                    style: const TextStyle(fontSize: 28),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          color: TarotTheme.deepNavy,
                          fontSize: 17,
                          fontWeight: FontWeight.w700,
                          letterSpacing: 0.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        lessonsInfo,
                        style: TextStyle(
                          color: color.withValues(alpha: 0.8),
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                if (isLocked)
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: TarotTheme.softBlueGrey.withValues(alpha: 0.15),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.lock_outline,
                      color: TarotTheme.softBlueGrey,
                      size: 18,
                    ),
                  ),
              ],
            ),

            const SizedBox(height: 16),

            // Description
            Text(
              description,
              style: const TextStyle(
                color: TarotTheme.softBlueGrey,
                fontSize: 14,
                height: 1.6,
              ),
            ),

            // Progress (only if not locked)
            if (!isLocked) ...[
              const SizedBox(height: 18),
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: LinearProgressIndicator(
                  value: progress,
                  backgroundColor: color.withValues(alpha: 0.15),
                  valueColor: AlwaysStoppedAnimation<Color>(color),
                  minHeight: 6,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

// ============================================================================
// Your Journey Card
// ============================================================================

class _YourJourneyCard extends StatelessWidget {
  const _YourJourneyCard({required this.locale});

  final String locale;

  @override
  Widget build(BuildContext context) {
    final items = _getJourneyItems(locale);

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: TarotTheme.brightBlue.withValues(alpha: 0.3),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Icon and Title
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [
                      TarotTheme.cosmicBlue,
                      TarotTheme.cosmicAccent,
                    ],
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.explore,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  _getTitle(locale),
                  style: const TextStyle(
                    color: TarotTheme.deepNavy,
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.3,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Journey items
          ...items.asMap().entries.map(
                (entry) => Padding(
                  padding: EdgeInsets.only(
                    bottom: entry.key < items.length - 1 ? 14 : 0,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: const EdgeInsets.only(top: 3),
                        width: 6,
                        height: 6,
                        decoration: BoxDecoration(
                          color: TarotTheme.cosmicAccent,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          entry.value,
                          style: const TextStyle(
                            color: TarotTheme.softBlueGrey,
                            fontSize: 14,
                            height: 1.6,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
        ],
      ),
    );
  }

  String _getTitle(String locale) {
    switch (locale) {
      case 'ca':
        return 'El Teu Camí';
      case 'es':
        return 'Tu Camino';
      default:
        return 'Your Path';
    }
  }

  List<String> _getJourneyItems(String locale) {
    switch (locale) {
      case 'ca':
        return [
          'Connecta amb les 78 cartes i els seus significats',
          'Descobreix les influències astrals i els cicles lunars',
          'Aprèn tècniques de lectura per a tu i per als altres',
          'Explora la història i la tradició del tarot',
          'Crea rituals significatius i personalitzats',
        ];
      case 'es':
        return [
          'Conecta con las 78 cartas y sus significados',
          'Descubre las influencias astrales y los ciclos lunares',
          'Aprende técnicas de lectura para ti y para los demás',
          'Explora la historia y la tradición del tarot',
          'Crea rituales significativos y personalizados',
        ];
      default:
        return [
          'Connect with all 78 cards and their meanings',
          'Discover astral influences and lunar cycles',
          'Learn reading techniques for yourself and others',
          'Explore the history and tradition of tarot',
          'Create meaningful and personalized rituals',
        ];
    }
  }
}
