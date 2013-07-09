function extinction(soundfrequency,soundduration)

% duration = 20;%seconds of the tone

tone = tonegenerator(soundfrequency,soundduration,8192);
% sound(tone);

%% make sound object, set parameters, put data in
ao = analogoutput('winsound', 0); %make sound output object
addchannel(ao, [1 2]);%add channels
outputfreq = 8192; %standard
set(ao, 'StandardSampleRates','Off')%set sample rate??
set(ao, 'SampleRate', outputfreq);
% set(ao,'TimerFcn','@ComPortShock');
% set(ao,'TimerPeriod',soundduration-1);

data = [tone' tone'];
putdata(ao, data);

%% start sound output 
start(ao);


%% pause to replicate timing of shock protocol
pause(1)