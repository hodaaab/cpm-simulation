function [p, t] = pulse_shape(pulse_name, fs, smpl_per_symbl, varargin)
    Ts = smpl_per_symbl/fs;
    if strcmp(pulse_name, 'rectangular')
        t = (0 : smpl_per_symbl-1)/fs;
%         p_scale = ones(1, smpl_per_symbl)/sqrt(Ts);
        p = linspace(0,0.5,smpl_per_symbl+1);
        p = p(2:end);
    elseif strcmp(pulse_name, 'gaussian')
        beta = varargin{1};
        span_in_symbl = varargin{2};
        t = linspace(-span_in_symbl/2*Ts, span_in_symbl/2*Ts-1/fs, span_in_symbl*smpl_per_symbl);
        p_scale = (1/log(2)) * (qfunc(2*pi*beta*(t-Ts/2)/Ts)-qfunc(2*pi*beta*(t+Ts/2)/Ts));
    elseif strcmp(pulse_name, 'raisedcosine')
        beta = varargin{1};
        span_in_symbl = varargin{2};
        t = 1/fs : 1/fs : span_in_symbl/2*Ts;
        t = [-fliplr(t) 0 t];
        p_scale = (cos(pi*beta*t/Ts).*sinc(t/Ts))./((1-(2*beta.*t./Ts).^2));
        p_scale(t == Ts/(2*beta) | t == -Ts/(2*beta)) = pi/4*sinc(1/(2*beta));
    end
%     Ep = abs(p_scale*p_scale');
%     p = p_scale/sqrt(Ep);
end

