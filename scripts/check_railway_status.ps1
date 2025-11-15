# Script para Verificar Status do Deploy no Railway
# Execute este script para verificar se o deploy foi concluído

Write-Host "🔍 Verificando status do deploy..." -ForegroundColor Green

# Solicitar URL do Railway
$railwayUrl = Read-Host "Digite a URL do seu backend no Railway (ex: https://nudge-backend.up.railway.app)"

if (-not $railwayUrl) {
    Write-Host "❌ URL não fornecida!" -ForegroundColor Red
    exit 1
}

# Remover barra final se houver
$railwayUrl = $railwayUrl.TrimEnd('/')

Write-Host "`n🌐 Testando backend em: $railwayUrl" -ForegroundColor Yellow

# Testar health check
try {
    Write-Host "`n📡 Testando health check..." -ForegroundColor Yellow
    $healthResponse = Invoke-WebRequest -Uri "$railwayUrl/health" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Health check OK!" -ForegroundColor Green
    Write-Host "   Status: $($healthResponse.StatusCode)" -ForegroundColor White
    Write-Host "   Resposta: $($healthResponse.Content)" -ForegroundColor White
} catch {
    Write-Host "❌ Health check falhou: $($_.Exception.Message)" -ForegroundColor Red
    Write-Host "⚠️  Verifique se o backend está rodando no Railway!" -ForegroundColor Yellow
}

# Testar root endpoint
try {
    Write-Host "`n📡 Testando endpoint raiz..." -ForegroundColor Yellow
    $rootResponse = Invoke-WebRequest -Uri "$railwayUrl/" -Method GET -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Endpoint raiz OK!" -ForegroundColor Green
    Write-Host "   Status: $($rootResponse.StatusCode)" -ForegroundColor White
    Write-Host "   Resposta: $($rootResponse.Content)" -ForegroundColor White
} catch {
    Write-Host "❌ Endpoint raiz falhou: $($_.Exception.Message)" -ForegroundColor Red
}

# Testar login
try {
    Write-Host "`n📡 Testando endpoint de login..." -ForegroundColor Yellow
    $loginBody = @{
        email = "admin@test.com"
        password = "admin123"
    } | ConvertTo-Json
    
    $loginResponse = Invoke-WebRequest -Uri "$railwayUrl/api/auth/login" -Method POST -Body $loginBody -ContentType "application/json" -TimeoutSec 10 -ErrorAction Stop
    Write-Host "✅ Login funcionando!" -ForegroundColor Green
    Write-Host "   Status: $($loginResponse.StatusCode)" -ForegroundColor White
    $responseData = $loginResponse.Content | ConvertFrom-Json
    if ($responseData.token) {
        Write-Host "   ✅ Token recebido!" -ForegroundColor Green
    }
} catch {
    Write-Host "⚠️  Login falhou (pode ser normal se banco não foi inicializado): $($_.Exception.Message)" -ForegroundColor Yellow
}

# Resumo
Write-Host "`n✅ Verificação concluída!" -ForegroundColor Green
Write-Host "`n📝 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Se tudo estiver OK, atualize lib/config/payment_config.dart com esta URL" -ForegroundColor White
Write-Host "2. Execute os scripts de inicialização do banco de dados" -ForegroundColor White
Write-Host "3. Teste o app Flutter com a nova URL" -ForegroundColor White

