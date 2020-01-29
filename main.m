%% Continuous Phase Modulation - CPM
close all
clear
clc
rng(7);
%% Modulation Parameters
fs = 1e3;                                   % Baseband Sampling Rate
ts = 1/fs;                                  % Baseband Sampling Time
sps = 64;                                   % Sample Per Symbol
Ts = sps*ts;                                % Symbol Time
k = 1;                                      % Bit Per Symbol
M = 2^k;                                    % Modulation Order
pkt_size = 1e4;                             % Number of Symbols in Packet
h = 1/2;                                    % Modulation Index h
L = 1;                                      % Full response / Partial response
pulse_name = 'rectangular';                 % Pulse Shaping Function ('rectangular') NOTE: GMSK IS CONVOLUTION OF GAUSSIAN WITH REC FREQ RESP
viterbi_delay = 6;                          % Viterbi traceback length measured in symbols
fc = 0e6;
dfc = 0;
phi0 = 0*pi/180;
baseband = false;
with_hdr = 0;

%% Channel Parameters
chnl_delay_in_smpl = round(0.8*sps);        % Channel Delay in Sample
chnl_phase_offset = 0*pi/180;               % Channel Phase Offset
phase_amb_opt = 0;                          % Phase ambiguity option
snr_min = 5;                                % Minimum SNR (dB)
snr_max = 5;                                % Maximum SNR (dB)
snr_step = 1;                               % SNR Step (dB)
snr_db = snr_min:snr_step:snr_max;          % SNR Vector (dB)

%% Tx
% if(with_hdr == 0)
    b_tx = randi([0 1], pkt_size, k);
% else
%     hder_bit = repmat(de2bi(hex2dec('1C6387FF5DA4FA325C895958DC5'))',1,k);
%     b_tx_no_hdr = randi([0 1], pkt_size, k);
%     b_tx = [hder_bit; b_tx_no_hdr];    
% end
sym_idx = bi2de(b_tx, 'left-msb')+1;
cons = (-(M-1):2:(M-1));
mod_sym = cons(sym_idx);
if h < 0.5
    error('Frequency separation must be greater than 1/(2T)');
end
q = pulse_shape(pulse_name, fs, sps);
phase = zeros(1, pkt_size*sps);
for i = 1 : pkt_size*sps
    idx = floor((i-1)/sps)+1;
    if(idx>1)
        phase(i) = phase((idx-1)*(sps)) + 2*pi*h*mod_sym(idx)*q(mod(i-1,sps)+1);
    else
        phase(i) = 2*pi*h*mod_sym(idx)*q(mod(i-1,sps)+1);
    end
end
if baseband
    tx_smpl = exp(1i*phase');
else
    n = (0:numel(phase)-1);
    tx_smpl = (exp(1i*phase'+1i*2*pi*(fc+dfc)/fs*n.'+1i*phi0)); % carrier modulation
end
tx_smpl = tx_smpl./sqrt(sps/2);

%% Channel
tx_smpl_delayed = [zeros(chnl_delay_in_smpl,1); tx_smpl];
tx_smpl = tx_smpl_delayed * exp(1i*chnl_phase_offset);
% rec_sym = zeros(length(snr_db),pkt_size-viterbi_delay);
for i = 1:length(snr_db)
    Es_avg = 1;
    Eb = Es_avg/k;
    snr = 10^(snr_db(i)/10);
    var_noise = Eb/snr;
    noise_smpl = sqrt(var_noise.'/2)*(randn(1,length(tx_smpl))+1i*randn(1,length(tx_smpl)));
    tx_smpl_noise = tx_smpl + noise_smpl.';
%     tx_smpl_noise = tx_smpl;
    rx_smpl = tx_smpl_noise;   
    rec_sym(i,:) = cpm_receiver(rx_smpl, viterbi_delay, sps, fs);
    p_err_bit(i) = sum(rec_sym(i,2:end) ~= mod_sym(1:length(mod_sym)-viterbi_delay-1))/length(rec_sym);
end
%% BER Plot
% figure
% semilogy(snr_db, p_err_bit,'-xr')
% grid on
% title("{BER Performance of binary CPM}")
% xlabel('{E_b}/\eta in dB');
% ylabel('Bit Error Rate')
