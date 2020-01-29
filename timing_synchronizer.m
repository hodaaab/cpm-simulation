function timing_est = timing_synchronizer(timing_error, sps, PLL)

% This function compensates for timing offsets.
% The function uses a closed-loop PLL approach to reduce timing offset.
% The timing error is generated from a hard decision of the received signal.
%
% References:
%   [1] "Software-defined radio for engineers", pg. 227
%
% Outputs:
%   timing_est: Estimation of the timing error in samples

%% Main Synchronization Parameters
DampingFactor = 5;
NormalizedLoopBandwidth = 0.09;

%% Calculate coefficients for FFC
PhaseRecoveryLoopBandwidth = NormalizedLoopBandwidth*sps;
PhaseRecoveryGain = sps;
order = 2;
PhaseErrorDetectorGain = order; DigitalSynthesizerGain = -1;
theta = PhaseRecoveryLoopBandwidth/...
    ((DampingFactor + 0.25/DampingFactor)*sps);
delta = 1 + 2*DampingFactor*theta + theta*theta;
% G1
ProportionalGain = (4*DampingFactor*theta/delta)/...
    (PhaseErrorDetectorGain*PhaseRecoveryGain);
% G3
IntegratorGain = (4/sps*theta*theta/delta)/...
    (PhaseErrorDetectorGain*PhaseRecoveryGain);
% PED
tErr = timing_error;
% Loop Filter
loopFiltOut = PLL.LoopFilter(tErr*IntegratorGain);

% Direct Digital Synthesizer
DDSOut = PLL.Integrator(tErr*ProportionalGain + loopFiltOut);
timing_est = DigitalSynthesizerGain * DDSOut * sps/pi;
end