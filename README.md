# Consys Gertec Plugin

Interface Flutter para utilização do scanner de código de barras e impressora térmica do dispositivo SK210 da Gertec.

## Características

- ✅ Leitura de códigos de barras
- ✅ Impressão de texto com formatação customizável
- ✅ Impressão de QR Codes
- ✅ Controle de alimentação de papel
- ✅ Corte de papel automático
- ✅ Suporte completo para Android
- ✅ API simples e intuitiva

## Plataformas Suportadas

| Android | iOS | Web | MacOS | Windows | Linux |
|---------|-----|-----|-------|---------|-------|
| ✅      | ❌  | ❌  | ❌    | ❌      | ❌    |

## Requisitos

- Flutter SDK: >=3.3.0
- Dart SDK: ^3.10.7
- Dispositivo Gertec SK210
- Android SDK mínimo: 21

## Instalação

Adicione o pacote ao seu `pubspec.yaml`:

```yaml
dependencies:
  consys_gertec_plugin: ^0.0.1
```

Execute o comando:

```bash
flutter pub get
```

## Configuração

### Android

Adicione as seguintes permissões no arquivo `android/app/src/main/AndroidManifest.xml`:

```xml
<uses-permission android:name="android.permission.CAMERA" />
<uses-feature android:name="android.hardware.camera" />
<uses-feature android:name="android.hardware.camera.autofocus" />
```

## Uso

### Importação

```dart
import 'package:consys_gertec_plugin/consys_gertec_plugin.dart';
```

### Inicialização

```dart
final _consysGertecPlugin = ConsysGertecPlugin();
```

### Scanner de Código de Barras

Realize a leitura de códigos de barras de forma simples:

```dart
try {
  final resultado = await _consysGertecPlugin.scanBarcode();
  if (resultado != null) {
    print('Código escaneado: $resultado');
  }
} on PlatformException catch (e) {
  print('Erro ao escanear: ${e.message}');
}
```

### Impressão de Texto

Imprima texto com diversas opções de formatação:

```dart
try {
  final sucesso = await _consysGertecPlugin.printText(
    text: "Olá, Mundo!",
    alignment: "CENTER",  // LEFT, CENTER, RIGHT
    fontSize: 24,         // Tamanho da fonte
    isBold: true,         // Negrito
  );
  
  if (sucesso) {
    print('Texto impresso com sucesso!');
  }
} on PlatformException catch (e) {
  print('Erro na impressão: ${e.message}');
}
```

#### Parâmetros da Impressão de Texto

| Parâmetro | Tipo | Obrigatório | Padrão | Descrição |
|-----------|------|-------------|--------|-----------|
| `text` | `String` | ✅ | - | Texto a ser impresso |
| `alignment` | `String` | ❌ | `"LEFT"` | Alinhamento: `"LEFT"`, `"CENTER"`, `"RIGHT"` |
| `fontSize` | `int` | ❌ | `24` | Tamanho da fonte em pixels |
| `isBold` | `bool` | ❌ | `false` | Aplicar negrito ao texto |

### Impressão de QR Code

Imprima QR Codes com tamanhos customizáveis:

```dart
try {
  final sucesso = await _consysGertecPlugin.printQRCode(
    qrCodeData: 'https://exemplo.com.br',
    size: 'FULL',  // FULL, HALF, QUARTER
  );
  
  if (sucesso) {
    print('QR Code impresso com sucesso!');
  }
} on PlatformException catch (e) {
  print('Erro ao imprimir QR Code: ${e.message}');
}
```

#### Parâmetros da Impressão de QR Code

| Parâmetro | Tipo | Obrigatório | Padrão | Descrição |
|-----------|------|-------------|--------|-----------|
| `qrCodeData` | `String` | ✅ | - | Dados a serem codificados no QR Code |
| `size` | `String` | ❌ | `"FULL"` | Tamanho: `"FULL"`, `"HALF"`, `"QUARTER"` |

### Alimentação de Papel

Avance o papel sem imprimir:

```dart
try {
  final sucesso = await _consysGertecPlugin.feedPaper(lines: 10);
  
  if (sucesso) {
    print('Papel alimentado com sucesso!');
  }
} on PlatformException catch (e) {
  print('Erro ao alimentar papel: ${e.message}');
}
```

#### Parâmetros da Alimentação de Papel

| Parâmetro | Tipo | Obrigatório | Padrão | Descrição |
|-----------|------|-------------|--------|-----------|
| `lines` | `int` | ❌ | `10` | Número de linhas a avançar |

### Corte de Papel

Execute o corte automático do papel:

```dart
try {
  final sucesso = await _consysGertecPlugin.cutPaper();
  
  if (sucesso) {
    print('Papel cortado com sucesso!');
  }
} on PlatformException catch (e) {
  print('Erro ao cortar papel: ${e.message}');
}
```

## Exemplo Completo

### Impressão de Cupom Fiscal

