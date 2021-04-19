function s_out = wwp(x, Fs, N)
% wah-wah // phaser effect

%%%%%%% EFFECT COEFFICIENTS %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% damping factor
% lower the damping factor the smaller the pass band
damp = 0.09;

% min and max centre cutoff frequency of variable bandpass filter
minf = 100; %perfect for sunshine
%maxf = 500;
maxf = 1000;

% wah frequency, how many Hz per second are cycled through
Fw = 3000; %perfect for sunshine
%Fw = 12000;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% change in centre frequency per sample (Hz)
%delta=0.1;
delta = Fw/Fs;
%0.1 => at 44100 samples per second should mean  4.41kHz Fc shift per sec

% create triangle wave of centre frequency values
Fc = minf:delta:maxf;
while(length(Fc) < length(x) )
    Fc = [ Fc (maxf:-delta:minf) ];
    Fc = [ Fc (minf:delta:maxf) ];
end

% trim tri wave to size of input
Fc = Fc(1:length(x));

% difference equation coefficients
F1 = 2*sin((pi*Fc(1))/Fs);  % must be recalculated each time Fc changes
Q1 = 2*damp;                % this dictates size of the pass bands

yh = zeros(size(x));         
s_out = zeros(size(x));
yl = zeros(size(x));

% first sample, to avoid referencing of negative signals
yh(1) = x(1);
s_out(1) = F1*yh(1);
yl(1) = F1*s_out(1);

% apply difference equation to the sample
for n=2:length(x),   
    yh(n) = x(n) - yl(n-1) - Q1*s_out(n-1);
    s_out(n) = F1*yh(n) + s_out(n-1);
    yl(n) = F1*s_out(n) + yl(n-1);
    F1 = 2*sin((pi*Fc(n))/Fs);
end

%normalise
max_s_out = max(abs(s_out));
s_out = s_out/max_s_out;


