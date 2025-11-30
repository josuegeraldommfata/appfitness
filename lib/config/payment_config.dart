// Payment Configuration
// TODO: Replace with your actual API keys
// These should be stored securely, preferably in environment variables or secure storage

class PaymentConfig {
  // Stripe Keys
  // Get these from: https://dashboard.stripe.com/apikeys
  // ⚠️ IMPORTANT: This is a LIVE key - keep it secure!
  // In production, consider using environment variables or secure storage
  static const String stripePublishableKey = 'pk_live_51STRZXEYtTHdCbedqp9M4oOaHH0Bt7HFBQdQkoRFxvkkgc78AfaD85p08BlcsuJxdO0tBRu0jlzPsJNp6HhNJEEA00wg0NJVT7';
  
  // ⚠️ SECURITY WARNING: Never expose secret keys in the mobile app!
  // This should ONLY be used in your backend server
  // Backend should use: sk_live_YOUR_SECRET_KEY_HERE (configure sua chave no backend)
  // ⚠️ DO NOT include the secret key in the mobile app code!
  // static const String stripeSecretKey = 'REMOVED_FOR_SECURITY'; // Use only in backend
  
  // Mercado Pago Keys
  // Get these from: https://www.mercadopago.com.br/developers/panel/credentials
  // ✅ Public Key - Safe to use in mobile app
  static const String mercadoPagoPublicKey = 'APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f'; // Public key é segura para usar no app
  
  // ⚠️ SECURITY WARNING: Never expose access token in the mobile app!
  // This should ONLY be used in your backend server
  // Backend should use: APP_USR-... (configure seu token no backend)
  // ⚠️ DO NOT include the access token in the mobile app code!
  // static const String mercadoPagoAccessToken = 'REMOVED_FOR_SECURITY'; // Use only in backend
  
  // Backend API URL for handling payments securely
  // This should be your backend server that handles payment processing
  // Never expose secret keys in the mobile app!
  // 
  // ⚠️ IMPORTANTE PARA PRODUÇÃO:
  // - Para desenvolvimento: http://localhost:3000 (use apenas em emulador/testes)
  // - Para teste em dispositivo físico: http://192.168.100.158:3000 (IP da rede local)
  // - Para produção: https://seu-backend.onrender.com (ou outro serviço)
  // 
  // ⚠️ NUNCA use localhost quando publicar na Play Store!
  // O app na Play Store precisa de uma URL pública (HTTPS)
  // ⚠️ IMPORTANTE: Atualize o IP conforme necessário
  // Para EMULADOR (Genymotion/Android Studio): 
  //   - Tente primeiro: 'http://10.0.2.2:3000' (padrão Android)
  //   - Se não funcionar: use o IP real da máquina (ex: 'http://192.168.131.2:3000')
  // Para DISPOSITIVO FÍSICO: use o IP da sua rede local (ex: 'http://192.168.131.2:3000')
  // Para PRODUÇÃO: use URL HTTPS do servidor (ex: 'https://seu-backend.onrender.com')
  
  // ⚠️ GENYMOTION: Alguns Genymotion têm problemas com 10.0.2.2, use o IP real da máquina
  // static const String backendApiUrl = 'http://10.0.2.2:3000'; // ANDROID STUDIO EMULATOR - Padrão
  static const String backendApiUrl = 'http://192.168.131.2:3000'; // GENYMOTION - IP real da máquina host (funciona melhor)
  // static const String backendApiUrl = 'http://192.168.131.2:3000'; // DISPOSITIVO FÍSICO - Mesma rede WiFi
  // static const String backendApiUrl = 'http://localhost:3000'; // iOS Simulator
  // static const String backendApiUrl = 'https://seu-backend.onrender.com'; // PRODUÇÃO - Descomente após deploy na nuvem
  
  // Stripe Price IDs
  // Created in Stripe Dashboard: https://dashboard.stripe.com/products
  static const Map<String, Map<String, String>> stripePriceIds = {
    'personal': {
      'monthly': 'price_1STSDLEYtTHdCbedsIDi3Sxh',
      'yearly': 'price_1STSEGEYtTHdCbedwqkL8Fwb',
    },
    'personalPlus': {
      'monthly': 'price_1STSNREYtTHdCbedeA8EcOY5',
      'yearly': 'price_1STSNtEYtTHdCbediOeGqJ5i',
    },
    'leader': {
      'monthly': 'price_1STSQUEYtTHdCbed8wktVd1G',
      'yearly': 'price_1STSRFEYtTHdCbed6UFpx484',
    },
  };
  
  // Stripe Product IDs (for reference)
  static const Map<String, String> stripeProductIds = {
    'personal': 'prod_TQIoHJdf1Mn967',
    'personalPlus': 'prod_TQIzygDRhqOEZ3',
    'leader': 'prod_TQJ2mm7H9wQJdU',
  };
  
  // Mercado Pago Plan IDs
  // Create these in your Mercado Pago Dashboard
  static const Map<String, Map<String, String>> mercadoPagoPlanIds = {
    'personal': {
      'monthly': 'plan_personal_monthly',
      'yearly': 'plan_personal_yearly',
    },
    'personalPlus': {
      'monthly': 'plan_personal_plus_monthly',
      'yearly': 'plan_personal_plus_yearly',
    },
    'leader': {
      'monthly': 'plan_leader_monthly',
      'yearly': 'plan_leader_yearly',
    },
  };
}

