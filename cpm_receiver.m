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

% Initializations
phasePLL.LoopFilter = dsp.IIRFilter('Numerator', [1 0], 'Denominator', [1 -1]);
phasePLL.Integrator = dsp.IIRFilter('Numerator', [0 1], 'Denominator', [1 -1]);
timingPLL.LoopFilter = dsp.IIRFilter('Numerator', [1 0], 'Denominator', [1 -1]);
timingPLL.Integrator = dsp.IIRFilter('Numerator', [0 1], 'Denominator', [1 -1]);
distance = zeros(8,viterbi_delay+1);  % 8 terminal phase states for h=0.5
Z = zeros(16,viterbi_delay);
Z_prime = zeros(16,viterbi_delay);
phase_est = 0;
timing_est = 0;

% Coarse Carrier Synchronization
% df_est = carrier_frequency_estimator(rx_smpl,fs,fs/10000);
% n = (0:numel(rx_smpl)-1);
% rx_smpl = exp(-1i*2*pi*df_est/fs*n.').*rx_smpl;
n = 0;
a = 1.5;
while n < length(rx_smpl)-20
    n = n + 1;
    itr = itr + 1;
%     rx_smpl(n) = rx_smpl(n).*exp(1i*phase_est);
    if mod(n,sps) == 0
        k = n/sps;
        rx_symbl_frame = rx_smpl((k-1)*sps+round(a*timing_est)+1:k*sps+round(a*timing_est));
%         n = k*sps+round(a*timing_est);
        if k == 1
            for i = 2:8
                distance(i,1) = -Inf;
            end
        else
            distance(:,1) = distance(:,2);
        end
        if k <= viterbi_delay
            Z(:,mod(k-1,viterbi_delay)+1) = matched_filter_bank(rx_symbl_frame, sps);
            Z_prime(:,mod(k-1,viterbi_delay)+1) = matched_filter_deriv_bank(rx_symbl_frame, sps);
        else
            % Gives symbol with Viterbi traceback delay (window_length)
            [rec_sym(k-viterbi_delay), distance] = subopt_viterbi(viterbi_delay, real(Z), distance);
            Z(:,1:viterbi_delay-1) = Z(:,2:viterbi_delay);
            Z(:,viterbi_delay) = matched_filter_bank(rx_symbl_frame, sps);
            Z_prime(:,1:viterbi_delay-1) = Z_prime(:,2:viterbi_delay);
            Z_prime(:,viterbi_delay) = matched_filter_deriv_bank(rx_symbl_frame, sps);
            index = best_metric_index(distance(:,end), real(Z(:,end)));
            % Fine Carrier Synchronization
%             phase_est = carrier_synchronizer(imag(Z(index,end)),sps,phasePLL);
            % Timing Synchronization
            timing_est = timing_synchronizer(a*real(Z_prime(index,end)), sps, timingPLL);
            for_plot(k) = a*timing_est;
%             scatter(k,ceil(timing_est))
%             hold on
        end
    end
end
plot(round(for_plot))
end