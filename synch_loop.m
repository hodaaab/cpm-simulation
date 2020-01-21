function [rec_sym] = synch_loop(rx_smpl, window_length, sps)
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
distance = zeros(8,window_length+1);        % 8 terminal phase states for h=0.5
for p = 1:length(rx_smpl)/sps-(window_length)
    Z = matched_filter_bank(rx_smpl, window_length, sps, p);
    [rec_sym(p), distance] = subopt_viterbi(window_length, real(Z), distance, p);
    
end
end