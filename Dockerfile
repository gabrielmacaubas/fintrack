FROM ruby:3.3.0

LABEL Version="1.0"
LABEL Name="App"
LABEL Maintainer="RAD"
LABEL Description="Imagem Ruby on Rails para desenvolvimento"

# Configuração do ambiente
ENV RAILS_ENV=development

# Instalação de dependências
RUN apt-get update -qq && apt-get install -y build-essential nodejs yarn && apt-get clean

# Criação do diretório da aplicação
WORKDIR /myapp

# Cópia do arquivo Gemfile
COPY Gemfile /myapp/Gemfile
COPY Gemfile.lock /myapp/Gemfile.lock

# Instalação de gems
RUN bundle install

# Cópia do código da aplicação
COPY . /myapp

EXPOSE 3000

# Comando para executar a aplicação
CMD ["rails", "server", "-b", "0.0.0.0"]