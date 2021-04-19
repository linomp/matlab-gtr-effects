function [audioObj,y] = realTimeAudio(durationSecs,Fs)
% add an extra half-second so that we get the full duration in our
% processing
durationSecs = durationSecs + 0.5;

% index of the last sample obtained from our recording
lastSampleIdx = 0;

% start time of the recording
atTimSecs     = 0;

% create the audio recorder
audioObj = audiorecorder(Fs,16,1);

% assign a timer function to the recorder
set(audioObj,'TimerPeriod',1e-2,'TimerFcn',@audioTimerCallback);

% create a figure with two subplots
%hFig   = figure;
%hAxes1 = subplot(1,1,1); 

% create the graphics handles to the data that will be plotted on each
% axes
hPlot1 = plot(gca,NaN,NaN); 
axis([0 durationSecs -1 1])
drawnow 
% start the recording
recordblocking(audioObj,durationSecs);
disp('Recording Finished')

% define the timer callback
    function audioTimerCallback(hObject,eventdata) 
        %play(audioObj);
        
        % get the sample data
        samples  = getaudiodata(hObject);

        % skip if not enough data
        if length(samples)<lastSampleIdx+1+Fs
            return;
        end

        % extract the samples that we have not performed an FFT on
        X = samples(lastSampleIdx+1:lastSampleIdx+Fs); 

        % plot the data
        t = linspace(0,1-1/Fs,Fs) + atTimSecs;
        %t = linspace(0,1-1/Fs+atTimSecs,Fs); 
        %set(hPlot1,'XData',t,'YData',X);
        hold on
        plot(t,X)
        drawnow
        
        % increment the last sample index
        lastSampleIdx = lastSampleIdx + Fs;

        % increment the time in seconds "counter"
        atTimSecs     = atTimSecs + 1; 
        
        y = samples;
    end

end

