function tone = tonegenerator(soundfrequency,duration,varargin)
%% Generates a tone of a specified frequency and duration based on the
%% sound card sampling rate (sampfreq, default should be 8192)

if isempty(varargin);
    sampfreq = 8192;
else
    sampfreq = varargin{1};
end

samplespercycle = ceil(sampfreq/soundfrequency);%figuring out how many points per cycle... rounded up
singlecycle = sin(-pi:(2*pi/(samplespercycle)):pi);%making a single cycle of the right number of points to get the frequency we want
singlecycle = singlecycle(1:end-1);
tone = repmat(singlecycle,1,(soundfrequency*duration+1)); %making cyclical output vector with repeating cycles
tone = tone/pi;%normalizing

tone = tone(1:(sampfreq*duration)); %keeping only the number of points to give the exactly specified duration