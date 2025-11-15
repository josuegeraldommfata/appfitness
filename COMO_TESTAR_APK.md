# 📱 Como Testar APK no Dispositivo Físico

## ⚠️ **IMPORTANTE: Problema do `localhost`**

O app está configurado para `http://localhost:3000`, mas isso **NÃO funciona** em dispositivo físico!

### **O Que Acontece:**
- ✅ **Emulador:** Funciona (usa `10.0.2.2:3000`)
- ❌ **Dispositivo Físico:** **NÃO funciona** (localhost = o próprio celular, não seu PC)

---

## 🎯 **Opções para Testar:**

### **Opção 1: Usar IP da Rede Local** ⭐ **PARA TESTAR AGORA**

Para testar em dispositivo físico na mesma rede WiFi:

1. **Descobrir IP do PC:**
   - Windows: Abra PowerShell e rode:
     ```powershell
     ipconfig
     ```
   - Procure por "IPv4 Address" (ex: `192.168.1.100`)

2. **Iniciar Backend:**
   ```bash
   cd backend
   npm start
   ```
   Deve estar rodando em `http://localhost:3000`

3. **Atualizar URL no App:**
   Edite `lib/config/payment_config.dart`:
   ```dart
   static const String backendApiUrl = 'http://192.168.1.100:3000'; // Substitua pelo IP do seu PC
   ```

4. **Gerar APK novamente:**
   ```bash
   flutter build apk --release
   ```

5. **Instalar no celular:**
   - Transfira o APK para o celular
   - Instale e teste

**⚠️ Limitação:** Só funciona se o celular estiver na mesma rede WiFi do PC!

---

### **Opção 2: Usar Backend na Nuvem** ⭐ **RECOMENDADO PARA PRODUÇÃO**

Para funcionar em qualquer lugar (sem depender da rede local):

1. **Fazer deploy no Render (grátis):**
   - Siga `DEPLOY_RENDER_GRATIS.md`

2. **Atualizar URL:**
   ```dart
   static const String backendApiUrl = 'https://seu-backend.onrender.com';
   ```

3. **Gerar APK:**
   ```bash
   flutter build apk --release
   ```

4. **Funciona em qualquer lugar!** ✅

---

## 🚀 **Gerar APK Agora (Para Testar com IP Local):**

### **1. Descobrir IP do PC:**

Abra PowerShell e rode:
```powershell
ipconfig | findstr IPv4
```

Anote o IP (ex: `192.168.1.100`)

### **2. Atualizar URL no App:**

Edite `lib/config/payment_config.dart`:
```dart
// Substitua pelo IP do seu PC
static const String backendApiUrl = 'http://SEU_IP_AQUI:3000';
```

### **3. Iniciar Backend:**

Abra terminal na pasta `backend`:
```bash
cd backend
npm start
```

Verifique que está rodando em `http://localhost:3000`

### **4. Gerar APK:**

Na raiz do projeto:
```bash
flutter build apk --release
```

### **5. APK Gerado:**

O APK estará em:
```
build/app/outputs/flutter-apk/app-release.apk
```

### **6. Instalar no Celular:**

1. Conecte celular via USB
2. Transfira o APK
3. Ou envie por WhatsApp/Email para você mesmo
4. Instale no celular
5. **IMPORTANTE:** Celular deve estar na **mesma rede WiFi** do PC!

---

## ✅ **Testar Login:**

1. Instale o APK no celular
2. Certifique-se que o celular está na mesma rede WiFi do PC
3. Certifique-se que o backend está rodando (`npm start`)
4. Abra o app
5. Teste login: `admin@test.com` / `admin123`

---

## 🆘 **Se Não Funcionar:**

### **Problema: "Connection refused" ou "Timeout"**

**Soluções:**
1. ✅ Verificar se backend está rodando
2. ✅ Verificar se IP está correto
3. ✅ Verificar se celular está na mesma rede WiFi
4. ✅ Verificar firewall do Windows (pode estar bloqueando porta 3000)

**Desabilitar Firewall Temporariamente (Para Testar):**
```powershell
# Desabilitar firewall (cuidado!)
netsh advfirewall set allprofiles state off

# Depois de testar, reabilitar:
netsh advfirewall set allprofiles state on
```

**Ou Permitir Porta 3000 no Firewall:**
```powershell
netsh advfirewall firewall add rule name="Node.js Backend" dir=in action=allow protocol=TCP localport=3000
```

---

## 💡 **Recomendação:**

Para testar rapidamente:
- ✅ Use IP da rede local
- ✅ Teste em mesma rede WiFi

Para produção real:
- ✅ Use backend na nuvem (Render grátis)
- ✅ Funciona em qualquer lugar
- ✅ Não depende da rede local

---

**🚀 Quer que eu ajude a gerar o APK agora?**

