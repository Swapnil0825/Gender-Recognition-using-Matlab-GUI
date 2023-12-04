% Load the first sound file
filename1 = 'First_Voice.wav';
[soundData1, fs1] = audioread(filename1);

% Load the second sound file
filename2 = 'Second_Voice.wav';
[soundData2, fs2] = audioread(filename2);

% Check if both files have the same sampling rate
if fs1 ~= fs2
error('Both sound files should have the same sampling rate.');
end

% Check if both files have the same duration
if size(soundData1,1) ~= size(soundData2,1)
error('Both sound files should have the same duration.');
end

%  First sound file Pitch Calculation
% Define analysis parameters
frameDuration = 0.03; % duration of each frame in seconds
hopDuration = 0.015; % hop size between frames in seconds
minPitch = 50; % minimum pitch in Hz
maxPitch = 500; % maximum pitch in Hz
% Calculate frame and hop sizes in samples
frameSize = round(frameDuration * fs1);
hopSize = round(hopDuration * fs1);
% Calculate autocorrelation function
lags = 0:frameSize-1;
acf = xcorr(soundData1, frameSize-1, 'coeff');
acf = acf(lags >= round(fs1/maxPitch) & lags <= round(fs1/minPitch));
% Find the highest peak in the autocorrelation function
[~, maxIdx] = max(acf);
pitch1 = fs1 / (lags(maxIdx) + eps);


%  second sound file Pitch Calculation
% Define the threshold pitch and spectral rolloff values to distinguish between male and female voices
maleThresholdPitch = 120; % Hz
femaleThresholdPitch = 250; % Hz

% Define analysis parameters
frameDuration = 0.03; % duration of each frame in seconds
hopDuration = 0.015; % hop size between frames in seconds
minPitch = 50; % minimum pitch in Hz
maxPitch = 500; % maximum pitch in Hz

% Calculate frame and hop sizes in samples
frameSize = round(frameDuration * fs2);
hopSize = round(hopDuration * fs2);

% Calculate autocorrelation function
lags = 0:frameSize-1;
acf = xcorr(soundData2, frameSize-1, 'coeff');
acf = acf(lags >= round(fs2/maxPitch) & lags <= round(fs2/minPitch));

% Find the highest peak in the autocorrelation function
[~, maxIdx] = max(acf);
pitch2 = fs2 / (lags(maxIdx) + eps);

% Make a guess at the gender based on the pitch and spectral rolloff
if pitch1 < maleThresholdPitch 
disp('First speaker is likely male.');
else
disp('First speaker is likely female.');
end

if pitch2 < maleThresholdPitch 
disp('Second speaker is likely male.');
else
disp('Second speaker is likely female.');
end

% Calculate the correlation coefficient between the two sound files
corrCoef = corr2(soundData1, soundData2);

% Calculate the variation between the two sound files
variation = var(soundData1 - soundData2);

% Plot the two sound files and their correlation
figure;
subplot(4,1,1);
plot(soundData1);
xlabel('Time (samples)');
ylabel('Amplitude');
title('First Sound File');
subplot(4,1,2);
plot(soundData2);
xlabel('Time (samples)');
ylabel('Amplitude');
title('Second Sound File');
subplot(4,1,3);
plot(xcorr(soundData1,soundData2));
xlabel('Lag (samples)');
ylabel('Correlation');
title(['Correlation Coefficient: ' num2str(corrCoef) ', Variation: ' num2str(variation)]);
subplot(4,1,4);
freqData1 = fftshift(abs(fft(soundData1)));
freqData2 = fftshift(abs(fft(soundData2)));
freqAxis = linspace(-fs1/2, fs1/2, length(soundData1));
plot(freqAxis, freqData1, 'b', freqAxis, freqData2, 'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum');
legend('First Sound File', 'Second Sound File');