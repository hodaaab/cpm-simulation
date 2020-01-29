function Zp = matched_filter_deriv_bank(rx_smpl, sps)
% This function calculates time derivative of correlation between received signal and possible ideal signals.
% 4(phase states)*2(prev transition)*2(current transition) = 16(branches/edges)
T = sps;
Zp = zeros(16,1);
% Metrics have been summarized
Zp(1) = -1i*pi/T*sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*pi)));         %Metric for transition from state (0,1)  to (pi/2,1)
Zp(2) = -1i*-pi/T*sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,1)  to (3pi/2,-1)
Zp(3) = -1i*pi/T*sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*pi)));         %Metric for transition from state (0,-1) to (pi/2,1)
Zp(4) = -1i*-pi/T*sum(rx_smpl.*exp(-1i*(0+(0:T-1)'/T*-pi)));       %Metric for transition from state (0,-1) to (3pi/2,-1)
Zp(5) = -1i*pi/T*sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*pi)));      %Metric for transition from state (pi/2,1)  to (pi,1)
Zp(6) = -1i*-pi/T*sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,1)  to (0,-1)
Zp(7) = -1i*pi/T*sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*pi)));      %Metric for transition from state (pi/2,-1) to (pi,1)
Zp(8) = -1i*-pi/T*sum(rx_smpl.*exp(-1i*(pi/2+(0:T-1)'/T*-pi)));    %Metric for transition from state (pi/2,-1) to (0,-1)
Zp(9) = -1i*pi/T*sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*pi)));        %Metric for transition from state (pi,1)  to (3pi/2,1)
Zp(10)= -1i*-pi/T*sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,1)  to (pi/2,-1)
Zp(11)= -1i*pi/T*sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*pi)));        %Metric for transition from state (pi,-1) to (3pi/2,1)
Zp(12)= -1i*-pi/T*sum(rx_smpl.*exp(-1i*(pi+(0:T-1)'/T*-pi)));      %Metric for transition from state (pi,-1) to (pi/2,-1)
Zp(13)= -1i*pi/T*sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));    %Metric for transition from state (3pi/2,1)  to (0,1)
Zp(14)= -1i*-pi/T*sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,1)  to (pi,-1)
Zp(15)= -1i*pi/T*sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*pi)));    %Metric for transition from state (3pi/2,-1) to (0,1)
Zp(16)= -1i*-pi/T*sum(rx_smpl.*exp(-1i*(3*pi/2+(0:T-1)'/T*-pi)));  %Metric for transition from state (3pi/2,-1) to (pi,-1)
end