```dart
Future<void> imprimirCupomFiscal() async {
  try {
    // Cabeçalho
    await _consysGertecPlugin.printText(
      text: "CUPOM FISCAL",
      alignment: "CENTER",
      fontSize: 28,
      isBold: true,
    );
    
    // Separador
    await _consysGertecPlugin.printText(
      text: "--------------------------------",
      alignment: "CENTER",
      fontSize: 20,
    );
    
    // Itens
    await _consysGertecPlugin.printText(
      text: "Produto 1: R\$ 10,00",
      alignment: "LEFT",
      fontSize: 20,
    );
    
    await _consysGertecPlugin.printText(
      text: "Produto 2: R\$ 15,00",
      alignment: "LEFT",
      fontSize: 20,
    );
    
    // Total
    await _consysGertecPlugin.printText(
      text: "TOTAL: R\$ 25,00",
      alignment: "RIGHT",
      fontSize: 24,
      isBold: true,
    );
    
    // QR Code para consulta
    await _consysGertecPlugin.printQRCode(
      qrCodeData: 'https://consultadfe.fazenda.gov.br/...',
      size: 'HALF',
    );
    
    // Finalização
    await _consysGertecPlugin.feedPaper(lines: 10);
    await _consysGertecPlugin.cutPaper();
    
    print('Cupom impresso com sucesso!');
  } on PlatformException catch (e) {
    print('Erro ao imprimir cupom: ${e.message}');
  }
}
```

### Scanner com Tratamento Completo

```dart
Future<void> escanearProduto() async {
  try {
    final codigoBarras = await _consysGertecPlugin.scanBarcode();
    
    if (codigoBarras == null) {
      print('Leitura cancelada pelo usuário');
      return;
    }
    
    if (codigoBarras.isEmpty) {
      print('Código de barras inválido');
      return;
    }
    
    // Processar o código escaneado
    print('Código de barras lido: $codigoBarras');
    await buscarProduto(codigoBarras);
    
  } on PlatformException catch (e) {
    print('Erro ao escanear: ${e.message}');
  }
}
```

## Tratamento de Erros

Todas as operações podem lançar `PlatformException`. É recomendado sempre envolver as chamadas em blocos `try-catch`:

```dart
try {
  await _consysGertecPlugin.printText(text: "Teste");
} on PlatformException catch (e) {
  // Tratar erro específico da plataforma
  print('Código do erro: ${e.code}');
  print('Mensagem: ${e.message}');
  print('Detalhes: ${e.details}');
}
```

## Boas Práticas

### 1. Verificar Estado do Widget

Sempre verifique se o widget ainda está montado antes de atualizar o estado:

```dart
Future<void> _imprimir() async {
  final sucesso = await _consysGertecPlugin.printText(text: "Teste");
  
  if (!mounted) return;
  
  setState(() {
    _mensagem = sucesso ? 'Impresso!' : 'Falha na impressão';
  });
}
```

### 2. Feedback Visual

Forneça feedback visual durante operações longas:

```dart
setState(() => _carregando = true);

try {
  await _consysGertecPlugin.scanBarcode();
} finally {
  if (mounted) {
    setState(() => _carregando = false);
  }
}
```

### 3. Sequência de Impressão

Para impressões complexas, agrupe as operações:

```dart
Future<void> imprimirCompleto() async {
  try {
    // Todas as operações de impressão
    await _imprimirCabecalho();
    await _imprimirItens();
    await _imprimirRodape();
    
    // Finalização apenas no final
    await _consysGertecPlugin.feedPaper(lines: 10);
    await _consysGertecPlugin.cutPaper();
  } catch (e) {
    print('Erro na impressão: $e');
  }
}
```

## Limitações Conhecidas

- ⚠️ Suporte apenas para dispositivos Gertec SK210
- ⚠️ Disponível apenas para Android
- ⚠️ Requer permissões de câmera para scanner
- ⚠️ Impressora deve estar devidamente configurada no dispositivo

## Troubleshooting

### Scanner não abre
- Verifique se as permissões de câmera foram concedidas
- Confirme que o dispositivo é um Gertec SK210 genuíno

### Impressão não funciona
- Verifique se há papel na impressora
- Confirme que a impressora está inicializada
- Teste com textos menores primeiro

### Erros de PlatformException
- Verifique os logs do Android (`adb logcat`)
- Confirme que o plugin foi instalado corretamente
- Certifique-se de estar usando um dispositivo real (não emulador)

## Changelog

### [0.0.1] - 2024-01-15
- Lançamento inicial
- Suporte para scanner de código de barras
- Suporte para impressão de texto formatado
- Suporte para impressão de QR Codes
- Controle de alimentação e corte de papel

## Licença

Este projeto está licenciado sob a licença MIT - veja o arquivo LICENSE para detalhes.

## Suporte

Para reportar bugs ou solicitar funcionalidades, por favor abra uma issue no GitHub.

## Autores

- Desenvolvido por Consys

---

**Nota:** Este plugin foi desenvolvido especificamente para o dispositivo Gertec SK210 e pode não funcionar em outros dispositivos.