function [prev_state, rec_sym] = prev_stage(curr_state,distance_prev,metric)
%Starts from the current decoded state, takes input as minimum distance to
%reach that state and previous state And returns previous state and decoded
%information bit corresponding to that state.

if(curr_state == 1)
    if(distance_prev(7)+metric(13) >= distance_prev(8)+metric(15))
        prev_state = 7; rec_sym = 1;
    else
        prev_state = 8; rec_sym = -1;
    end
elseif(curr_state == 2)
    if(distance_prev(3)+metric(6) >= distance_prev(4)+metric(8))
        prev_state = 3; rec_sym = 1;
    else
        prev_state = 4; rec_sym = -1;
    end
elseif(curr_state == 3)
    if(distance_prev(1)+metric(1) >= distance_prev(2)+metric(3))
        prev_state = 1; rec_sym = 1;
    else
        prev_state = 2; rec_sym = -1;
    end
    
elseif(curr_state == 4)
    if(distance_prev(5)+metric(10) >= distance_prev(6)+metric(12))
        prev_state = 5; rec_sym = 1;
    else
        prev_state = 6; rec_sym = -1;
    end
elseif(curr_state == 5)
    if(distance_prev(3)+metric(5) >= distance_prev(4)+metric(7))
        prev_state = 3; rec_sym = 1;
    else
        prev_state = 4; rec_sym = -1;
    end
elseif(curr_state == 6)
    if(distance_prev(7)+metric(14) >= distance_prev(8)+metric(16))
        prev_state = 7; rec_sym = 1;
    else
        prev_state = 8; rec_sym = -1;
    end
elseif(curr_state == 7)
    if(distance_prev(5)+metric(9) >= distance_prev(6)+metric(11))
        prev_state = 5; rec_sym = 1;
    else
        prev_state = 6; rec_sym = -1;
    end
elseif(curr_state == 8)
    if(distance_prev(1)+metric(2) >= distance_prev(2)+metric(4))
        prev_state = 1; rec_sym = 1;
    else
        prev_state = 2; rec_sym = -1;
    end
end
end