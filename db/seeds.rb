# Criar usuários
admin_user = User.find_or_create_by!(email: 'admin@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.first_name = 'Admin'
  user.last_name = 'User'
  user.username = 'admin'
  user.active = true
  user.admin = true
end

startup_user = User.find_or_create_by!(email: 'user@example.com') do |user|
  user.password = 'password'
  user.password_confirmation = 'password'
  user.first_name = 'TechStart'
  user.last_name = 'Founder'
  user.username = 'techstart'
  user.active = true
end

puts "✅ Usuários criados"

# Criar categorias para a startup
categories_data = [
  # Categorias de Receitas
  { name: "Contratos SaaS", description: "Receitas recorrentes de assinaturas de software", color: "#28a745" },
  { name: "Consultoria Técnica", description: "Serviços de consultoria e desenvolvimento customizado", color: "#17a2b8" },
  { name: "Licenciamento", description: "Vendas de licenças de software", color: "#20c997" },
  { name: "Investimentos", description: "Aportes de investidores e venture capital", color: "#6f42c1" },
  { name: "Grants e Subsídios", description: "Financiamentos governamentais e prêmios", color: "#e83e8c" },
  
  # Categorias de Despesas
  { name: "Salários", description: "Folha de pagamento dos funcionários", color: "#dc3545" },
  { name: "Ferramentas de Desenvolvimento", description: "IDEs, licenças de software, serviços de desenvolvimento", color: "#fd7e14" },
  { name: "Infraestrutura Cloud", description: "AWS, Azure, Google Cloud e hospedagem", color: "#ffc107" },
  { name: "Marketing Digital", description: "Publicidade online, SEO, redes sociais", color: "#6610f2" },
  { name: "Escritório", description: "Aluguel, utilitários, mobiliário", color: "#6c757d" },
  { name: "Equipamentos", description: "Computadores, monitores, hardware", color: "#495057" },
  { name: "Jurídico e Contábil", description: "Advogados, contadores, consultores", color: "#343a40" },
  { name: "Capacitação", description: "Cursos, certificações, eventos, conferências", color: "#007bff" }
]

categories = {}
categories_data.each do |cat_data|
  category = startup_user.categories.find_or_create_by!(name: cat_data[:name]) do |cat|
    cat.description = cat_data[:description]
    cat.color = cat_data[:color]
  end
  categories[cat_data[:name]] = category
end

puts "✅ Categorias criadas"

# Dados de receitas (últimos 12 meses)
incomes_data = [
  # Janeiro 2025
  { description: "Contrato SaaS - Empresa ABC Ltda", amount: 15000.00, date: "2025-01-15", category: "Contratos SaaS" },
  { description: "Consultoria - Desenvolvimento API REST", amount: 8500.00, date: "2025-01-20", category: "Consultoria Técnica" },
  { description: "Licença Enterprise - XYZ Corp", amount: 12000.00, date: "2025-01-25", category: "Licenciamento" },
  
  # Fevereiro 2025
  { description: "Assinatura mensal SaaS - TechCorp", amount: 18000.00, date: "2025-02-01", category: "Contratos SaaS" },
  { description: "Consultoria - Migração para microserviços", amount: 22000.00, date: "2025-02-10", category: "Consultoria Técnica" },
  { description: "Grant FAPESP - Projeto de IA", amount: 45000.00, date: "2025-02-14", category: "Grants e Subsídios" },
  
  # Março 2025
  { description: "Contrato anual SaaS - StartupXYZ", amount: 120000.00, date: "2025-03-05", category: "Contratos SaaS" },
  { description: "Licença Premium - Digital Solutions", amount: 25000.00, date: "2025-03-12", category: "Licenciamento" },
  { description: "Consultoria - Arquitetura de dados", amount: 15000.00, date: "2025-03-18", category: "Consultoria Técnica" },
  
  # Abril 2025
  { description: "Aporte Série A - Venture Capital Fund", amount: 500000.00, date: "2025-04-02", category: "Investimentos" },
  { description: "Contrato SaaS - FinTech Brasil", amount: 32000.00, date: "2025-04-15", category: "Contratos SaaS" },
  { description: "Prêmio Startup do Ano - SEBRAE", amount: 50000.00, date: "2025-04-20", category: "Grants e Subsídios" },
  
  # Maio 2025
  { description: "Renovação contrato SaaS - MegaCorp", amount: 85000.00, date: "2025-05-01", category: "Contratos SaaS" },
  { description: "Consultoria - Implementação DevOps", amount: 28000.00, date: "2025-05-10", category: "Consultoria Técnica" },
  { description: "Licença Enterprise Plus - GlobalTech", amount: 40000.00, date: "2025-05-22", category: "Licenciamento" },
  
  # Junho 2025
  { description: "Contrato SaaS - E-commerce Giant", amount: 65000.00, date: "2025-06-03", category: "Contratos SaaS" },
  { description: "Consultoria - Otimização de performance", amount: 18500.00, date: "2025-06-15", category: "Consultoria Técnica" },
  { description: "Grant CNPq - Pesquisa em Machine Learning", amount: 75000.00, date: "2025-06-25", category: "Grants e Subsídios" },
  
  # Julho 2025
  { description: "Assinatura anual SaaS - RetailChain", amount: 98000.00, date: "2025-07-01", category: "Contratos SaaS" },
  { description: "Licença Multi-tenant - CloudFirst", amount: 55000.00, date: "2025-07-12", category: "Licenciamento" },
  { description: "Consultoria - Migração para Kubernetes", amount: 42000.00, date: "2025-07-20", category: "Consultoria Técnica" },
  
  # Agosto 2025
  { description: "Contrato SaaS - Healthcare Platform", amount: 78000.00, date: "2025-08-05", category: "Contratos SaaS" },
  { description: "Renovação Enterprise - DataCorp", amount: 105000.00, date: "2025-08-15", category: "Licenciamento" },
  { description: "Aporte Bridge - Angel Investors", amount: 200000.00, date: "2025-08-20", category: "Investimentos" }
]

# Dados de despesas (últimos 12 meses)
expenses_data = [
  # Janeiro 2025
  { description: "Salários desenvolvedores (3x)", amount: 24000.00, date: "2025-01-05", category: "Salários" },
  { description: "AWS - Hospedagem e banco de dados", amount: 3200.00, date: "2025-01-10", category: "Infraestrutura Cloud" },
  { description: "JetBrains - Licenças IDE", amount: 1200.00, date: "2025-01-12", category: "Ferramentas de Desenvolvimento" },
  { description: "Google Ads - Campanha de marketing", amount: 5500.00, date: "2025-01-15", category: "Marketing Digital" },
  { description: "Aluguel escritório", amount: 8000.00, date: "2025-01-20", category: "Escritório" },
  
  # Fevereiro 2025
  { description: "Salários equipe (5x)", amount: 40000.00, date: "2025-02-05", category: "Salários" },
  { description: "MacBook Pro M3 - Desenvolvedor Senior", amount: 18000.00, date: "2025-02-08", category: "Equipamentos" },
  { description: "Azure DevOps - Pipeline CI/CD", amount: 800.00, date: "2025-02-10", category: "Infraestrutura Cloud" },
  { description: "Contador - Serviços mensais", amount: 2500.00, date: "2025-02-12", category: "Jurídico e Contábil" },
  { description: "GitHub Enterprise", amount: 450.00, date: "2025-02-15", category: "Ferramentas de Desenvolvimento" },
  
  # Março 2025
  { description: "Salários + benefícios (6x)", amount: 52000.00, date: "2025-03-05", category: "Salários" },
  { description: "AWS - Aumento de instâncias", amount: 4800.00, date: "2025-03-08", category: "Infraestrutura Cloud" },
  { description: "Figma Pro - Design team", amount: 360.00, date: "2025-03-10", category: "Ferramentas de Desenvolvimento" },
  { description: "Curso AWS Solutions Architect", amount: 3200.00, date: "2025-03-15", category: "Capacitação" },
  { description: "LinkedIn Ads - Recrutamento", amount: 2800.00, date: "2025-03-18", category: "Marketing Digital" },
  
  # Abril 2025
  { description: "Salários equipe expandida (8x)", amount: 68000.00, date: "2025-04-05", category: "Salários" },
  { description: "Dell Monitors 4K (6x)", amount: 12000.00, date: "2025-04-08", category: "Equipamentos" },
  { description: "Slack Pro - Comunicação interna", amount: 640.00, date: "2025-04-10", category: "Ferramentas de Desenvolvimento" },
  { description: "Advogado - Contrato investimento", amount: 8500.00, date: "2025-04-12", category: "Jurídico e Contábil" },
  { description: "Google Cloud - ML/AI services", amount: 2200.00, date: "2025-04-15", category: "Infraestrutura Cloud" },
  
  # Maio 2025
  { description: "Salários + stock options (10x)", amount: 85000.00, date: "2025-05-05", category: "Salários" },
  { description: "Notion Pro - Documentação", amount: 480.00, date: "2025-05-08", category: "Ferramentas de Desenvolvimento" },
  { description: "Confluência + Jira", amount: 1200.00, date: "2025-05-10", category: "Ferramentas de Desenvolvimento" },
  { description: "Facebook Ads - Aquisição usuários", amount: 8500.00, date: "2025-05-12", category: "Marketing Digital" },
  { description: "Seguro empresarial", amount: 3200.00, date: "2025-05-15", category: "Jurídico e Contábil" },
  
  # Junho 2025
  { description: "Salários equipe completa (12x)", amount: 96000.00, date: "2025-06-05", category: "Salários" },
  { description: "DataDog - Monitoramento", amount: 1800.00, date: "2025-06-08", category: "Infraestrutura Cloud" },
  { description: "Docker Pro licenses", amount: 720.00, date: "2025-06-10", category: "Ferramentas de Desenvolvimento" },
  { description: "Conferência TechCrunch Disrupt", amount: 15000.00, date: "2025-06-12", category: "Capacitação" },
  { description: "Mesa escritório ergonômica (5x)", amount: 8500.00, date: "2025-06-15", category: "Escritório" },
  
  # Julho 2025
  { description: "Salários + 13º proporcional", amount: 105000.00, date: "2025-07-05", category: "Salários" },
  { description: "Terraform Cloud", amount: 400.00, date: "2025-07-08", category: "Ferramentas de Desenvolvimento" },
  { description: "AWS - Auto scaling implementado", amount: 6200.00, date: "2025-07-10", category: "Infraestrutura Cloud" },
  { description: "Certificação Kubernetes (3x)", amount: 2400.00, date: "2025-07-12", category: "Capacitação" },
  { description: "HubSpot - CRM e Marketing", amount: 3600.00, date: "2025-07-15", category: "Marketing Digital" },
  
  # Agosto 2025
  { description: "Salários + bônus performance", amount: 112000.00, date: "2025-08-05", category: "Salários" },
  { description: "MacBook Air M3 (4x) - Novos devs", amount: 32000.00, date: "2025-08-08", category: "Equipamentos" },
  { description: "SonarQube - Code quality", amount: 1500.00, date: "2025-08-10", category: "Ferramentas de Desenvolvimento" },
  { description: "Auditoria de segurança", amount: 12000.00, date: "2025-08-12", category: "Jurídico e Contábil" },
  { description: "Zendesk - Customer support", amount: 1200.00, date: "2025-08-15", category: "Ferramentas de Desenvolvimento" }
]

puts "🚀 Criando receitas da startup..."

incomes_data.each do |income_data|
  startup_user.incomes.find_or_create_by!(
    description: income_data[:description],
    date: income_data[:date]
  ) do |income|
    income.amount = income_data[:amount]
    income.category = categories[income_data[:category]]
  end
end

puts "💸 Criando despesas da startup..."

expenses_data.each do |expense_data|
  startup_user.expenses.find_or_create_by!(
    description: expense_data[:description],
    date: expense_data[:date]
  ) do |expense|
    expense.amount = expense_data[:amount]
    expense.category = categories[expense_data[:category]]
  end
end

puts "📊 Resumo dos dados criados:"
puts "- #{startup_user.categories.count} categorias"
puts "- #{startup_user.incomes.count} receitas"
puts "- #{startup_user.expenses.count} despesas"
puts "- Total receitas: #{startup_user.incomes.sum(:amount).to_f.round(2)}"
puts "- Total despesas: #{startup_user.expenses.sum(:amount).to_f.round(2)}"
puts "- Saldo: #{(startup_user.incomes.sum(:amount) - startup_user.expenses.sum(:amount)).to_f.round(2)}"
puts ""
puts "✅ Seeds executados com sucesso!"
puts "🔑 Login: user@example.com / password"


