require 'date'
class Todo
    def initialize 
        @tasks = []
        @categories = Hash.new(0)
        load_tasks
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

    private

    def load_tasks #implementação de leitura das tarefas 
    end

    def update_categories(categories, remove: false)
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

end     


# instancia a classe e testa algumas funcionalidades
todo_list = Todo.new
todo_list.add_task("Estudar Ruby", Date.new(2024, 1, 21), "média", ["estudo"])
todo_list.add_task("Fazer Exercicios de Ruby", Date.new(2024, 2, 15), "alta", ["exercicio", "programação"])
todo_list.list_tasks

# Marca a primeira tarefa como concluida
todo_list.complete_task(0)
todo_list.list_tasks

# Remove a segunda tarefa
todo_list.remove_task(1)
todo_list.list_tasks
