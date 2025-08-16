# 📊 FinTrack

FinTrack é uma plataforma digital desenvolvida em **Ruby on Rails** para ajudar usuários a **organizar suas finanças pessoais**, registrando receitas e despesas, categorizando transações e acompanhando relatórios e dashboards.

---

## 🚀 Objetivo
Capacitar o usuário a gerenciar suas finanças de forma eficiente, oferecendo **clareza** sobre sua situação financeira e auxiliando na tomada de decisões para o alcance de objetivos.

---

## ✨ Funcionalidades
- 👤 **Gestão de Usuários**  
  - Cadastro e autenticação  
  - Atualização e exclusão de perfil  

- 💰 **Gestão Financeira**  
  - Registro de receitas e despesas  
  - Edição e exclusão de registros  
  - Upload de comprovantes  
  - Categorização de receitas e despesas  

- 📊 **Relatórios e Análises**  
  - Filtros personalizados  
  - Dashboards interativos  
  - Estatísticas financeiras  

---

## 🛠️ Tecnologias
- **Backend:** Ruby on Rails 7+  
- **Banco de Dados:** PostgreSQL  
- **Frontend:** Hotwire (Turbo + Stimulus)  
- **Estilização:** Bootstrap + Darkly theme  
- **Autenticação:** Devise  
- **Testes:** RSpec  

---

## ▶️ Como rodar o projeto

### Pré-requisitos
- Ruby 3.2+  
- Rails 7+  
- PostgreSQL  

### Passos
```bash
# Clone o repositório
git clone https://github.com/seu-usuario/fintrack.git
cd fintrack

# Instale as dependências
bundle install

# Configure o banco de dados
rails db:create db:migrate db:seed

# Inicie o servidor
bin/dev