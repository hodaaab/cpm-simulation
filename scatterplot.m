function scatterplot_MT(x)

% This function plots signal scatter

%% Scatter
plot(x,'.');

%% Axes Setting
XMAX = max(abs(real(x)));
YMAX = max(abs(imag(x)));
XYMAX = max(XMAX,YMAX);
xlim(1.1*XYMAX*[-1 1])
ylim(1.1*XYMAX*[-1 1])
axis equal