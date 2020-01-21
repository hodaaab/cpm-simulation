function df = carrier_frequency_estimator(r,fs,freq_res)
% This function compensates for coarse frequency offsets.
% The function squares signal in time to detect pure tones in a signal.
%
% Reference: "Software-defined radio for engineers", pg. 219
% Inputs:
%   r: Complex baseband signal with frequency deviation
%   fs: Sampling frequency (Hz)
%   freq_res: Frequency resolution (Hz)
%
% Outputs: 
%   df: Frequency deviation (Hz) 

%% Check for error
if fs<2*freq_res
    error('Sample rate is too small!');
end

Nfft = 2^ceil(log2(fs/freq_res));

L = length(r);
r = reshape(r,1,[]);

exponent = 2;
r = r.^exponent;
R = zeros(1,Nfft);

%% FFT Calculation
for i=1:L/Nfft
    R = R+abs(fft(r((i-1)*Nfft+(1:Nfft))));
end

if mod(L/Nfft,1)~=0
    R = R+abs(fft(r(end-Nfft+1:end)));
end

%% Plot
figure()
f_x = (-Nfft/2:Nfft/2-1)*(fs/Nfft);
semilogy(f_x, (fftshift(R)))

%% Find Maximum Frequency Index
[~, maxIdx] = max(fftshift(R));
offsetIdx = maxIdx - Nfft/2;  % translate to -Fs/2 : Fs/2

%% Map offset index to a frequency value.
df = fs/Nfft*(offsetIdx-1)/exponent;

