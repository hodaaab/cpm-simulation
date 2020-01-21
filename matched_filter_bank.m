function Z = matched_filter_bank(rx_smpl, window_length, sps, p)
T = sps;
Z = zeros(16,window_length);           % 8*2=32 possible transitions
% Metrics have been summarized
for i = 1:window_length
    Z(1,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*pi)));        %Metric for transition from state (0,1)  to (pi/2,1)
    Z(2,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,1)  to (3pi/2,-1)
    Z(3,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*pi)));        %Metric for transition from state (0,-1) to (pi/2,1)
    Z(4,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,-1) to (3pi/2,-1)
    Z(5,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*pi)));     %Metric for transition from state (pi/2,1)  to (pi,1)
    Z(6,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,1)  to (0,-1)
    Z(7,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*pi)));     %Metric for transition from state (pi/2,-1) to (pi,1)
    Z(8,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,-1) to (0,-1)
    Z(9,i) = sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*pi)));       %Metric for transition from state (pi,1)  to (3pi/2,1)
    Z(10,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,1)  to (pi/2,-1)
    Z(11,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*pi)));       %Metric for transition from state (pi,-1) to (3pi/2,1)
    Z(12,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,-1) to (pi/2,-1)
    Z(13,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));   %Metric for transition from state (3pi/2,1)  to (0,1)
    Z(14,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,1)  to (pi,-1)
    Z(15,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));   %Metric for transition from state (3pi/2,-1) to (0,1)
    Z(16,i)= sum(rx_smpl((i+p-2)*T+1:(i+p-1)*T).*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,-1) to (pi,-1)
end
end