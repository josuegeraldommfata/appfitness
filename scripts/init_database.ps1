# Script para Inicializar Banco de Dados
# Execute este script para inicializar o MongoDB Atlas

Write-Host "🗄️  Inicializando banco de dados MongoDB Atlas..." -ForegroundColor Green

# MongoDB URI
$mongodbUri = "mongodb+srv://Nudge:320809eu@nudge.ixd6wep.mongodb.net/nudge?retryWrites=true&w=majority"

# Verificar se está na pasta correta
if (-not (Test-Path "backend")) {
    Write-Host "❌ Erro: Execute este script na raiz do projeto!" -ForegroundColor Red
    exit 1
}

# Ir para pasta backend
Set-Location backend

# Verificar Node.js
if (-not (Get-Command node -ErrorAction SilentlyContinue)) {
    Write-Host "❌ Node.js não encontrado! Instale Node.js: https://nodejs.org" -ForegroundColor Red
    Set-Location ..
    exit 1
}

Write-Host "✅ Node.js encontrado!" -ForegroundColor Green

# Verificar dependências
if (-not (Test-Path "node_modules")) {
    Write-Host "`n📦 Instalando dependências..." -ForegroundColor Yellow
    npm install
    Write-Host "✅ Dependências instaladas!" -ForegroundColor Green
}

# Inicializar banco de dados
Write-Host "`n📦 Inicializando banco de dados (criando collections e indexes)..." -ForegroundColor Yellow
$env:MONGODB_URI = $mongodbUri
npm run init-db

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Banco de dados inicializado!" -ForegroundColor Green
} else {
    Write-Host "❌ Erro ao inicializar banco de dados!" -ForegroundColor Red
    Set-Location ..
    exit 1
}

# Criar usuários de teste
Write-Host "`n👥 Criando usuários de teste..." -ForegroundColor Yellow
npm run create-test-users

if ($LASTEXITCODE -eq 0) {
    Write-Host "✅ Usuários de teste criados!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Erro ao criar usuários de teste (pode ser que já existam)" -ForegroundColor Yellow
}

# Voltar para raiz
Set-Location ..

Write-Host "`n✅ Processo concluído!" -ForegroundColor Green
Write-Host "`n📝 Usuários de teste criados:" -ForegroundColor Cyan
Write-Host "   Admin: admin@test.com / admin123" -ForegroundColor White
Write-Host "   User:  user@test.com / user123" -ForegroundColor White

