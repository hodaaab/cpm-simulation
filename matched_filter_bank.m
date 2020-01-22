function Z = matched_filter_bank(rx_smpl, sps)
% This function calculates correlation between received signal and possible ideal signals.
% 4(phase states)*2(prev transition)*2(current transition) = 16(branches/edges)
T = sps;
Z = zeros(16,1);
% Metrics have been summarized
Z(1) = sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*pi)));        %Metric for transition from state (0,1)  to (pi/2,1)
Z(2) = sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,1)  to (3pi/2,-1)
Z(3) = sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*pi)));        %Metric for transition from state (0,-1) to (pi/2,1)
Z(4) = sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,-1) to (3pi/2,-1)
Z(5) = sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*pi)));     %Metric for transition from state (pi/2,1)  to (pi,1)
Z(6) = sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,1)  to (0,-1)
Z(7) = sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*pi)));     %Metric for transition from state (pi/2,-1) to (pi,1)
Z(8) = sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,-1) to (0,-1)
Z(9) = sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*pi)));       %Metric for transition from state (pi,1)  to (3pi/2,1)
Z(10)= sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,1)  to (pi/2,-1)
Z(11)= sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*pi)));       %Metric for transition from state (pi,-1) to (3pi/2,1)
Z(12)= sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,-1) to (pi/2,-1)
Z(13)= sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));   %Metric for transition from state (3pi/2,1)  to (0,1)
Z(14)= sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,1)  to (pi,-1)
Z(15)= sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));   %Metric for transition from state (3pi/2,-1) to (0,1)
Z(16)= sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,-1) to (pi,-1)
end