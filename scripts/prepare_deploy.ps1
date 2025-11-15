# Script PowerShell para Preparar Deploy
# Execute este script para preparar tudo para o deploy

Write-Host "🚀 Preparando projeto para deploy no Railway..." -ForegroundColor Green

# Verificar se está na pasta correta
$projectRoot = Get-Location
if (-not (Test-Path "backend\server.js")) {
    Write-Host "❌ Erro: Execute este script na raiz do projeto!" -ForegroundColor Red
    exit 1
}

Write-Host "✅ Pasta do projeto encontrada: $projectRoot" -ForegroundColor Green

# Verificar Git
Write-Host "`n📦 Verificando Git..." -ForegroundColor Yellow
if (-not (Get-Command git -ErrorAction SilentlyContinue)) {
    Write-Host "⚠️  Git não encontrado. Instale Git: https://git-scm.com/downloads" -ForegroundColor Yellow
    Write-Host "   Ou use GitHub Desktop: https://desktop.github.com" -ForegroundColor Yellow
} else {
    Write-Host "✅ Git encontrado!" -ForegroundColor Green
    
    # Verificar se é repositório Git
    if (-not (Test-Path ".git")) {
        Write-Host "`n📝 Inicializando repositório Git..." -ForegroundColor Yellow
        git init
        git add .
        git commit -m "NUDGE app completo - pronto para deploy"
        Write-Host "✅ Repositório Git inicializado!" -ForegroundColor Green
    } else {
        Write-Host "✅ Repositório Git já existe!" -ForegroundColor Green
    }
}

# Verificar arquivos necessários
Write-Host "`n📋 Verificando arquivos necessários..." -ForegroundColor Yellow
$requiredFiles = @(
    "backend\server.js",
    "backend\package.json",
    "backend\Procfile",
    "backend\railway.toml"
)

$allFilesExist = $true
foreach ($file in $requiredFiles) {
    if (Test-Path $file) {
        Write-Host "  ✅ $file" -ForegroundColor Green
    } else {
        Write-Host "  ❌ $file não encontrado!" -ForegroundColor Red
        $allFilesExist = $false
    }
}

if (-not $allFilesExist) {
    Write-Host "`n❌ Alguns arquivos necessários estão faltando!" -ForegroundColor Red
    exit 1
}

# Verificar dependências do backend
Write-Host "`n📦 Verificando dependências do backend..." -ForegroundColor Yellow
if (Test-Path "backend\node_modules") {
    Write-Host "✅ node_modules encontrado!" -ForegroundColor Green
} else {
    Write-Host "⚠️  node_modules não encontrado. Instalando dependências..." -ForegroundColor Yellow
    Set-Location backend
    npm install
    Set-Location ..
    Write-Host "✅ Dependências instaladas!" -ForegroundColor Green
}

# Verificar .env
Write-Host "`n🔐 Verificando configurações..." -ForegroundColor Yellow
if (Test-Path "backend\.env") {
    Write-Host "✅ Arquivo .env encontrado!" -ForegroundColor Green
} else {
    Write-Host "⚠️  Arquivo .env não encontrado. Copiando de env.example..." -ForegroundColor Yellow
    if (Test-Path "backend\env.example") {
        Copy-Item "backend\env.example" "backend\.env"
        Write-Host "✅ Arquivo .env criado!" -ForegroundColor Green
        Write-Host "⚠️  IMPORTANTE: Configure as variáveis no arquivo .env!" -ForegroundColor Yellow
    }
}

# Resumo
Write-Host "`n✅ Preparação concluída!" -ForegroundColor Green
Write-Host "`n📝 Próximos passos:" -ForegroundColor Cyan
Write-Host "1. Se não tiver GitHub, crie uma conta em: https://github.com" -ForegroundColor White
Write-Host "2. Faça upload do código para GitHub (via GitHub Desktop ou Git)" -ForegroundColor White
Write-Host "3. Crie conta no Railway: https://railway.app" -ForegroundColor White
Write-Host "4. Faça login com GitHub" -ForegroundColor White
Write-Host "5. Crie novo projeto e conecte ao repositório GitHub" -ForegroundColor White
Write-Host "6. Configure Root Directory = 'backend'" -ForegroundColor White
Write-Host "7. Adicione variáveis de ambiente no Railway" -ForegroundColor White
Write-Host "8. Copie a URL gerada e atualize lib/config/payment_config.dart" -ForegroundColor White

Write-Host "`n📚 Veja COMEÇAR_DEPLOY_AQUI.md para guia completo!" -ForegroundColor Cyan

