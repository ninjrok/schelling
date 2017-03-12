%% simple segregation simulation
%% Schelling(number_of_agents, width, height, empty_ratio, 
%%         population_ratio, similarity_threshold, n_iterations, file_name)

clc;
clear all;

%% Problem 1
sch = Schelling(2, 40, 40, 0.3, [0.5 0.5], [3/8 1/8], 2000, 'schelling_simulation');

%% Problem 2
%sch = Schelling(2, 40, 40, 0.3, [0.5 0.5], [5/8 3/8], 2000, 'schelling_simulation');

%% Problem 3.1
%sch = Schelling(3, 40, 40, 0.3, [0.225 0.225 0.55], [3/8 3/8 3/8], 1000, 'schelling_simulation');

%% Problem 3.2
%sch = Schelling(3, 40, 40, 0.3, [0.225 0.225 0.55], [5/8 5/8 3/8], 1000, 'schelling_simulation');

%% Problem 3.3
%sch = Schelling(3, 40, 40, 0.3, [0.225 0.225 0.55], [3/8 3/8 5/8], 1000, 'schelling_simulation');

%% Initialize Problem
sch = sch.populate();
sch.update();