%% Rec + Real Time Plot
close all; clear all; clc

% This section starts a new recording with the duration specified
% If you run the whole script, it will go through the full process
% of applying effects and playing back the transformed audio clip
% (See the next Section if you are just starting here)

% generate a default name with current timestamp
fileName = regexprep(strcat(datestr(now),'.mat'), ' |:|-', '_');
durationSecs = 30;

Fs = 22050; 
[audioObj, y] = realTimeAudio(durationSecs,Fs); 

% Save audio object and its audio data
rawGtr = struct('obj',audioObj,'data',y); 
save(fileName, 'rawGtr')


%% Post-Proc. 

% Start here if it's your first time using the script. 
% Run it with the example file to see it in action
% compare the "original" and "processed" output .wav files

fileName = 'example_track.mat'; % example file (comment this line when you're ready to work on your own recording)
 
clear sound; close all; clc

play = true; % play processed file at the end?

%%%%%%%%%%%%%%%%%%%%%%%%
%EFFECTS CHAIN SELECTION
flanger = 1; 
wah = 0; 
overdrive = 0;
%%%%%%%%%%%%%%%%%%%%%%%%

load(fileName); 
d = rawGtr.data;

%Apply effects
if(overdrive)
    d = ovd(0.9,d);
end
if(flanger)
    d = flange(rawGtr.obj.SampleRate,0.002,d,0.25);
end 
if(wah)
    d = wwp(d, rawGtr.obj.SampleRate,rawGtr.obj.TotalSamples);
end

% Make plots and write files
durationSecs = rawGtr.obj.TotalSamples/rawGtr.obj.SampleRate;
hold on
subplot(2,1,1)
    plot(linspace(1,durationSecs,length(rawGtr.data)), rawGtr.data,'r')
    title('Raw audio')
    xlabel('t [sg.]')
    ylabel('Amplitude')
subplot(2,1,2)    
    plot(linspace(1,durationSecs,length(d)), d,'g')
    title('With Effects') 
    xlabel('t [sg.]')
    ylabel('Amplitude')

if(play)    
    sound(d,rawGtr.obj.SampleRate,16);  
end

audiowrite(strcat(fileName,'_original.wav'),rawGtr.data,rawGtr.obj.SampleRate)
audiowrite(strcat(fileName,'_processed.wav'),d,rawGtr.obj.SampleRate)