# 📱 CHECKLIST COMPLETO - Produção e Play Store

## 🎯 Status Atual do Projeto

### ✅ **O que está funcionando:**
- ✅ Autenticação completa (Firebase Auth + Firestore)
- ✅ Sistema de refeições e bebidas funcionando
- ✅ Perfil do usuário
- ✅ Sistema de planos e assinaturas
- ✅ Integração Stripe e Mercado Pago (backend)
- ✅ Dashboard admin
- ✅ Telas principais implementadas
- ✅ Navegação funcional

### ⚠️ **O que precisa ser corrigido/implementado:**

---

## 🔴 **CRÍTICO - Bloqueia publicação na Play Store:**

### 1. **Configuração do App Android**

#### 1.1. Application ID e Nome do App
- [ ] **Alterar `applicationId`** em `android/app/build.gradle.kts`
  - Atual: `com.example.myapp`
  - Deve ser: `com.fitlifecoach.app` (ou outro único)
  - **Ação:** Editar linha 28 de `android/app/build.gradle.kts`

- [ ] **Alterar nome do app** em `AndroidManifest.xml`
  - Atual: `android:label="myapp"`
  - Deve ser: `android:label="FitLife Coach"`
  - **Ação:** Editar linha 3 de `android/app/src/main/AndroidManifest.xml`

- [ ] **Alterar nome do pacote** em `pubspec.yaml`
  - Atual: `name: myapp`
  - Deve ser: `name: fitlifecoach` (sem espaços, minúsculas)
  - **Ação:** Editar linha 1 de `pubspec.yaml`

#### 1.2. Versão do App
- [ ] **Atualizar versão** em `pubspec.yaml`
  - Atual: `version: 1.0.0+1`
  - Para Play Store: `version: 1.0.0+1` (OK para primeira versão)
  - **Nota:** Incremente o número após `+` para cada build

#### 1.3. Ícone do App
- [ ] **Criar ícone personalizado** (1024x1024px)
  - Substituir `android/app/src/main/res/mipmap-*/ic_launcher.png`
  - Usar ferramenta: https://appicon.co ou https://icon.kitchen
  - **Ação:** Gerar todos os tamanhos e substituir

#### 1.4. Splash Screen
- [ ] **Criar splash screen personalizado**
  - Editar `android/app/src/main/res/drawable/launch_background.xml`
  - Adicionar logo/branding do FitLife Coach

### 2. **Assinatura Digital (Keystore)**

- [ ] **Criar keystore para release**
  ```bash
  keytool -genkey -v -keystore ~/fitlifecoach-key.jks -keyalg RSA -keysize 2048 -validity 10000 -alias fitlifecoach
  ```
  - **IMPORTANTE:** Guarde a senha e o arquivo em local seguro!

- [ ] **Configurar assinatura em `android/app/build.gradle.kts`**
  - Criar arquivo `android/key.properties`:
    ```properties
    storePassword=sua_senha_aqui
    keyPassword=sua_senha_aqui
    keyAlias=fitlifecoach
    storeFile=C:/caminho/para/fitlifecoach-key.jks
    ```
  - Atualizar `build.gradle.kts` para usar o keystore

- [ ] **NUNCA commitar o keystore no Git!**
  - Adicionar ao `.gitignore`:
    ```
    *.jks
    *.keystore
    key.properties
    ```

### 3. **URL do Backend em Produção**

- [ ] **Atualizar URL do backend** em `lib/config/payment_config.dart`
  - Atual: `http://192.168.131.2:3000` (desenvolvimento)
  - Deve ser: `https://seu-backend.onrender.com` (produção)
  - **Ação:** Descomentar linha de produção e comentar desenvolvimento

- [ ] **Fazer deploy do backend** em produção
  - Render.com (grátis) ou Railway.app
  - Configurar variáveis de ambiente
  - Testar todos os endpoints

### 4. **Permissões do Android**

- [ ] **Adicionar permissões necessárias** em `AndroidManifest.xml`
  ```xml
  <uses-permission android:name="android.permission.INTERNET"/>
  <uses-permission android:name="android.permission.ACCESS_NETWORK_STATE"/>
  <!-- Se usar câmera para escanear códigos -->
  <uses-permission android:name="android.permission.CAMERA"/>
  <!-- Se usar localização -->
  <uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
  ```

### 5. **Política de Privacidade e Termos de Uso**

