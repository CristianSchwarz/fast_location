# FastLocation 📍

Aplicativo mobile desenvolvido em Flutter para consulta de CEP e endereços, com o objetivo de facilitar a localização e a confirmação de informações de entrega.

O projeto foi desenvolvido como atividade acadêmica do curso de Desenvolvimento de Sistemas Móveis do SENAI, com base em uma necessidade apresentada pela empresa fictícia FastDelivery.

## 🎯 Objetivo

O FastLocation tem como objetivo agilizar a consulta e a confirmação de endereços, permitindo que entregadores encontrem informações de localização sem precisar entrar em contato com a matriz da empresa.

## 🚀 Funcionalidades

- **Consulta por CEP:** pesquisa de endereços utilizando o Código de Endereçamento Postal.
- **Busca por endereço:** localização de CEPs a partir de informações como estado, cidade e logradouro.
- **Histórico de consultas:** armazenamento local dos endereços pesquisados.
- **Último endereço consultado:** exibição das informações da pesquisa mais recente.
- **Traçar rota:** integração com aplicativos de mapas para visualizar a rota até o endereço selecionado.
- **Tela inicial animada:** apresentação do aplicativo com redirecionamento automático para a página principal.

## 🛠️ Tecnologias utilizadas

| Tecnologia | Finalidade |
|---|---|
| Flutter | Desenvolvimento do aplicativo mobile |
| Dart | Linguagem de programação |
| Dio | Comunicação HTTP com APIs externas |
| ViaCEP | Consulta de CEP e endereços |
| MobX | Gerenciamento de estado |
| Hive | Armazenamento local de dados |
| Map Launcher | Integração com aplicativos de mapas |
| Geocoding | Conversão de endereços em coordenadas |

## 📂 Estrutura do projeto

```text
lib/
├── main.dart
└── src/
    ├── http/
    ├── modules/
    │   ├── initial/
    │   │   └── page/
    │   ├── home/
    │   │   ├── controller/
    │   │   ├── model/
    │   │   ├── page/
    │   │   ├── repositories/
    │   │   └── service/
    │   └── history/
    │       ├── controller/
    │       └── page/
    └── shared/
        ├── colors/
        ├── components/
        ├── metrics/
        └── storage/
```

## 🌐 API utilizada

O aplicativo utiliza a API pública ViaCEP para consultar informações de endereços.

Documentação: https://viacep.com.br/

Exemplo de consulta:

```text
https://viacep.com.br/ws/89251000/json/
```

## ⚙️ Como executar o projeto

### Pré-requisitos

- Flutter SDK instalado.
- Dart SDK.
- Android Studio ou VS Code.
- Emulador Android ou dispositivo físico.
- Conexão com a internet.

### 1. Clonar o repositório

```bash
git clone URL_DO_REPOSITORIO
```

### 2. Acessar a pasta do projeto

```bash
cd fast_location
```

### 3. Instalar as dependências

```bash
flutter pub get
```

### 4. Executar o aplicativo

```bash
flutter run
```

## 🧪 Validação

Durante os testes de funcionamento, foram verificadas as seguintes funcionalidades:

- Consulta de endereço por CEP.
- Busca de CEP por endereço.
- Armazenamento e recuperação do histórico de consultas.
- Abertura de aplicativos de mapas e cálculo de rota até o endereço selecionado.

## 👨‍💻 Desenvolvimento

Projeto acadêmico desenvolvido individualmente como atividade do curso de Desenvolvimento de Sistemas Móveis – SENAI.

**Projeto:** FastLocation  
**Contexto:** FastDelivery – Sistema de consulta de CEP e endereços.

---

Desenvolvido com Flutter e Dart.
