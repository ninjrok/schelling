classdef Schelling
    
    properties
        number_of_agents
        width
        height
        empty_ratio
        population_ratio
        similarity_threshold
        n_iterations
        agents
        file_name
    end
    
    methods
        function obj = Schelling(number_of_agents, width, height, empty_ratio, population_ratio, similarity_threshold, n_iterations, file_name)
            obj.number_of_agents = number_of_agents;
            obj.width = width;
            obj.height = height;
            obj.empty_ratio = empty_ratio;
            obj.population_ratio = population_ratio;
            obj.similarity_threshold = similarity_threshold;
            obj.n_iterations = n_iterations;
            obj.agents = zeros(obj.width, obj.height);
            obj.file_name = file_name;
        end
        
        function obj = populate(obj)
            filled_cells = obj.width*obj.height - obj.width*obj.height*obj.empty_ratio - 1;
            populated_cells = round(obj.population_ratio * filled_cells);
            disp(populated_cells);
            % Generate a 1 dimensional cell with proportionate values
            obj.agents = zeros(1, obj.height*obj.width - sum(populated_cells));
            for i=1:length(populated_cells)
                obj.agents = [obj.agents ones(1, populated_cells(i))*i];
            end
            % Convert 1D cell to nxn and shuffle
            obj.agents = reshape(obj.agents, [obj.height, obj.width]);
            for i=1:obj.height
                for j=1:obj.width
                    xidx = randperm(obj.height, 1);
                    yidx = randperm(obj.width, 1);
                    temp = obj.agents(i,j);
                    obj.agents(i,j) = obj.agents(xidx,yidx);
                    obj.agents(xidx,yidx) = temp;
                end
            end
        end
        
        function val = is_unsatisfied(obj, x, y)
            current_agent = obj.agents(x,y);
            count_similar = 0;
            count_different = 0;
            neighbours_index = obj.get_neighbours_index(x,y);
            for i=1:1:length(neighbours_index)
                if current_agent == obj.agents(neighbours_index(i));
                    count_similar = count_similar+1;
                else
                    count_different = count_different+1;
                end
            end
            if count_similar+count_different == 0
                val = false;
            elseif current_agent == 1
                val = (count_similar/(count_similar+count_different)) < obj.similarity_threshold(1);
            elseif current_agent == 2
                val = (count_similar/(count_similar+count_different)) < obj.similarity_threshold(2);
            elseif current_agent == 3
                val = (count_similar/(count_similar+count_different)) < obj.similarity_threshold(3);
            end
        end
        
        function update(obj)
                agent_matrix = zeros(obj.width,obj.height,obj.n_iterations);
                agent_matrix(:,:,1) = obj.agents(:,:);
            for i=2:1:obj.n_iterations
                n_changes = 0;
                for j = 1:1:obj.width*obj.height
                    [x,y] = ind2sub([obj.width, obj.height],j);
                    if obj.agents(x,y) == 0
                       continue; 
                    end
                    if is_unsatisfied(obj,x,y) ~= 0
                        obj = move_to_empty(obj,x,y);
                        n_changes = n_changes+1;
                    end
                end
                spy(obj.agents(:,:) == 1,'y');
                hold on
                spy(obj.agents(:,:) == 2,'r');
                hold on
                spy(obj.agents(:,:) == 3, 'c');
                hold off
                pause(0.01);
                agent_matrix(:,:,i) = obj.agents(:,:);
                fprintf('Iteration %d, changed %d \n',i,n_changes);
                if n_changes == 0
                    fprintf('System stabilized\n');
                    break;
                end
            end
            agent_matrix = agent_matrix(:,:,1:i);
            save(obj.file_name, 'agent_matrix','-v7.3');
        end
        
        
        function obj = move_to_empty(obj, x, y)
            current_agent = obj.agents(x,y);
            empty_houses = find(obj.agents==0);
            index_to_move = randi([1 length(empty_houses)],1);
            obj.agents(empty_houses(index_to_move)) = current_agent;
            obj.agents(x,y) = 0;
        end
        
        % Moore neighbourhood
        function [indexes] = get_neighbours_index(obj, x, y)
            indexes = [];
            
            if x>1
                indexes = [ indexes sub2ind([obj.width, obj.height],x-1, y)];
                if y>1
                    indexes =[ indexes sub2ind([obj.width, obj.height],x-1, y-1)];
                end
                if y<obj.height
                    indexes =[ indexes sub2ind([obj.width, obj.height],x-1, y+1)];
                end
            end
            
            if x<obj.width
                indexes =[ indexes sub2ind([obj.width, obj.height],x+1, y)];
                if y>1
                    indexes =[ indexes sub2ind([obj.width, obj.height],x+1, y-1)];
                end
                if y<obj.height
                    indexes =[ indexes sub2ind([obj.width, obj.height],x+1, y+1)];
                end
            end
            
            if y<obj.height
                indexes =[ indexes sub2ind([obj.width, obj.height],x, y+1)];
            end
            
            if y<obj.height && y>1
                indexes =[ indexes sub2ind([obj.width, obj.height],x, y-1)];
            end
        end
    end
    
end
