# 🔧 Solução: Credenciais Inválidas

## ⚠️ **Problema:**
O app está dando "credenciais inválidas" ao tentar fazer login.

---

## 🔍 **Possíveis Causas:**

### **1. URL do Backend Incorreta** ⭐ **MAIS COMUM**

O app está configurado para `http://localhost:3000`, que **NÃO funciona** em dispositivo físico!

**Solução:**
- **Se estiver usando EMULADOR:** `localhost:3000` funciona ✅
- **Se estiver usando DISPOSITIVO FÍSICO:** Precisa usar IP da rede local (ex: `192.168.100.158:3000`)

---

### **2. Backend Não Está Rodando**

Verifique se o backend está rodando:
```bash
cd backend
npm start
```

Você deve ver:
```
🚀 Server running on port 3000
```

---

### **3. Celular Não Está na Mesma Rede WiFi**

**Para dispositivo físico:**
- Celular e PC devem estar na **mesma rede WiFi**
- Não pode usar dados móveis

---

### **4. Usuários Não Foram Criados**

Execute para criar usuários:
```bash
cd backend
npm run create-demo-users
```

---

## ✅ **Soluções:**

### **Solução 1: Usar IP da Rede Local (Para Dispositivo Físico)**

1. **Descobrir IP do PC:**
   ```powershell
   ipconfig | findstr IPv4
   ```
   Exemplo: `192.168.100.158`

2. **Atualizar URL no App:**
   Edite `lib/config/payment_config.dart`:
   ```dart
   // De:
   static const String backendApiUrl = 'http://localhost:3000';
   
   // Para:
   static const String backendApiUrl = 'http://192.168.100.158:3000'; // Use seu IP
   ```

3. **Gerar Novo APK:**
   ```bash
   flutter clean
   flutter pub get
   flutter build apk --release
   ```

4. **Instalar Novo APK no Celular**

---

### **Solução 2: Verificar Backend está Respondendo**

Teste no navegador do celular:
```
http://192.168.100.158:3000
```

Deve aparecer:
```json
{
  "message": "NUDGE Backend API",
  "version": "1.0.0",
  "status": "running"
}
```

Se não funcionar:
- Verifique se backend está rodando
- Verifique se celular está na mesma rede WiFi
- Verifique firewall do Windows (pode estar bloqueando porta 3000)

---

### **Solução 3: Criar/Verificar Usuários**

Execute:
```bash
cd backend
npm run create-demo-users
```

Deve aparecer:
```
✅ User demoadmin@email.com created successfully
✅ User demouser@email.com created successfully
```

---

### **Solução 4: Testar Login Via API**

No PowerShell:
```powershell
$body = @{email='demoadmin@email.com';password='admin123'} | ConvertTo-Json
Invoke-WebRequest -Uri http://localhost:3000/api/auth/login -Method POST -Body $body -ContentType 'application/json'
```

Se funcionar, deve retornar token e dados do usuário.

---

## 📋 **Checklist:**

- [ ] Backend está rodando (`npm start`)
- [ ] Usuários foram criados (`npm run create-demo-users`)
- [ ] URL do backend está correta no app
- [ ] Se dispositivo físico: usando IP da rede local (não localhost)
- [ ] Celular está na mesma rede WiFi do PC
- [ ] Firewall não está bloqueando porta 3000

---

## 🎯 **Credenciais de Teste:**

- Email: `demoadmin@email.com`
- Senha: `admin123`

OU

- Email: `demouser@email.com`
- Senha: `user123`

---

**🔧 Siga as soluções acima para resolver o problema!**