- [ ] **Criar Política de Privacidade**
  - URL pública (ex: https://fitlifecoach.com/privacy)
  - Deve incluir:
    - Quais dados são coletados
    - Como os dados são usados
    - Compartilhamento de dados
    - Direitos do usuário (LGPD/GDPR)
    - Contato para questões de privacidade

- [ ] **Criar Termos de Uso**
  - URL pública (ex: https://fitlifecoach.com/terms)
  - Deve incluir:
    - Regras de uso do app
    - Responsabilidades
    - Limitações de garantia
    - Propriedade intelectual

- [ ] **Adicionar links no app**
  - Tela de configurações
  - Tela de login/registro
  - Footer do app

### 6. **Conformidade com LGPD/GDPR**

- [ ] **Implementar consentimento de dados**
  - Tela de consentimento na primeira execução
  - Opção de aceitar/recusar coleta de dados
  - Salvar preferência do usuário

- [ ] **Implementar exclusão de dados**
  - Botão "Excluir minha conta" no perfil
  - Deletar todos os dados do usuário (Firestore + MongoDB)
  - Confirmar exclusão

### 7. **Firebase - Índices do Firestore**

- [ ] **Criar índices compostos no Firebase Console**
  - Link para `meals`: https://console.firebase.google.com/v1/r/project/nudge-88445/firestore/indexes?create_composite=...
  - Link para `drinks`: https://console.firebase.google.com/v1/r/project/nudge-88445/firestore/indexes?create_composite=...
  - Link para `body_metrics`: https://console.firebase.google.com/v1/r/project/nudge-88445/firestore/indexes?create_composite=...
  - **Ação:** Acessar os links e criar os índices

---

## 🟡 **IMPORTANTE - Melhora qualidade e experiência:**

### 8. **Tratamento de Erros**

- [ ] **Melhorar mensagens de erro**
  - Substituir `print()` por logs estruturados
  - Mostrar mensagens amigáveis ao usuário
  - Implementar retry automático para erros de rede

- [ ] **Tratamento de conexão offline**
  - Detectar quando está offline
  - Mostrar mensagem apropriada
  - Sincronizar dados quando voltar online

### 9. **Validação e Segurança**

- [ ] **Validar inputs do usuário**
  - Email válido
  - Senha forte (mínimo 8 caracteres)
  - Campos obrigatórios
  - Formato de dados

- [ ] **Sanitizar dados antes de salvar**
  - Prevenir SQL injection (Firestore já protege)
  - Validar tipos de dados
  - Limitar tamanho de inputs

- [ ] **Implementar rate limiting no backend**
  - Limitar tentativas de login
  - Limitar requisições por IP
  - Prevenir abuso da API

### 10. **Performance e Otimização**

- [ ] **Otimizar imagens**
  - Comprimir assets
  - Usar formatos modernos (WebP)
  - Lazy loading de imagens

- [ ] **Implementar cache**
  - Cache de dados do usuário
  - Cache de listas de alimentos
  - Reduzir chamadas à API

- [ ] **Otimizar queries do Firestore**
  - Usar índices corretos
  - Limitar quantidade de dados retornados
  - Paginar listas grandes

### 11. **Testes**

- [ ] **Testes em dispositivos reais**
  - Testar em diferentes tamanhos de tela
  - Testar em diferentes versões do Android (API 21+)
  - Testar em dispositivos de baixo desempenho

- [ ] **Testes de funcionalidades críticas**
  - Login/Registro
  - Adicionar refeições/bebidas
  - Pagamentos (Stripe/Mercado Pago)
  - Assinaturas

- [ ] **Testes de usabilidade**
  - Fluxo completo do usuário
  - Navegação entre telas
  - Feedback visual

### 12. **Documentação**

- [ ] **README.md atualizado**
  - Instruções de instalação
  - Como configurar o projeto
  - Variáveis de ambiente necessárias

- [ ] **Documentação da API**
  - Swagger/OpenAPI
  - Exemplos de requisições
  - Códigos de erro

---

## 🟢 **DESEJÁVEL - Funcionalidades extras:**

### 13. **Notificações Push**

- [ ] **Configurar Firebase Cloud Messaging (FCM)**
  - Notificações de lembretes
  - Notificações de conquistas
  - Notificações de promoções

### 14. **Analytics**

- [ ] **Integrar Firebase Analytics**
  - Rastrear eventos importantes
  - Entender comportamento do usuário
  - Métricas de uso

### 15. **Crash Reporting**

- [ ] **Integrar Firebase Crashlytics**
  - Rastrear crashes
  - Receber relatórios de erros
  - Priorizar correções

### 16. **Melhorias de UI/UX**

- [ ] **Animações suaves**
  - Transições entre telas
  - Feedback visual em ações
  - Loading states

- [ ] **Acessibilidade**
  - Suporte a leitores de tela
  - Contraste adequado
  - Tamanhos de fonte ajustáveis

### 17. **Internacionalização (i18n)**

- [ ] **Suporte a múltiplos idiomas**
  - Português (BR)
  - Inglês (opcional)
  - Usar `flutter_localizations`

---

## 📋 **Checklist para Publicação na Play Store:**

### Pré-requisitos da Conta:

- [ ] **Conta Google Play Developer**
  - Custo: $25 (única vez)
  - Criar em: https://play.google.com/console

### Informações do App:

- [ ] **Nome do app:** FitLife Coach
- [ ] **Descrição curta:** (80 caracteres)
- [ ] **Descrição completa:** (4000 caracteres)
- [ ] **Categoria:** Saúde e fitness
- [ ] **Classificação de conteúdo:** PEGI/ESRB
- [ ] **Screenshots:** 
  - 2-8 screenshots (mínimo 2)
  - Tamanho: 320-3840px (largura)
  - Formato: PNG ou JPEG (24-bit)
- [ ] **Ícone do app:** 512x512px (PNG, 32-bit)
- [ ] **Banner promocional:** 1024x500px (opcional)
- [ ] **Vídeo promocional:** YouTube (opcional)

### Conteúdo Obrigatório:

- [ ] **Política de Privacidade** (URL pública)
- [ ] **Contato do desenvolvedor** (email)
- [ ] **Ícone do app** (512x512px)
- [ ] **Screenshots** (mínimo 2)

### Configurações Técnicas:

- [ ] **APK/AAB assinado** com keystore de produção
- [ ] **Version code** incrementado
- [ ] **Version name** definido
- [ ] **Target SDK** atualizado (API 33+)
- [ ] **Min SDK** definido (API 21+)

### Testes:

- [ ] **Testar em dispositivo físico**
- [ ] **Testar todas as funcionalidades**
- [ ] **Testar pagamentos** (modo sandbox)
- [ ] **Verificar performance**

### Submissão:

- [ ] **Criar release no Google Play Console**
- [ ] **Upload do AAB** (Android App Bundle)
- [ ] **Preencher informações do app**
- [ ] **Adicionar screenshots**
- [ ] **Configurar preço** (gratuito ou pago)
- [ ] **Definir países de distribuição**
- [ ] **Enviar para revisão**

---

## 🚀 **Ordem de Execução Recomendada:**

### Fase 1: Preparação Técnica (1-2 dias)
1. Configurar Application ID e nome do app
2. Criar keystore e configurar assinatura
3. Atualizar URL do backend para produção
4. Fazer deploy do backend
5. Criar índices do Firestore

### Fase 2: Conformidade Legal (1 dia)
6. Criar Política de Privacidade
7. Criar Termos de Uso
8. Implementar consentimento LGPD
9. Adicionar links no app

### Fase 3: Assets e Design (1 dia)
10. Criar ícone do app
11. Criar splash screen
12. Tirar screenshots
13. Preparar descrições

### Fase 4: Testes e Otimização (2-3 dias)
14. Testes em dispositivos reais
15. Correção de bugs
16. Otimização de performance
17. Testes de pagamento

### Fase 5: Publicação (1 dia)
18. Criar conta Google Play Developer
19. Preparar informações do app
20. Upload do AAB
21. Submeter para revisão

---

## 📝 **Notas Importantes:**

### ⚠️ **Antes de Publicar:**

1. **NUNCA use localhost ou IP local** no código de produção
2. **NUNCA commite chaves secretas** no repositório
3. **SEMPRE teste em dispositivo físico** antes de publicar
4. **SEMPRE use HTTPS** para APIs em produção
5. **SEMPRE valide dados** do usuário

### 💡 **Dicas:**

- Use **Android App Bundle (AAB)** em vez de APK (menor tamanho)
- Teste em **beta fechado** antes de lançar publicamente
- Monitore **crash reports** após publicação
- Responda **comentários** dos usuários
- Atualize **regularmente** com correções

---

## ✅ **Checklist Final Antes de Publicar:**

- [ ] Application ID único configurado
- [ ] Nome do app correto
- [ ] Keystore criado e configurado
- [ ] Backend em produção funcionando
- [ ] URL do backend atualizada no app
- [ ] Índices do Firestore criados
- [ ] Política de Privacidade publicada
- [ ] Termos de Uso publicados
- [ ] Ícone do app criado
- [ ] Screenshots preparados
- [ ] App testado em dispositivo físico
- [ ] Todas as funcionalidades testadas
- [ ] AAB gerado e assinado
- [ ] Conta Google Play Developer criada
- [ ] Informações do app preenchidas
- [ ] App submetido para revisão

---

## 🎯 **Tempo Estimado Total:**

- **Preparação Técnica:** 1-2 dias
- **Conformidade Legal:** 1 dia
- **Assets e Design:** 1 dia
- **Testes e Otimização:** 2-3 dias
- **Publicação:** 1 dia

**Total: 6-8 dias de trabalho**

---

## 📞 **Suporte:**

Se precisar de ajuda com algum item específico, consulte:
- [Documentação Flutter](https://flutter.dev/docs)
- [Google Play Console Help](https://support.google.com/googleplay/android-developer)
- [Firebase Documentation](https://firebase.google.com/docs)

---

**🚀 Boa sorte com a publicação!**

