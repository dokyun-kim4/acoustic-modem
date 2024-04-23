clear
addpath('modules\')
load data/short_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission

soundsc(y_t, Fs);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  Put your decoder code here

t = (0:1:length(y_t) - 1)*(1/Fs);
th = (-100:1:99)*(1/Fs);

c =  (cos(2*pi*f_c*t))';

x_d = y_t .*c;

W = 2*pi*f_c;	% set the cutoff frequency to 2 pi * 1000 rads/s

h = W/pi*sinc(W/pi*th);   % this is the impulse response

filtered = conv(x_d, h);

figure()
plot(filtered)
title("filtered")

soundsc(filtered, Fs);

filtered = filtered(1:4096);
filtered(abs(filtered) < 100) = [];

filtered(filtered > 0) = 1;
filtered(filtered < 0) = 0;

figure()
plot(filtered)
title("kkong kkong")
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
a= BitsToString(filtered(1:3520));

