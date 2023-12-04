function varargout = CP_GUI(varargin)

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @CP_GUI_OpeningFcn, ...
                   'gui_OutputFcn',  @CP_GUI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before CP_GUI is made visible.
function CP_GUI_OpeningFcn(hObject, eventdata, handles, varargin)

% Choose default command line output for CP_GUI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% --- Outputs from this function are returned to the command line.
function varargout = CP_GUI_OutputFcn(hObject, eventdata, handles) 

% Get default command line output from handles structure
varargout{1} = handles.output;


% --- Executes on button press in Source1.
function Source1_Callback(hObject, eventdata, handles)

% Use uigetfile to allow the user to select a .wav file
[filename, pathname] = uigetfile({'*.wav','Select the .wav File'});
if isequal(filename,0)
    % User clicked the "Cancel" button
    return;
end

% Store the full path to the selected file in a global variable
global filepath;
filepath = fullfile(pathname, filename);

% Update the GUI to display the selected file path
set(handles.edit4, 'String', 'File is Added Successfully.');


% --- Executes on button press in Source2.
function Source2_Callback(hObject, eventdata, handles)

% Use uigetfile to allow the user to select a .wav file
[filename1, pathname1] = uigetfile({'*.wav','Select the .wav File'});
if isequal(filename1,0)
    % User clicked the "Cancel" button
    return;
end

% Store the full path to the selected file in a global variable
global filepath1;
filepath1 = fullfile(pathname1, filename1);

% Update the GUI to display the selected file path
set(handles.edit5, 'String', 'File is Added Successfully.');

% --- Executes during object creation, after setting all properties.
function edit1_CreateFcn(hObject, eventdata, handles)
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in Plot1.
function Plot1_Callback(hObject, eventdata, handles)

% Load the audio data from the selected file
global filepath;
[soundData1, fs1] = audioread(filepath);

% Plot the audio data
t = (0:length(soundData1)-1)/fs1;
plot(handles.axes1, t, soundData1);
xlabel(handles.axes1, 'Time (s)');
ylabel(handles.axes1, 'Amplitude');
title(handles.axes1, 'Audio Data Plot');


% --- Executes on button press in Plot2.
function Plot2_Callback(hObject, eventdata, handles)

% Load the audio data from the selected file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

% Plot the audio data
t = (0:length(soundData2)-1)/fs2;
plot(handles.axes1, t, soundData2);
xlabel(handles.axes1, 'Time (s)');
ylabel(handles.axes1, 'Amplitude');
title(handles.axes1, 'Audio Data Plot');

% --- Executes on button press in Gender_Predict.
function Gender_Predict_Callback(hObject, eventdata, handles)

% Load the First sound file
global filepath;
[soundData1, fs1] = audioread(filepath);

% Load the second sound file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

% Check if both files have the same sampling rate
if fs1 ~= fs2
error('Both sound files should have the same sampling rate.');
end

% Check if both files have the same duration
if size(soundData1,1) ~= size(soundData2,1)
error('Both sound files should have the same duration.');
end

% Define the threshold pitch value to distinguish between male and female voices
maleThresholdPitch = 120; % Hz
femaleThresholdPitch = 205; % Hz


% Calculate the pitch using the autocorrelation method

% Load the First sound file
global filepath;
[soundData1, fs1] = audioread(filepath);
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


% Load the second sound file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

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

% Make a guess at the gender based on the pitch 
if pitch1 < maleThresholdPitch 
set(handles.Prediction1, 'String', 'First speaker is likely male.'); 
else
set(handles.Prediction1, 'String', 'First speaker is likely female.'); 
end

if pitch2 < maleThresholdPitch 
set(handles.Prediction2, 'String', 'Second speaker is likely male.');
else
set(handles.Prediction2, 'String', 'Second speaker is likely female.'); 
end

% --- Executes on button press in Correlation.
function Correlation_Callback(hObject, eventdata, handles)

% Load the First sound file
global filepath;
[soundData1, fs1] = audioread(filepath);

% Load the second sound file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

% Calculate the correlation coefficient between the two sound files
corrCoef = corr2(soundData1, soundData2);

% Calculate the variation between the two sound files
variation = var(soundData1 - soundData2);

axes(handles.axes1);
plot(xcorr(soundData1,soundData2));
xlabel('Lag (samples)');
ylabel('Correlation');
title(['Correlation Coefficient: ' num2str(corrCoef) ', Variation: ' num2str(variation)]);

% --- Executes on button press in Freq_Spectrum.
function Freq_Spectrum_Callback(hObject, eventdata, handles)

% Load the first sound file
global filepath;
[soundData1, fs1] = audioread(filepath);

% Load the second sound file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

freqData1 = fftshift(abs(fft(soundData1)));
freqData2 = fftshift(abs(fft(soundData2)));
freqAxis = linspace(-fs1/2, fs1/2, length(soundData1));

axes(handles.axes1);
plot(freqAxis, freqData1, 'b', freqAxis, freqData2, 'r');
xlabel('Frequency (Hz)');
ylabel('Magnitude');
title('Frequency Spectrum');
legend('First Sound File', 'Second Sound File');


% --- Executes on button press in ALL_PLOT.
function ALL_PLOT_Callback(hObject, eventdata, handles)

% Load the First sound file
global filepath;
[soundData1, fs1] = audioread(filepath);

% Load the second sound file
global filepath1;
[soundData2, fs2] = audioread(filepath1);

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

% Calculate the correlation coefficient between the two sound files
corrCoef = corr2(soundData1, soundData2);

% Calculate the variation between the two sound files
variation = var(soundData1 - soundData2);

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


% --- Executes during object creation, after setting all properties.
function edit4_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function edit5_CreateFcn(hObject, eventdata, handles)

if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end

% --- Executes during object creation, after setting all properties.
function Prediction1_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function Prediction2_CreateFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function Prediction1_DeleteFcn(hObject, eventdata, handles)
% --- Executes during object creation, after setting all properties.
function Prediction2_DeleteFcn(hObject, eventdata, handles)
