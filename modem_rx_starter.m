close all
addpath('modules\')
load data/long_modem_rx.mat

% The received signal includes a bunch of samples from before the
% transmission started so we need discard these samples that occurred before
% the transmission started. 

start_idx = find_start_of_signal(y_r,x_sync);
% start_idx now contains the location in y_r where x_sync begins
% we need to offset by the length of x_sync to only include the signal
% we are interested in
y_t = 5*y_r(start_idx+length(x_sync):end); % y_t is the signal which starts at the beginning of the transmission

figure()
plot(y_t)
title("original")

soundsc(y_t, Fs);

t = (0:1:length(y_t) - 1)*(1/Fs);
th = (-100:1:99)*(1/Fs);

c =  (cos(2*pi*f_c*t))';

x_d = y_t .*c;

figure()
plot_ft_rad(x_d, Fs)
title("modulated")

W = 2*pi*f_c;	% set the cutoff frequency to 2 pi * 1000 rads/s

h = W/pi*sinc(W/pi*th);   % this is the impulse response

filtered = conv(x_d, h);

figure()
plot_ft_rad(filtered,Fs)
title("filtered")

soundsc(filtered, Fs);

figure()
plot(filtered)
title("recreated digital signal 1")


filtered = downsample(filtered, 100);


filtered = filtered(3:msg_length*8+2);
filtered(filtered > 0) = 1;
filtered(filtered < 0) = 0;


figure()
plot(filtered)
title("recreated digital signal")

% add filler 0s to make the length multiples of 8
%filler = zeros(8-mod(length(filtered),8),1);
%filtered = [filtered; filler];

% convert to a string assuming that x_d is a vector of 1s and 0s
% representing the decoded bits
a= BitsToString(filtered);

