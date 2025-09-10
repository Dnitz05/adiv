import 'dart:async';
import 'package:in_app_purchase/in_app_purchase.dart';

enum BillingPlan {
  free,
  premiumMonthly,
  premiumAnnual,
}

class BillingService {
  static const String monthlyProductId = 'premium_monthly';
  static const String annualProductId = 'premium_annual';
  
  final InAppPurchase _inAppPurchase = InAppPurchase.instance;
  late StreamSubscription<List<PurchaseDetails>> _subscription;
  
  final Set<String> _productIds = {monthlyProductId, annualProductId};
  List<ProductDetails> _products = [];
  
  // Stream controllers for billing events
  final StreamController<BillingPlan> _planChangeController = 
      StreamController<BillingPlan>.broadcast();
  final StreamController<String> _errorController = 
      StreamController<String>.broadcast();
  
  // Public streams
  Stream<BillingPlan> get planChanges => _planChangeController.stream;
  Stream<String> get errors => _errorController.stream;
  
  // Current state
  BillingPlan _currentPlan = BillingPlan.free;
  DateTime? _premiumExpiryDate;
  DateTime? _lastFreeSessionDate;
  
  BillingPlan get currentPlan => _currentPlan;
  DateTime? get premiumExpiryDate => _premiumExpiryDate;
  bool get isPremium => _currentPlan != BillingPlan.free && 
      (_premiumExpiryDate?.isAfter(DateTime.now()) ?? false);
  List<ProductDetails> get products => _products;

  Future<void> initialize() async {
    try {
      final bool available = await _inAppPurchase.isAvailable();
      if (!available) {
        throw BillingException('In-app purchases not available on this device');
      }

      // Load product details
      final ProductDetailsResponse response = 
          await _inAppPurchase.queryProductDetails(_productIds);
      
      if (response.notFoundIDs.isNotEmpty) {
        print('Products not found: ${response.notFoundIDs}');
      }
      
      _products = response.productDetails;
      
      // Listen to purchase stream
      _subscription = _inAppPurchase.purchaseStream.listen(
        _handlePurchaseUpdates,
        onError: (error) => _errorController.add(error.toString()),
      );
      
      // Restore previous purchases
      await restorePurchases();
      
    } catch (e) {
      _errorController.add('Failed to initialize billing: $e');
      rethrow;
    }
  }

  Future<void> purchaseMonthly() async {
    await _purchaseProduct(monthlyProductId);
  }

  Future<void> purchaseAnnual() async {
    await _purchaseProduct(annualProductId);
  }

  Future<void> _purchaseProduct(String productId) async {
    final ProductDetails? product = _products
        .where((p) => p.id == productId)
        .cast<ProductDetails?>()
        .firstWhere((p) => p != null, orElse: () => null);
    
    if (product == null) {
      throw BillingException('Product $productId not found');
    }

    try {
      final PurchaseParam param = PurchaseParam(productDetails: product);
      final bool success = await _inAppPurchase.buyNonConsumable(
        purchaseParam: param,
      );
      
      if (!success) {
        throw BillingException('Failed to initiate purchase');
      }
    } catch (e) {
      _errorController.add('Purchase failed: $e');
      rethrow;
    }
  }

  Future<void> restorePurchases() async {
    try {
      await _inAppPurchase.restorePurchases();
    } catch (e) {
      _errorController.add('Failed to restore purchases: $e');
    }
  }

  void _handlePurchaseUpdates(List<PurchaseDetails> purchaseDetailsList) {
    for (final PurchaseDetails purchaseDetails in purchaseDetailsList) {
      switch (purchaseDetails.status) {
        case PurchaseStatus.pending:
          // Show loading indicator
          break;
          
        case PurchaseStatus.purchased:
        case PurchaseStatus.restored:
          _handleSuccessfulPurchase(purchaseDetails);
          break;
          
        case PurchaseStatus.error:
          _errorController.add(
            'Purchase error: ${purchaseDetails.error?.message ?? 'Unknown error'}'
          );
          break;
          
        case PurchaseStatus.canceled:
          // User canceled, no action needed
          break;
      }
      
      // Complete the purchase
      if (purchaseDetails.pendingCompletePurchase) {
        _inAppPurchase.completePurchase(purchaseDetails);
      }
    }
  }

