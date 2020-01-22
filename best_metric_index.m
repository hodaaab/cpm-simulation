function index = best_metric_index(distance, metric)
% This function returns a number between 1 and 16 indicating last metric resulting in best path.
ind = zeros(8,1);
temp_dist = zeros(8,1);
[temp_dist(1),ind(1)] = max([distance(7)+metric(13),distance(8)+metric(15)]);   %Minimum distance to reach state 1 : (0,1)
[temp_dist(2),ind(2)] = max([distance(3)+metric(6),distance(4)+metric(8)]);     %Minimum distance to reach state 2 : (0,-1)
[temp_dist(3),ind(3)] = max([distance(1)+metric(1),distance(2)+metric(3)]);     %Minimum distance to reach state 3 : (pi/2,1)
[temp_dist(4),ind(4)] = max([distance(5)+metric(10),distance(6)+metric(12)]);   %Minimum distance to reach state 4 : (pi/2,-1)
[temp_dist(5),ind(5)] = max([distance(3)+metric(5),distance(4)+metric(7)]);     %Minimum distance to reach state 5 : (pi,1)
[temp_dist(6),ind(6)] = max([distance(7)+metric(14),distance(8)+metric(16)]);   %Minimum distance to reach state 6 : (pi,-1)
[temp_dist(7),ind(7)] = max([distance(5)+metric(9),distance(6)+metric(11)]);    %Minimum distance to reach state 7 : (3pi/2,1)
[temp_dist(8),ind(8)] = max([distance(1)+metric(2),distance(2)+metric(4)]);     %Minimum distance to reach state 8 : (3pi/2,-1)
[~,max_dist_ind] = max(temp_dist);
switch max_dist_ind
    case 1
        if ind(1) == 1
            index = 13; return
        else
            index = 15; return
        end
    case 2
        if ind(2) == 1
            index = 6; return
        else
            index = 8; return
        end
    case 3
        if ind(3) == 1
            index = 1; return
        else
            index = 3; return
        end
    case 4
        if ind(4) == 1
            index = 10; return
        else
            index = 12; return
        end
    case 5
        if ind(5) == 1
            index = 5; return
        else
            index = 7; return
        end
    case 6
        if ind(6) == 1
            index = 14; return
        else
            index = 16; return
        end
    case 7
        if ind(7) == 1
            index = 9; return
        else
            index = 11; return
        end
    case 8
        if ind(8) == 1
            index = 2; return
        else
            index = 4; return
        end
end
end

