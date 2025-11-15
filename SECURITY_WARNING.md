# ⚠️ AVISO DE SEGURANÇA - CHAVES STRIPE

## 🚨 IMPORTANTE: Chave Secreta do Stripe

A chave secreta do Stripe (`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`) foi adicionada ao arquivo de configuração **APENAS PARA REFERÊNCIA**.

### ⚠️ NUNCA use a chave secreta no aplicativo mobile!

A chave secreta deve ser usada **APENAS no seu backend server**. Se ela for exposta no código do app mobile, qualquer pessoa poderá:
- Fazer pagamentos em nome do seu negócio
- Acessar dados sensíveis de clientes
- Modificar assinaturas e pagamentos
- Causar danos financeiros significativos

### ✅ O que fazer:

1. **Remova a chave secreta do arquivo de configuração do app mobile**
   - Ela deve estar apenas no seu backend
   - O app mobile só precisa da chave pública

2. **Use a chave secreta apenas no backend**
   - Configure no seu servidor backend
   - Use variáveis de ambiente
   - Nunca commite no repositório público

3. **Chave pública está segura**
   - A chave pública (`pk_live_...`) pode ser usada no app mobile
   - Ela é segura para ser exposta publicamente

### 📝 Próximos Passos:

1. **Remova a chave secreta do arquivo `lib/config/payment_config.dart`**
2. **Configure a chave secreta no seu backend server**
3. **Use apenas a chave pública no app mobile**
4. **Implemente o backend para processar pagamentos com segurança**

### 🔒 Exemplo de Configuração Segura:

**App Mobile (lib/config/payment_config.dart):**
```dart
static const String stripePublishableKey = 'pk_live_51STRZXEYtTHdCbed...'; // ✅ OK
// static const String stripeSecretKey = '...'; // ❌ REMOVER ESTA LINHA
```

**Backend Server (variáveis de ambiente):**
```bash
STRIPE_SECRET_KEY=sk_live_51STRZXEYtTHdCbed... # ✅ Configurado no servidor
```

### 📚 Documentação:

- [Stripe Security Best Practices](https://stripe.com/docs/security/guide)
- [How to Handle API Keys Securely](https://stripe.com/docs/keys)

### 🆘 Se a chave secreta foi exposta:

1. **Revogue a chave imediatamente no Stripe Dashboard**
2. **Gere uma nova chave secreta**
3. **Atualize todas as referências no backend**
4. **Monitore transações suspeitas**

---

**Data de criação deste aviso:** $(date)
**Status:** Chave secreta incluída no código - **REMOVER ANTES DO DEPLOY**

