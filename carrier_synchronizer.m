function [y,phaseEstimate] = carrier_synchronizer(x,sps)

% This function compensates for frequency offsets and phase rotations.
% The function uses a closed-loop PLL approach to reduce  frequency offset and phase rotation.
% The phase error is generated from a hard decision of the received signal.
%
% References:
%   [1] "Software-defined radio for engineers", pg. 227
%
% Inputs:
%   x: Complex baseband signal with frequency deviation
%   sps: sample per symbol
%
% Outputs:
%   y: Output symbols of synchronizer
%   phaseEstimate: Estimation of the phase errors in radians

%% Main Synchronization Parameters
DampingFactor = 0.7;
NormalizedLoopBandwidth = 0.001;
obj.CustomPhaseOffset = 0;
% Select error generation based on modulation and gain value
% Kp: Slope of phase detector S-Curve linear range
obj.pPED = 1;
obj.pPhaseErrorDetectorGain = 2; % Kp

% Set loop gains
obj.DampingFactor = DampingFactor;
obj.NormalizedLoopBandwidth = NormalizedLoopBandwidth;
obj.SamplesPerSymbol = sps;
obj = CalculateLoopGains(obj);

% Invert DDS output to correct not estimate
obj.pDigitalSynthesizerGain = -1;

% Reset parameters and objects to initial states
obj.pLoopFilterState = 0;
obj.pIntegFilterState = 0;
obj.pDDSPreviousInput = 0;
obj.pPhase = 0;
obj.pPreviousSample = 0;

%% Synchronization
% Copying obj parameters for speed improvement
loopFiltState = obj.pLoopFilterState;
integFiltState = obj.pIntegFilterState;
DDSPreviousInp = obj.pDDSPreviousInput;
previousSample = obj.pPreviousSample;

% Preallocate outputs
y = zeros(size(x));
phaseCorrection = zeros(size(x));

% PLL Loop 
for k = 1:length(x)
    % Find Phase Error
    phErr = sign(real(previousSample)).*imag(previousSample)...
        - sign(imag(previousSample)).*real(previousSample);
    
    % Phase accumulate and correct
    y(k) = x(k)*exp(1i*obj.pPhase);
    
    % Loop Filter
    loopFiltOut = phErr*obj.pIntegratorGain + loopFiltState;
    loopFiltState = loopFiltOut;
    
    % Direct digital synthesizer implemented as an integrator
    DDSOut = DDSPreviousInp + integFiltState;
    integFiltState = DDSOut;
    DDSPreviousInp = phErr*obj.pProportionalGain+loopFiltOut;
    
    obj.pPhase = obj.pDigitalSynthesizerGain*DDSOut;
    
    phaseCorrection(k) = obj.pPhase;
    previousSample = y(k);
end

% Update previous sample and phase rotate as desired
y = y*exp(1i*obj.pActualPhaseOffset);

% Changing sign to convert from correction value to estimate
phaseEstimate = -real(phaseCorrection+obj.pActualPhaseOffset);

%Updating states: In cuurent version it is not necessary
obj.pLoopFilterState = loopFiltState;
obj.pIntegFilterState = integFiltState;
obj.pPreviousSample = complex(previousSample);
obj.pDDSPreviousInput = DDSPreviousInp;

end

function obj = CalculateLoopGains(obj)

% Calculate loops gains and filter coefficient.
%   Refer to equation C.61 of Appendix C of "Digital Communications - A Discrete-Time Approach" by Michael Rice

PhaseRecoveryLoopBandwidth = obj.NormalizedLoopBandwidth *obj.SamplesPerSymbol;

% K0
PhaseRecoveryGain = obj.SamplesPerSymbol;

theta = PhaseRecoveryLoopBandwidth/((obj.DampingFactor + 0.25/obj.DampingFactor)*obj.SamplesPerSymbol);
d = 1 + 2*obj.DampingFactor*theta + theta*theta;

% K1
obj.pProportionalGain = (4*obj.DampingFactor*theta/d)/(obj.pPhaseErrorDetectorGain*PhaseRecoveryGain);

% K2
obj.pIntegratorGain = (4/obj.SamplesPerSymbol*theta*theta/d)/(obj.pPhaseErrorDetectorGain*PhaseRecoveryGain);

% Phase offset adjustment
obj.pActualPhaseOffset = obj.CustomPhaseOffset-pi/4;
 
end