  void _handleSuccessfulPurchase(PurchaseDetails purchaseDetails) {
    final String productId = purchaseDetails.productID;
    final DateTime now = DateTime.now();
    
    switch (productId) {
      case monthlyProductId:
        _currentPlan = BillingPlan.premiumMonthly;
        _premiumExpiryDate = now.add(const Duration(days: 31));
        break;
        
      case annualProductId:
        _currentPlan = BillingPlan.premiumAnnual;
        _premiumExpiryDate = now.add(const Duration(days: 365));
        break;
        
      default:
        _errorController.add('Unknown product ID: $productId');
        return;
    }
    
    _planChangeController.add(_currentPlan);
    
    // Save to local storage
    _saveBillingState();
  }

  // Free tier limitations
  bool canStartFreeSession() {
    if (isPremium) return true;
    
    if (_lastFreeSessionDate == null) return true;
    
    final daysSinceLastFree = DateTime.now()
        .difference(_lastFreeSessionDate!)
        .inDays;
    
    return daysSinceLastFree >= 7; // One free session per week
  }

  void recordFreeSession() {
    if (!isPremium) {
      _lastFreeSessionDate = DateTime.now();
      _saveBillingState();
    }
  }

  int getMaxHistorySessions() {
    return isPremium ? -1 : 3; // Unlimited for premium, 3 for free
  }

  bool canExportData() {
    return isPremium;
  }

  bool canAccessAdvancedSpreads() {
    return isPremium;
  }

  bool canGetWeeklyPlans() {
    return isPremium;
  }

  // Pricing information
  String getMonthlyPrice() {
    final product = _products
        .where((p) => p.id == monthlyProductId)
        .cast<ProductDetails?>()
        .firstWhere((p) => p != null, orElse: () => null);
    
    return product?.price ?? '\$4.99';
  }

  String getAnnualPrice() {
    final product = _products
        .where((p) => p.id == annualProductId)
        .cast<ProductDetails?>()
        .firstWhere((p) => p != null, orElse: () => null);
    
    return product?.price ?? '\$39.99';
  }

  String getAnnualSavings() {
    final monthly = _products
        .where((p) => p.id == monthlyProductId)
        .cast<ProductDetails?>()
        .firstWhere((p) => p != null, orElse: () => null);
    
    final annual = _products
        .where((p) => p.id == annualProductId)
        .cast<ProductDetails?>()
        .firstWhere((p) => p != null, orElse: () => null);
    
    if (monthly == null || annual == null) return '20%';
    
    // This is simplified - in real app you'd parse currency amounts
    return '20%'; // Placeholder
  }

  // Local storage (simplified - would use SharedPreferences or Isar)
  void _saveBillingState() {
    // Save current plan, expiry date, last free session date
    // Implementation would depend on chosen storage solution
  }

  Future<void> _loadBillingState() async {
    // Load billing state from local storage
    // Implementation would depend on chosen storage solution
  }

  // Premium upgrade prompts
  Map<String, String> getPremiumFeatures(String locale) {
    const features = {
      'en': {
        'unlimited_sessions': 'Unlimited readings',
        'full_history': 'Complete reading history',
        'advanced_spreads': 'Celtic Cross & advanced spreads',
        'weekly_plans': '7-day personalized action plans',
        'export_data': 'Export readings as PDF',
        'priority_support': 'Priority customer support',
      },
      'es': {
        'unlimited_sessions': 'Lecturas ilimitadas',
        'full_history': 'Historial completo de lecturas',
        'advanced_spreads': 'Cruz Celta y tiradas avanzadas',
        'weekly_plans': 'Planes de acción personalizados de 7 días',
        'export_data': 'Exportar lecturas como PDF',
        'priority_support': 'Soporte prioritario al cliente',
      },
      'ca': {
        'unlimited_sessions': 'Lectures il·limitades',
        'full_history': 'Historial complet de lectures',
        'advanced_spreads': 'Creu Celta i tirades avançades',
        'weekly_plans': 'Plans d\'acció personalitzats de 7 dies',
        'export_data': 'Exportar lectures com PDF',
        'priority_support': 'Suport prioritari al client',
      },
    };
    
    return features[locale] ?? features['en']!;
  }

  void dispose() {
    _subscription.cancel();
    _planChangeController.close();
    _errorController.close();
  }
}

class BillingException implements Exception {
  final String message;
  const BillingException(this.message);
  
  @override
  String toString() => 'BillingException: $message';
}