# Script Completo para Preparar Deploy
# Este script executa todos os passos automáticos possíveis

Write-Host "🚀 Script Completo de Deploy - NUDGE App" -ForegroundColor Green
Write-Host "=" * 60 -ForegroundColor Cyan

# Passo 1: Preparar projeto
Write-Host "`n[1/4] Preparando projeto..." -ForegroundColor Yellow
& "$PSScriptRoot\prepare_deploy.ps1"

if ($LASTEXITCODE -ne 0) {
    Write-Host "❌ Erro na preparação!" -ForegroundColor Red
    exit 1
}

# Passo 2: Verificar Git
Write-Host "`n[2/4] Verificando Git..." -ForegroundColor Yellow
if (Test-Path ".git") {
    Write-Host "✅ Repositório Git encontrado!" -ForegroundColor Green
    
    # Verificar status
    $gitStatus = git status --short 2>$null
    if ($gitStatus) {
        Write-Host "⚠️  Há mudanças não commitadas!" -ForegroundColor Yellow
        $commit = Read-Host "Deseja fazer commit? (s/n)"
        if ($commit -eq "s" -or $commit -eq "S") {
            git add .
            $commitMsg = Read-Host "Digite a mensagem do commit (ou Enter para padrão)"
            if (-not $commitMsg) {
                $commitMsg = "Preparar para deploy no Railway"
            }
            git commit -m $commitMsg
            Write-Host "✅ Commit realizado!" -ForegroundColor Green
        }
    }
    
    # Verificar remoto
    $remotes = git remote 2>$null
    if (-not $remotes) {
        Write-Host "⚠️  Nenhum remoto configurado!" -ForegroundColor Yellow
        Write-Host "   Você precisa adicionar o remoto do GitHub manualmente:" -ForegroundColor White
        Write-Host "   git remote add origin https://github.com/SEU_USUARIO/nudge-app.git" -ForegroundColor Cyan
    } else {
        Write-Host "✅ Remoto Git configurado!" -ForegroundColor Green
    }
} else {
    Write-Host "⚠️  Repositório Git não encontrado!" -ForegroundColor Yellow
    Write-Host "   Execute: git init" -ForegroundColor White
}

# Passo 3: Inicializar banco
Write-Host "`n[3/4] Deseja inicializar o banco de dados agora?" -ForegroundColor Yellow
$initDb = Read-Host "Digite 's' para inicializar ou 'n' para pular (s/n)"
if ($initDb -eq "s" -or $initDb -eq "S") {
    & "$PSScriptRoot\init_database.ps1"
}

# Passo 4: Resumo
Write-Host "`n[4/4] Resumo" -ForegroundColor Yellow
Write-Host "=" * 60 -ForegroundColor Cyan
Write-Host "✅ Preparação concluída!" -ForegroundColor Green
Write-Host "`n📝 PRÓXIMOS PASSOS MANUAIS:" -ForegroundColor Cyan
Write-Host "1. Faça upload do código para GitHub (se ainda não fez)" -ForegroundColor White
Write-Host "   - GitHub Desktop: https://desktop.github.com" -ForegroundColor White
Write-Host "   - Ou: git remote add origin <URL> && git push -u origin main" -ForegroundColor White
Write-Host "`n2. Crie conta no Railway: https://railway.app" -ForegroundColor White
Write-Host "`n3. No Railway:" -ForegroundColor White
Write-Host "   - New Project → Deploy from GitHub repo" -ForegroundColor White
Write-Host "   - Selecione seu repositório" -ForegroundColor White
Write-Host "   - Configure Root Directory = 'backend'" -ForegroundColor White
Write-Host "   - Adicione variáveis de ambiente:" -ForegroundColor White
Write-Host "     * NODE_ENV=production" -ForegroundColor Gray
Write-Host "     * MONGODB_URI=mongodb+srv://Nudge:320809eu@..." -ForegroundColor Gray
Write-Host "`n4. Após deploy, copie a URL do Railway" -ForegroundColor White
Write-Host "`n5. Execute: scripts\update_app_url.ps1" -ForegroundColor White
Write-Host "`n6. Teste: scripts\check_railway_status.ps1" -ForegroundColor White

Write-Host "`n📚 Veja COMEÇAR_DEPLOY_AQUI.md para guia completo!" -ForegroundColor Cyan
Write-Host "=" * 60 -ForegroundColor Cyan

