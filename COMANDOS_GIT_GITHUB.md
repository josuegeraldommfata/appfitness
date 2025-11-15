# 📦 Comandos Git para Conectar ao GitHub

## 🚀 **Comandos Rápidos:**

### **Se Já Tem Repositório no GitHub:**

```bash
# 1. Ir para pasta do projeto
cd "C:\Users\FIREWALL\Pictures\niudge\nudge-main"

# 2. Inicializar Git (se ainda não tiver)
git init

# 3. Adicionar todos os arquivos
git add .

# 4. Primeiro commit
git commit -m "NUDGE app completo - backend e frontend"

# 5. Conectar ao GitHub (SUBSTITUA SEU_USUARIO pelo seu usuário do GitHub)
git remote add origin https://github.com/SEU_USUARIO/nudge-app.git

# 6. Renomear branch para main (se necessário)
git branch -M main

# 7. Fazer upload
git push -u origin main
```

⚠️ **Substitua `SEU_USUARIO` pelo seu usuário do GitHub!**

---

### **Criar Repositório no GitHub Primeiro:**

1. **Via Site:**
   - Acesse: https://github.com/new
   - Nome: `nudge-app`
   - Crie o repositório (SEM README)

2. **Depois execute os comandos acima**

---

### **Via GitHub Desktop (Mais Fácil):**

1. Baixe: https://desktop.github.com
2. Login
3. "File" → "Add Local Repository"
4. Selecione: `C:\Users\FIREWALL\Pictures\niudge\nudge-main`
5. "Publish repository" → Nome: `nudge-app`

✅ **Pronto!**

---

## 🔍 **Verificar Se Está Conectado:**

```bash
# Ver remotos
git remote -v

# Deve aparecer:
# origin  https://github.com/SEU_USUARIO/nudge-app.git (fetch)
# origin  https://github.com/SEU_USUARIO/nudge-app.git (push)
```

---

**🚀 Depois de conectar, volte ao Render e continue!**

