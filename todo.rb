require 'date'
class Todo
    def initialize 
        @tasks = []
        @categories = Hash.new(0)
        load_tasks
        start_cli
    end

    def add_task(task, due_date = nil, priority = "baixa", categories = []) # adiciona uma tarefa
        task_info = { description: task, completed: false, due_date: due_date, priority: priority, categories: categories }
        @tasks << task_info
        update_categories(categories)
        puts "Tarefa Adicionada: #{task}"
    end

    def list_tasks # lista as tarefas existentes
        puts "Lista de Tarefas"
        @tasks.each_with_index do |task, index|
            status = task[:completed] ? "[X]" : "[ ]"
            due_date_info = task[:due_date] ? "(Conclusão até #{task[:due_date]})" : ""
            priority_info = task[:priority] ? "Prioridade: #{task[:priority]}" : ""
            category_info = task[:categories].empty? ? "" : " (Categorias: #{task[:categories].join(',')})"
            puts "#{index + 1}. #{status} #{task[:description]}#{due_date_info}#{priority_info}#{category_info}"
        end
    end

    def complete_task(task_index) # marca uma tarefa como completa
        if task_index >= 0 && task_index < @tasks.length
            @tasks[task_index][:completed] = true
            puts "Tarefa #{task_index + 1} marcada como concluida."
        else 
            puts "Indice invalido. Tarefa não encontrada."
        end
    end

    def remove_task(task_index) # remove tarefas
        if task_index >= 0 && task_index < @tasks.length
            removed_task = @tasks.delete_at(task_index)
            update_categories(removed_task[:categories], remove: true)
            puts "Tarefa Removida: #{removed_task[:description]}"
        else
            puts "Indice invalido. Tarefa não encontrada."
        end
    end

    def clear_all_tasks
        @tasks = []
        @categories = Hash.new(0)
        puts "todas as tarefas foram removidas."
    end

    def show_statistics
        total_tasks = @tasks.length
        completed_tasks = @tasks.count { |task| task[:completed] }
        incomplete_tasks = total_tasks - complete_tasks

        puts "\nEstatisticas:"
        puts "Total de Tarefas: #{total_tasks}"
        puts "Tarefas Concluídas: #{completed_tasks}"
        puts "Tarefas Incompletas: #{incomplete_tasks}"

        show_priority_distribution
        show_category_distribution
    end

    private

    def load_tasks #implementação de leitura das tarefas 
    end

    def update_categories(categories, remove: false) #atualiza a contagem de categorias
        categories.each do |category|
            if remove 
                @categories[category] -= 1
                @categories.delete(category) if @categories[category].zero?
            else
                @categories[category] ||= 0
                @categories[category] += 0
            end
        end
    end

    def start_cli #inicia a interface interativa
        loop do 
            puts "\nEscolha uma opção:"
            puts "1. Adicionar Tarefa"
            puts "2. Listar Tarefas"
            puts "3. Marcar Tarefa como Concluida"
            puts "4. Remover Tarefa"
            puts "5. Editar Tarefa"
            puts "6. Visualizar Estatisticas"
            puts "7. Limpar todas as Tarefas"
            puts "8. Apagar Tarefa"
            puts "9. Sair"

            choice = gets.chomp.to_i

            case choice
            when 1
                add_task_from_cli
            when 2
                list_tasks
            when 3
                complete_task_from_cli 
            when 4
                remove_task_from_cli
            when 5
                edit_task_from_cli
            when 6
                show_statistics
            when 7
                clear_all_tasks
            when 8
                delete_single_task_from_cli
            when 9
                break
            else
                puts "Opção Invalida. Tente novamente."
            end
        end
    end

    def add_task_from_cli #adiciona uma tarefa atraves da interface
        puts "\nAdicionar Tarefa:"
        print "descrição da Tarefa: "
        description = gets.chomp

        print "Data de Conclusão (opcional, formato YYYY-MM-DD): "
        due_date_str = gets.chomp
        due_date = Date.parse(due_date_str) rescue nil

        print "Prioridade (baixa/média/alta, padrão: baixa): "
        priority = gets.chomp.downcase
        priority = "baixa" unless %w[baixa média alta].include?(priority)

        print "Categorias (separadas por vírgulas): "
        categories_str = gets.chomp
        categories = categories_str.split(",").map(&:strip)

        add_task(description, due_date, priority, categories)
    end

    def complete_task_from_cli #marca uma tarefa como concluida
        puts "\nMarcar Tarefa como Concluida:"
        list_tasks
        print "Indice da Tarefa a ser marcada como Concluida: "
        task_index = gets.chomp.to_i - 1
        complete_task(task_index)
    end

    def remove_task_from_cli #remove uma tarefa
        puts "\nRemover Tarefa:"
        list_tasks
        print "Indice da Tarefa a ser removida: "
        task_index = gets.chomp.to_i - 1
        remove_task(task_index)
    end

    def edit_task_from_cli
        puts "\nEditar Tarefa:"
        list_tasks
        print "Indice da Tarefa a ser editada: "
        task_index = gets.chomp.to_i - 1
            
        if task_index >= 0 && task_index < @tasks.length
            task_to_edit = @tasks[task_index]
            puts "Tarefa Atual: #{task_to_edit[:description]}"

            print "Nova Descrição (pressione Enter para manter a mesma): "
            new_description = gets.chomp
            task_to_edit[:description] = new_description unless new_description.empty?

            print "Nova Data de Conclusão (formato YYYY-MM-DD, pressione Enter para manter a mesma): "
            new_due_date_str = gets.chomp
            new_due_date = Date.parse(new_due_date_str) rescue nil
            task_to_edit[:due_date] = new_due_date_str unless new_due_date.nil?

            print "Nova Prioridade (baixa/média/alta, pressione Enter para manter a mesma): "
            new_priority = gets.chomp.downcase
            task_to_edit[:priority] = new_priority unless new_priority.empy?

            print "Novas Categorias (separadas por virgulas, pressione Enter para manter a mesma): "
            new_categories_str = gets.chomp
            new_categories = new_categories_str.splt(",").map(&:strip)
            task_to_edit[:categories] = new_categories unless new_categories.empty?

            puts "Tarefa Editada com Sucesso!"
        else 
            puts "Indice invalido. Tarefa não encontrada."
        end
    end

    def delete_single_task_from_cli
        list_tasks
        print "Indice de Tarefa a ser apagada: "
        task_index = gets.chomp.to_i - 1

        if task_index >= 0 && task_index < @tasks.length
            deleted_task = @tasks.delete_at(task_index)
            update_categories(deleted_task[:categories], remove: true)
            puts "Tarefa #{task_index + 1} apagada: #{deleted_task[:description]}"
        else
            puts "indice invaldo. Tarefa não encontrada."
        end
    end
    def show_priority_distribution #exibe a distrubição de prioridade
        puts "\nDistribuição de Prioridades:"
        priorities = @tasks.map {|task| task [:priority]}.uniq
        priorities.each do |priority|
            count = @tasks.count {|task| task [:priority] == priority}
            puts "#{priority.captalize}: #{count}"
        end
    end

    def show_category_distribution #exibe a distribuição de categorias
        puts "\nDistribuição de Categorias:"
        @categories.each do |category, count|
            puts "#{category.capitalize} #{count}"
        end
    end
end     


# inicia a classe Todo
Todo.new