function [rec_sym] = cpm_receiver(rx_smpl, viterbi_delay, sps, fs)
% This function maintains the main loop including PLLs and Viterbi receiver.
%
% Inputs
% rx_smpl:          Samples of baseband signal received
% window_length:    Traceback delay of Viterbi receiver
% sps:              Samples per symbol
%
% Output
% rec_sym:          Detected symbols from Viterbi receiver
%
% Coarse Carrier Synchronization
df_est = carrier_frequency_estimator(rx_smpl,fs,fs/4000);
n = (0:numel(rx_smpl)-1);
rx_smpl = exp(-1i*2*pi*df_est/fs*n.').*rx_smpl;
% Filter initializations for phase detector PLL
LoopFilter = dsp.IIRFilter('Numerator', [1 0], 'Denominator', [1 -1]);
Integrator = dsp.IIRFilter('Numerator', [0 1], 'Denominator', [1 -1]);

distance = zeros(8,viterbi_delay+1);  % 8 terminal phase states for h=0.5
Z = zeros(16,viterbi_delay);
for_plot = zeros(length(rx_smpl)/sps,1);
phase_est = 0;
for n = 1:length(rx_smpl)
    rx_smpl(n) = rx_smpl(n).*exp(1i*phase_est);
    if mod(n,sps) == 0
        k = n/sps;
        rx_symbl_frame = rx_smpl((k-1)*sps+1:k*sps);
        if k == 1
            for i = 2:8
                distance(i,1) = -Inf;
            end
        else
            distance(:,1) = distance(:,2);
        end
        if k <= viterbi_delay
            Z(:,mod(k-1,viterbi_delay)+1) = matched_filter_bank(rx_symbl_frame, sps);
        else
            % Gives symbol with Viterbi traceback delay (window_length)
            [rec_sym(k-viterbi_delay), distance] = subopt_viterbi(viterbi_delay, real(Z), distance);
            Z(:,1:viterbi_delay-1) = Z(:,2:viterbi_delay);
            Z(:,viterbi_delay) = matched_filter_bank(rx_symbl_frame, sps);
            index = best_metric_index(distance(:,end), real(Z(:,end)));
            % Fine Carrier Synchronization
            phase_est = carrier_synchronizer(imag(Z(index,end)),sps,LoopFilter,Integrator,k);
            for_plot(k) = phase_est;
        end
    end
end
end