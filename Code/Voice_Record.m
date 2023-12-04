% Set the audio recording parameters
fs = 44100; % Sample rate (Hz)
duration = 5; % Duration of recording (s)

% Create an audio recorder object
recObj = audiorecorder(fs,16,1);

% Start recording
disp('Start recording...');
recordblocking(recObj, duration);

% Play back the recording
disp('Playing back recording...');
play(recObj);

% Get the recorded audio data
soundData = getaudiodata(recObj);

% Save the recorded sound to a file
filename = 'swapnil_sound.wav';
audiowrite(filename, soundData, fs);

% Plot the recorded sound waveform
figure;
plot(soundData);
xlabel('Time (seconds)');
ylabel('Amplitude');
title('Recorded Sound');
