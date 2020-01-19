function metric = matched_filter_bank(rx_smpl, window_length, sps, p)
T = sps;
metric = zeros(16,window_length);           % 8*2=32 possible transitions
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
end
end