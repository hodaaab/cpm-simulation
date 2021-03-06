function phase_est = carrier_synchronizer(phase_error, sps, PLL)

% This function compensates for frequency offsets and phase rotations.
% The function uses a closed-loop PLL approach to reduce  frequency offset and phase rotation.
% The phase error is generated from a hard decision of the received signal.
%
% References:
%   [1] "Software-defined radio for engineers", pg. 227
%
% Outputs:
%   phaseEstimate: Estimation of the phase errors in radians

%% Main Synchronization Parameters
DampingFactor = 1;
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
phErr = phase_error;
% Loop Filter
loopFiltOut = PLL.LoopFilter(phErr*IntegratorGain);

% Direct Digital Synthesizer
DDSOut = PLL.Integrator(phErr*ProportionalGain + loopFiltOut);
phase_est = DigitalSynthesizerGain * DDSOut;

end
