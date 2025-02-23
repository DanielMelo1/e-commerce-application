# E-commerce App

Este é um aplicativo de e-commerce que permite aos usuários visualizar produtos, adicionar ao carrinho e realizar pedidos. Ele é composto por duas partes principais: o **Backend** (API) e o **Frontend** (Interface de usuário).

## Backend

O **Backend** foi construído utilizando Node.js, Express e PostgreSQL. Ele fornece as seguintes funcionalidades principais:

- **Rotas de Produtos**: Exibe todos os produtos disponíveis no banco de dados.
- **Rotas de Pedidos**: Permite criar pedidos, incluindo informações sobre o cliente e os itens do carrinho.

### Tecnologias Utilizadas

- Node.js
- Express
- PostgreSQL
- Nodemon (para desenvolvimento)
- CORS (para permitir conexões de diferentes origens)
- dotenv (para gerenciar variáveis de ambiente)

### Como Rodar o Backend

1. Navegue até o diretório `backend`:

    ```bash
    cd backend
    ```

2. Instale as dependências:

    ```bash
    npm install
    ```

3. Crie um arquivo `.env` com suas variáveis de ambiente, como a URL do banco de dados PostgreSQL.

4. Para rodar o servidor em modo de desenvolvimento com o Nodemon:

    ```bash
    npm run dev
    ```

    Ou para rodar normalmente:

    ```bash
    npm start
    ```

O backend estará rodando na porta **3001** por padrão.

## Frontend

O **Frontend** foi desenvolvido com React, usando Vite para a construção e otimização. Ele exibe as informações dos produtos, permite que o usuário adicione itens ao carrinho e finalize a compra.

### Tecnologias Utilizadas

- React
- Vite (para bundling e otimização)
- Tailwind CSS (para estilos)
- React Router (para navegação)
- Lucide Icons (para ícones)

### Como Rodar o Frontend

1. Navegue até o diretório `frontend`:

    ```bash
    cd frontend
    ```

2. Instale as dependências:

    ```bash
    npm install
    ```

3. Para iniciar o frontend em modo de desenvolvimento:

    ```bash
    npm run dev
    ```

O frontend estará acessível em **http://localhost:5173/**.

## Estrutura do Projeto

ecommerce-app/ ├── backend/ # Backend da aplicação (Node.js, Express) │ ├── db.js # Configuração do banco de dados │ ├── index.js # Roteamento e lógica do servidor │ ├── .env # Variáveis de ambiente │ ├── package.json # Dependências e scripts do Backend ├── frontend/ # Frontend da aplicação (React) │ ├── src/ │ │ ├── assets/ # Imagens e arquivos estáticos │ │ ├── components/ # Componentes reutilizáveis │ │ ├── contexts/ # Contexto global (ex. Carrinho) │ │ ├── pages/ # Páginas da aplicação (Home, Produtos, Carrinho) │ │ ├── services/ # Funções de API │ ├── package.json # Dependências e scripts do Frontend └── README.md # Este arquivo

markdown
Copy
Edit

## Contribuindo

1. Faça um fork deste repositório.
2. Crie uma branch com sua feature ou correção de bug (`git checkout -b feature/nova-feature`).
3. Commit suas mudanças (`git commit -m 'Adicionando nova feature'`).
4. Envie para o repositório remoto (`git push origin feature/nova-feature`).
5. Abra um Pull Request.

## Licença

Este projeto está licenciado sob a [MIT License](LICENSE).
