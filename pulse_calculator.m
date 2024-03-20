clear; clc; close all % clear all memory
%%
files = dir('*.csv'); % load all csv files in working directory
LENGTH = length(files);
BPM_HZ_CONVERSION = 60; % beats per min = beats per 60 sec. Hz = per 1 sec.

% final outputs
bpm = []; % store calculated heart rate in bpm
file_names = string.empty; % store file names associated with each heart rate

% iterate through each file
for i=1:LENGTH
    name = files(i).name;
    file_names(i) = name; % store file name for final output
    x = load(name, '-ascii'); % load data from csv file
    fs = x(1, 1); % fs in FFT, also equals frames per second (fps) of video
    mean_pix_int = x(1, 1:length(x));

    % perform FFT
    y = fft(x);
    f = (0:length(y)-1)*fs/length(y);
    n = length(mean_pix_int);
    fshift = (-n/2:n/2-1)*(fs/n); % frequency
    yshift = fftshift(y);

    ynoise = fft(x);
    ynoiseshift = fftshift(ynoise);
    power = abs(ynoiseshift).^2/n; % power

    % calculate bpm:
    % find max of power spectra within a limit of feasible heart rate.
    % bpm = frequency at max power
    lowLim = 40/BPM_HZ_CONVERSION; % lower limit in Hz (=40 bpm)
    result = interp1(fshift,fshift,lowLim,'nearest');
    start = find(fshift==result); % index of lower limit
    
    highLim = 200/BPM_HZ_CONVERSION; % upper limit in Hz (=200 bpm)
    result = interp1(fshift,fshift,highLim,'nearest');
    stop = find(fshift==result); % index of upper limit
    
    % bound power and frequency array by lower and upper limit of heart
    % rate found from above
    power_cut = power(start:stop);
    fshift_cut = fshift(start:stop);
    
    maxPower = max(power_cut); % max value in power spectra
    index = find(power_cut==maxPower); % index of fshift at max power
    pulse = fshift_cut(index)*BPM_HZ_CONVERSION; % freq at max power

    % determine if distance between median-75th quantile is greater than
    % max-to-75th quantile. This is used to determine if a max value in
    % the power spectra is significantly greater than other values.
    med_75 = quantile(power_cut, 0.75) - median(power_cut);
    max_75 = maxPower - quantile(power_cut, 0.75);
    ratio = max_75 / med_75;
    threshold = 15;

    if ratio < threshold % if no clear bpm detected, final bpm = 0 (not detectable)
        bpm = [bpm 0];
    else
        bpm = [bpm pulse]; % final bpm, saved to array
    end
end
%%
% plot power spectrum
plot(fshift_cut*BPM_HZ_CONVERSION, power_cut)
title('Power spectrum')
xlabel('Pulse (BPM)') % do we want to plot frequency?
ylabel('Power')