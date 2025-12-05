# 📦 DJSYNC - Integrador Mobile para DJMonitor

O **DJSYNC** é uma solução mobile criada para estender as
funcionalidades do DJMonitor.\
Com ele, é possível consultar e atualizar informações críticas de
produtos (**preço, estoque, status...**) diretamente de dispositivos
móveis, em **tempo real**.

------------------------------------------------------------------------

## 📐 Arquitetura da Solução

A solução foi projetada para modernizar a integração com o DJMonitor
sem modificar seu núcleo.

### 🔄 Fluxo de Dados

-   **Mobile**: O aplicativo solicita a lista de produtos via API REST.
-   **Middleware (API)**: O servidor Lazarus recebe a requisição, conecta ao Firebird via ZeosLib e retorna os dados em JSON.
-   **Edição**: O usuário altera preço, estoque, status,  entre outros diretamente no app.
-   **Sincronização**: O app envia um `PUT` contendo o JSON atualizado.\
-   **Persistência**: O servidor processa o JSON e realiza o `UPDATE` no
banco, garantindo integridade dos dados.

------------------------------------------------------------------------

## 🛠️ Tecnologias Utilizadas

### 📱 Mobile (Frontend)

-   **Flutter** -- Focado em performance e arquitetura desacoplada.
-   **Gerência de Estado:** ASP (Atomic State Pattern) -- Reatividade
    atômica e previsível.
-   **Injeção de Dependência & Rotas:** Flutter Modular.
-   **Comunicação HTTP:** Dio -- Cliente HTTP robusto.
-   **UI/UX:** Interface limpa, Material Design, otimizada para uso em
    campo.

------------------------------------------------------------------------

### 🖥️ Backend (Middleware API)

-   **Lazarus (Free Pascal)** -- Servidor leve e portátil.
-   **Framework API:** Horse -- Micro-framework para APIs.
-   **Middleware JSON:** Jhonson -- Processamento eficiente de JSON.
-   **Conexão com DB:** ZeosLib -- Compatível com Firebird 5.0.

------------------------------------------------------------------------

### 🗄️ Banco de Dados

-   **SGBD:** Firebird SQL 5.0.

------------------------------------------------------------------------

## ✨ Funcionalidades Principais

-   **Configuração Dinâmica:** Ajuste de IP/porta do servidor
    diretamente no app.
-   **Consulta em Tempo Real:** Listagem de produtos com indicador
    visual de status (Ativo/Inativo).
-   **Edição Rápida (Modal):**
    -   Código de Barras    
    -   Descrição
    -   Unidade
    -   Preço de venda
    -   Estoque
    -   Flag Ativo/Inativo
-   **Tratamento de Erros:**
    -   Validações de conexão
    -   Feedback visual de carregamento
    -   Mensagens de sucesso ou falha durante a sincronização

------------------------------------------------------------------------