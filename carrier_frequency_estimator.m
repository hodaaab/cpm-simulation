function df = carrier_frequency_estimator(r,fs,freq_res)

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
plot(f_x, fftshift(R))

%% Find Maximum Frequency Index
% R_shift = fftshift(R);
% [~, ind1] = max(R_shift);
% R_shift(ind1)      = -Inf;
% [~, ind2] = max(R_shift);
% offsetIdx = (ind1+ind2)/2 - Nfft/2;
[~, maxIdx] = max(fftshift(R));
offsetIdx = maxIdx - Nfft/2;  % translate to -Fs/2 : Fs/2

%% Map offset index to a frequency value.
df = fs/Nfft*(offsetIdx-1)/exponent;

