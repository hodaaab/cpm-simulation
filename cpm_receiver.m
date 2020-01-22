function [rec_sym] = cpm_receiver(rx_smpl, window_length, sps, fs)
% This function maintains the main loop including PLLs and Viterbi receiver.
%
% Inputs
% rx_smpl:          Samples of baseband signal received
% window_length:    Traceback delay of Viterbi receiver
% sps:              Samples per symbol
%
% Output
% rec_sym:          Detected symbols from Viterbi receiver
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Coarse Carrier Synchronization
% df_est = carrier_frequency_estimator(rx_smpl,fs,fs/4000);
% n = (0:numel(rx_smpl)-1);
% rx_smpl = exp(-1i*2*pi*df_est/fs*n.').*rx_smpl;
distance = zeros(8,window_length+1);  % 8 terminal phase states for h=0.5
Z = zeros(16,window_length);
for p = 1:length(rx_smpl)/sps
    rx_symbl_frame = rx_smpl((p-1)*sps+1:p*sps);
    if p == 1
        for i = 2:8
            distance(i,1) = -Inf;
        end
    else
        distance(:,1) = distance(:,2);
    end
    if p <= window_length
        Z(:,mod(p-1,window_length)+1) = matched_filter_bank(rx_symbl_frame, sps);
    else
        % Gives symbol with Viterbi traceback delay (window_length)
        [rec_sym(p-window_length), distance] = subopt_viterbi(window_length, real(Z), distance);
        Z(:,1:window_length-1) = Z(:,2:window_length);
        Z(:,window_length) = matched_filter_bank(rx_symbl_frame, sps);
        index = best_metric_index(distance(:,end), real(Z(:,end)));
        % Fine Carrier Synchronization
%         [rx_smpl,phaseEstimate] = carrier_synchronizer(rx_smpl,sps);
    end
end
end