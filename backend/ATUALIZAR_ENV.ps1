# Script para atualizar o arquivo .env com as chaves corretas
# Execute este script na pasta backend/

$envContent = @"
# MongoDB Atlas Configuration
MONGODB_URI=mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority

# Server Configuration
PORT=3000
NODE_ENV=development

# Stripe Configuration
STRIPE_SECRET_KEY=sk_live_YOUR_STRIPE_SECRET_KEY_HERE
STRIPE_WEBHOOK_SECRET=whsec_your_webhook_secret_here

# Mercado Pago Configuration
MERCADOPAGO_ACCESS_TOKEN=APP_USR-YOUR_MERCADOPAGO_ACCESS_TOKEN_HERE
MERCADOPAGO_PUBLIC_KEY=APP_USR-d766e8e8-fa64-4265-b19a-5295dc6a0a7f
MERCADOPAGO_SUCCESS_URL=https://your-app.com/success
MERCADOPAGO_FAILURE_URL=https://your-app.com/failure
MERCADOPAGO_PENDING_URL=https://your-app.com/pending

# OpenAI ChatGPT Configuration
OPENAI_API_KEY=sk-YOUR_OPENAI_API_KEY_HERE
"@

$envContent | Out-File -FilePath ".env" -Encoding utf8 -Force

Write-Host "Arquivo .env atualizado com sucesso!" -ForegroundColor Green
Write-Host "Chaves configuradas:" -ForegroundColor Cyan
Write-Host "  - Stripe Secret Key" -ForegroundColor White
Write-Host "  - Mercado Pago Access Token" -ForegroundColor White
Write-Host "  - OpenAI API Key" -ForegroundColor White
Write-Host ""
Write-Host "Agora reinicie o backend para carregar as novas chaves!" -ForegroundColor Yellow
