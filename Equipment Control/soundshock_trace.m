function soundshock_trace(soundfrequency,soundduration)

% duration = 20;%seconds of the tone

tone = tonegenerator(soundfrequency,soundduration,8192);
% sound(tone);

%% make sound object, set parameters, put data in
ao = analogoutput('winsound', 0); %make sound output object
addchannel(ao, [1 2]);%add channels
outputfreq = 8192; %standard
set(ao, 'StandardSampleRates','Off')%set sample rate??
set(ao, 'SampleRate', outputfreq);
set(ao,'TimerFcn','@ComPortShock');
set(ao,'TimerPeriod',soundduration+1);

data = [tone' tone'];
putdata(ao, data);

%% start sound output
start(ao);
pause(soundduration/2);

%% wait til sound is done outputting (stopfcn doesn't work bc other stuff
%%% keeps running as soon as start sound output.
while strcmp('On',get(ao,'Running'))
    pause (.05);%wait in 50ms increments
end

%% after sound done, wait 1 sec then write to com to output shock
pause(1)

s = serial('COM1');
fopen(s);
fwrite(s,0);
fclose(s);