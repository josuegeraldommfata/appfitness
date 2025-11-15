# Script para Atualizar URL do Backend no App Flutter
# Execute este script para atualizar a URL do backend no código

Write-Host "🔧 Atualizando URL do backend no app Flutter..." -ForegroundColor Green

# Solicitar URL do Railway
$railwayUrl = Read-Host "Digite a URL do seu backend no Railway (ex: https://nudge-backend.up.railway.app)"

if (-not $railwayUrl) {
    Write-Host "❌ URL não fornecida!" -ForegroundColor Red
    exit 1
}

# Remover barra final se houver
$railwayUrl = $railwayUrl.TrimEnd('/')

Write-Host "`n📝 Atualizando lib/config/payment_config.dart..." -ForegroundColor Yellow

$configFile = "lib/config/payment_config.dart"

if (-not (Test-Path $configFile)) {
    Write-Host "❌ Arquivo $configFile não encontrado!" -ForegroundColor Red
    exit 1
}

# Ler arquivo
$content = Get-Content $configFile -Raw

# Substituir URL
$oldPattern = '(static const String backendApiUrl = )([''"`])([^''"`]+)([''"`])(.*)'
$newContent = $content -replace $oldPattern, "`$1`$2$railwayUrl`$4 // PRODUÇÃO - Atualizado automaticamente"

# Backup do arquivo original
Copy-Item $configFile "$configFile.backup"

# Escrever arquivo atualizado
$newContent | Set-Content $configFile -NoNewline

Write-Host "✅ Arquivo atualizado!" -ForegroundColor Green
Write-Host "   Backup criado em: $configFile.backup" -ForegroundColor Yellow
Write-Host "   Nova URL: $railwayUrl" -ForegroundColor Cyan

Write-Host "`n📝 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Verifique o arquivo $configFile para confirmar a mudança" -ForegroundColor White
Write-Host "2. Execute 'flutter run' para testar o app" -ForegroundColor White
Write-Host "3. Se algo der errado, restaure o backup: Copy-Item '$configFile.backup' '$configFile'" -ForegroundColor White

