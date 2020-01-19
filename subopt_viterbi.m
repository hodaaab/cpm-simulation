function rec_sym = subopt_viterbi(rx_smpl, window_length, sps)
    T = sps;
    distance = zeros(8,window_length+1);        % 8 terminal phase states for h=0.5
    metric = zeros(16,window_length);           % 8*2=32 possible transitions
    for p = 1:length(rx_smpl)/sps-(window_length)
        distance(:,1) = distance(:,2);
        if p == 1
            for i = 2:8
               distance(i,1) = -Inf;
            end
        end
        % Metrics have been summarized
        for i = 1:window_length
            metric(1,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*pi))));        %Metric for transition from state (0,1)  to (pi/2,1)
            metric(2,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*-pi))));       %Metric for transition from state (0,1)  to (3pi/2,-1)
            metric(3,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*pi))));        %Metric for transition from state (0,-1) to (pi/2,1)
            metric(4,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*-pi))));       %Metric for transition from state (0,-1) to (3pi/2,-1)
            metric(5,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*pi))));     %Metric for transition from state (pi/2,1)  to (pi,1)
            metric(6,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*-pi))));    %Metric for transition from state (pi/2,1)  to (0,-1)
            metric(7,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*pi))));     %Metric for transition from state (pi/2,-1) to (pi,1)   
            metric(8,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*-pi))));    %Metric for transition from state (pi/2,-1) to (0,-1)
            metric(9,i) = real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*pi))));       %Metric for transition from state (pi,1)  to (3pi/2,1)
            metric(10,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*-pi))));      %Metric for transition from state (pi,1)  to (pi/2,-1)
            metric(11,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*pi))));       %Metric for transition from state (pi,-1) to (3pi/2,1)   
            metric(12,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*-pi))));      %Metric for transition from state (pi,-1) to (pi/2,-1)
            metric(13,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*pi))));   %Metric for transition from state (3pi/2,1)  to (0,1)
            metric(14,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi))));  %Metric for transition from state (3pi/2,1)  to (pi,-1)
            metric(15,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*pi))));   %Metric for transition from state (3pi/2,-1) to (0,1)   
            metric(16,i)= real(sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi))));  %Metric for transition from state (3pi/2,-1) to (pi,-1)
            
            distance(1,i+1) = max(distance(7,i)+metric(13,i),distance(8,i)+metric(15,i));               %Minimum distance to reach state 1 : (0,1)
            distance(2,i+1) = max(distance(3,i)+metric(6,i),distance(4,i)+metric(8,i));                 %Minimum distance to reach state 2 : (0,-1)
            distance(3,i+1) = max(distance(1,i)+metric(1,i),distance(2,i)+metric(3,i));                 %Minimum distance to reach state 3 : (pi/2,1)
            distance(4,i+1) = max(distance(5,i)+metric(10,i),distance(6,i)+metric(12,i));               %Minimum distance to reach state 4 : (pi/2,-1)
            distance(5,i+1) = max(distance(3,i)+metric(5,i),distance(4,i)+metric(7,i));                 %Minimum distance to reach state 5 : (pi,1)
            distance(6,i+1) = max(distance(7,i)+metric(14,i),distance(8,i)+metric(16,i));               %Minimum distance to reach state 6 : (pi,-1)
            distance(7,i+1) = max(distance(5,i)+metric(9,i),distance(6,i)+metric(11,i));                %Minimum distance to reach state 7 : (3pi/2,1)
            distance(8,i+1) = max(distance(1,i)+metric(2,i),distance(2,i)+metric(4,i));                 %Minimum distance to reach state 8 : (3pi/2,-1)
        end
    
        [~,state] = max(distance(:,window_length+1)); %For the final stage pick the state corresponding to minimum weight
    
        %Starting from the final stage using the state, distances of previous stage and metric,
        %decoding the previous state and the corresponding Code bit
        for j=window_length:-1:2
            [state,rec_sym_temp] = prev_stage(state,distance(:,j),metric(:,j));
        end
        rec_sym(p) = rec_sym_temp;
    end             %Demod for one block ends here
    
end