# Configuração Web - Hangar do Hambúrguer

## ✅ Configurações Realizadas

### 1. Habilitação do Suporte Web
- Executado `flutter config --enable-web`
- Gerados arquivos web com `flutter create . --platforms web`

### 2. Ajustes de Responsividade
- **MenuScreen**: Implementado `LayoutBuilder` para grid responsivo
  - 2 colunas em telas pequenas (< 800px)
  - 3 colunas em telas médias (800-1200px)
  - 4 colunas em telas grandes (> 1200px)

### 3. Melhorias para Web
- **ProductCard**: Adicionado efeitos hover com `MouseRegion`
- **main.dart**: Condicionado `SystemChrome` apenas para mobile usando `kIsWeb`

### 4. Configuração PWA
- **index.html**: Personalizado com loading screen e meta tags
- **manifest.json**: Configurado para PWA com tema e ícones

### 5. Dependências Verificadas
Todas as dependências são compatíveis com web:
- ✅ `provider`: Totalmente compatível
- ✅ `shared_preferences`: Tem implementação web nativa

## 🚀 Como Executar

### Desenvolvimento
```bash
flutter run -d web-server --web-port 3000
```

### Build de Produção
```bash
flutter build web
```

### Servir Build Local
```bash
cd build/web
python -m http.server 8000
```

## 📱 Funcionalidades Web

### Responsividade
- Layout adaptativo para diferentes tamanhos de tela
- Grid de produtos se ajusta automaticamente
- Interface otimizada para desktop e mobile

### Interatividade
- Efeitos hover nos cards de produtos
- Navegação suave entre telas
- Carrinho funcional

### PWA (Progressive Web App)
- Instalável no desktop/mobile
- Ícones personalizados
- Tema consistente (#87CEEB)

## 🔧 Próximos Passos Opcionais

### SEO (se necessário)
- Considerar Flutter Web com renderização server-side
- Adicionar meta tags específicas por página

### Performance
- Implementar lazy loading para imagens
- Otimizar assets para web

### Deploy
- Configurar para Firebase Hosting, Netlify ou Vercel
- Configurar domínio personalizado

## 📋 Comandos Úteis

```bash
# Verificar dispositivos disponíveis
flutter devices

# Executar no Chrome (melhor para debug)
flutter run -d chrome

# Executar no Edge
flutter run -d edge

# Build com base href personalizada
flutter build web --base-href /meu-app/

# Analisar tamanho do bundle
flutter build web --analyze-size
```

## ✨ Estrutura Mantida

Toda a estrutura original do projeto foi preservada:
- Modelos de dados
- Serviços (Cart, Auth, Order)
- Telas e widgets
- Assets e imagens

O projeto agora funciona tanto em mobile quanto na web com a mesma base de código!