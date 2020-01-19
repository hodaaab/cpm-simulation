function [rec_sym] = synch_loop(rx_smpl, window_length, sps)
%SYNCH_LOOP Summary of this function goes here
%   Detailed explanation goes here
for p = 1:length(rx_smpl)/sps-(window_length)
    metric = matched_filter_bank(rx_smpl, window_length, sps, p);
    rec_sym(p) = subopt_viterbi(window_length, metric, p);
end
end

