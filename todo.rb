class Todo
    def initialize 
        @tasks = []
        load_tasks
    end

    def add_task(task) # adiciona uma tarefa
        @tasks << { description: task, completed: false }
        puts "Tarefa Adicionada: #{task}"
    end

    def list_tasks # lista as tarefas existentes
        puts "Lista de Tarefas"
        @tasks.each_with_index do |task, index|
            status = task[:completed] ? "[X]" : "[ ]"
            puts "#{index + 1}. #{status} #{task[:description]}"
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
            puts "Tarefa Removida: #{removed_task[:description]}"
        else
            puts "Indice invalido. Tarefa não encontrada."
        end
    end

end     


# instancia a classe e testa algumas funcionalidades
todo_list = Todo.new
todo_list.add_task("Estudar Ruby")
todo_list.add_task("Fazer Exercicios de Ruby")
todo_list.list_tasks

# Marca a primeira tarefa como concluida
todo_list.complete_task(0)
todo_list.list_tasks

# Remove a segunda tarefa
todo_list.remove_task(1)
todo_list.list_tasks
