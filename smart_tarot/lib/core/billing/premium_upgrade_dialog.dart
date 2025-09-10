import 'package:flutter/material.dart';
import 'billing_service.dart';

class PremiumUpgradeDialog extends StatefulWidget {
  final BillingService billingService;
  final String locale;
  final String? triggerReason;

  const PremiumUpgradeDialog({
    super.key,
    required this.billingService,
    required this.locale,
    this.triggerReason,
  });

  @override
  State<PremiumUpgradeDialog> createState() => _PremiumUpgradeDialogState();
}

class _PremiumUpgradeDialogState extends State<PremiumUpgradeDialog>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<double> _fadeAnimation;
  
  bool _isProcessing = false;
  BillingPlan _selectedPlan = BillingPlan.premiumMonthly;

  @override
  void initState() {
    super.initState();
    
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );
    
    _scaleAnimation = Tween<double>(
      begin: 0.8,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.elasticOut,
    ));
    
    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeIn,
    ));
    
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) {
        return FadeTransition(
          opacity: _fadeAnimation,
          child: ScaleTransition(
            scale: _scaleAnimation,
            child: Dialog(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
              child: Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.surface,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildHeader(),
                    const SizedBox(height: 24),
                    _buildTriggerMessage(),
                    const SizedBox(height: 20),
                    _buildFeaturesList(),
                    const SizedBox(height: 24),
                    _buildPlanSelector(),
                    const SizedBox(height: 24),
                    _buildActionButtons(),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.primary,
            borderRadius: BorderRadius.circular(50),
          ),
          child: const Icon(
            Icons.auto_awesome,
            color: Colors.white,
            size: 32,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          _getTitle(),
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildTriggerMessage() {
    if (widget.triggerReason == null) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceVariant,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Icon(
            Icons.info_outline,
            color: Theme.of(context).colorScheme.primary,
            size: 20,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              _getTriggerMessage(),
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFeaturesList() {
    final features = widget.billingService.getPremiumFeatures(widget.locale);
    
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          _getFeaturesTitle(),
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.w600,
          ),
        ),
        const SizedBox(height: 12),
        ...features.entries.take(4).map((feature) => Padding(
          padding: const EdgeInsets.only(bottom: 8),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.primary,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 12,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  feature.value,
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ),
            ],
          ),
        )),
      ],
    );
  }

  Widget _buildPlanSelector() {
    return Column(
      children: [
        _buildPlanOption(
          plan: BillingPlan.premiumMonthly,
          title: _getMonthlyTitle(),
          price: widget.billingService.getMonthlyPrice(),
          subtitle: _getMonthlySubtitle(),
        ),
        const SizedBox(height: 12),
        _buildPlanOption(
          plan: BillingPlan.premiumAnnual,
          title: _getAnnualTitle(),
          price: widget.billingService.getAnnualPrice(),
          subtitle: _getAnnualSubtitle(),
          badge: _getSavingsBadge(),
        ),
      ],
    );
  }

  Widget _buildPlanOption({
    required BillingPlan plan,
    required String title,
    required String price,
    required String subtitle,
    String? badge,
  }) {
    final isSelected = _selectedPlan == plan;
    
    return GestureDetector(
      onTap: () => setState(() => _selectedPlan = plan),
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: isSelected 
              ? Theme.of(context).colorScheme.primaryContainer
              : Theme.of(context).colorScheme.surface,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isSelected 
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.outline,
            width: isSelected ? 2 : 1,
          ),
        ),
        child: Row(
          children: [
            Radio<BillingPlan>(
              value: plan,
              groupValue: _selectedPlan,
              onChanged: (value) => setState(() => _selectedPlan = value!),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Text(
                        title,
                        style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      if (badge != null) ...[
                        const SizedBox(width: 8),
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 2,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            badge,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                  Text(
                    subtitle,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: Theme.of(context).colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            ),
            Text(
              price,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.primary,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActionButtons() {
    return Column(
      children: [
        SizedBox(
          width: double.infinity,
          child: ElevatedButton(
            onPressed: _isProcessing ? null : _handleUpgrade,
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: _isProcessing
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : Text(_getUpgradeButtonText()),
          ),
        ),
        const SizedBox(height: 8),
        TextButton(
          onPressed: _isProcessing ? null : () => Navigator.of(context).pop(false),
          child: Text(_getCancelButtonText()),
        ),
        const SizedBox(height: 4),
        Text(
          _getDisclaimerText(),
          style: Theme.of(context).textTheme.bodySmall?.copyWith(
            color: Theme.of(context).colorScheme.onSurfaceVariant,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Future<void> _handleUpgrade() async {
    setState(() => _isProcessing = true);
    
    try {
      switch (_selectedPlan) {
        case BillingPlan.premiumMonthly:
          await widget.billingService.purchaseMonthly();
          break;
        case BillingPlan.premiumAnnual:
          await widget.billingService.purchaseAnnual();
          break;
        case BillingPlan.free:
          break; // Should not happen
      }
      
      // Listen for successful purchase
      widget.billingService.planChanges.listen((plan) {
        if (plan != BillingPlan.free && mounted) {
          Navigator.of(context).pop(true);
        }
      });
      
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Purchase failed: $e')),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isProcessing = false);
      }
    }
  }

  // Localized text methods
  String _getTitle() {
    const titles = {
      'en': 'Unlock Premium Features',
      'es': 'Desbloquea Funciones Premium',
      'ca': 'Desbloqueja Funcions Premium',
    };
    return titles[widget.locale] ?? titles['en']!;
  }

  String _getTriggerMessage() {
    const messages = {
      'weekly_limit': {
        'en': 'You\'ve reached your weekly free session limit.',
        'es': 'Has alcanzado tu límite semanal de sesiones gratuitas.',
        'ca': 'Has arribat al teu límit setmanal de sessions gratuïtes.',
      },
      'history_limit': {
        'en': 'Upgrade to access your complete reading history.',
        'es': 'Actualiza para acceder a tu historial completo de lecturas.',
        'ca': 'Actualitza per accedir al teu historial complet de lectures.',
      },
      'advanced_spread': {
        'en': 'Celtic Cross and advanced spreads require Premium.',
        'es': 'La Cruz Celta y tiradas avanzadas requieren Premium.',
        'ca': 'La Creu Celta i tirades avançades requereixen Premium.',
      },
    };
    
    final reasonMessages = messages[widget.triggerReason] ?? messages['weekly_limit']!;
    return reasonMessages[widget.locale] ?? reasonMessages['en']!;
  }

  String _getFeaturesTitle() {
    const titles = {
      'en': 'Premium includes:',
      'es': 'Premium incluye:',
      'ca': 'Premium inclou:',
    };
    return titles[widget.locale] ?? titles['en']!;
  }

  String _getMonthlyTitle() {
    const titles = {
      'en': 'Monthly',
      'es': 'Mensual',
      'ca': 'Mensual',
    };
    return titles[widget.locale] ?? titles['en']!;
  }

  String _getMonthlySubtitle() {
    const subtitles = {
      'en': 'Cancel anytime',
      'es': 'Cancela en cualquier momento',
      'ca': 'Cancel·la en qualsevol moment',
    };
    return subtitles[widget.locale] ?? subtitles['en']!;
  }

  String _getAnnualTitle() {
    const titles = {
      'en': 'Annual',
      'es': 'Anual',
      'ca': 'Anual',
    };
    return titles[widget.locale] ?? titles['en']!;
  }

  String _getAnnualSubtitle() {
    const subtitles = {
      'en': 'Best value - 2 months free',
      'es': 'Mejor valor - 2 meses gratis',
      'ca': 'Millor valor - 2 mesos gratuïts',
    };
    return subtitles[widget.locale] ?? subtitles['en']!;
  }

  String _getSavingsBadge() {
    const badges = {
      'en': 'SAVE 20%',
      'es': 'AHORRA 20%',
      'ca': 'ESTALVIA 20%',
    };
    return badges[widget.locale] ?? badges['en']!;
  }

  String _getUpgradeButtonText() {
    const texts = {
      'en': 'Start Premium',
      'es': 'Iniciar Premium',
      'ca': 'Iniciar Premium',
    };
    return texts[widget.locale] ?? texts['en']!;
  }

  String _getCancelButtonText() {
    const texts = {
      'en': 'Maybe later',
      'es': 'Tal vez más tarde',
      'ca': 'Potser més tard',
    };
    return texts[widget.locale] ?? texts['en']!;
  }

  String _getDisclaimerText() {
    const texts = {
      'en': 'Subscription auto-renews. Cancel anytime in Settings.',
      'es': 'La suscripción se renueva automáticamente. Cancela en cualquier momento en Configuración.',
      'ca': 'La subscripció es renova automàticament. Cancel·la en qualsevol moment a Configuració.',
    };
    return texts[widget.locale] ?? texts['en']!;
  }
}