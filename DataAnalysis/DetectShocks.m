function shocks = DetectShocks(FileBase, Channel)

% Detects delivered shocks (ie from Coulbourn conditioning cage) based on 
% simple criteria looking for a flat square wave of a certain duration and time
% Input FileName is a filename
% Output shocks is a 2 column array, first column is start time of each event, 2nd column is stop time
% output is in units of seconds


Par = LoadPar([FileBase '.xml']);

if isfield(Par,'lfpSampleRate')
    eSampleRate = Par.lfpSampleRate;%this is in samples per second, not the downsample/conversion rate but the end rate of the eeg file
else
    eSampleRate = 1250;%ditto
end

eeg=LoadBinary([FileBase,'.eeg'],Channel);

%for 1 sec event, will have min/max be 750/1500ms
mindur = .75*eSampleRate;
maxdur = 1.5*eSampleRate;
thresh = 20000; %based on 2012-01-06_12-24-15

shocks = continuousabove(eeg,0,20000,mindur,maxdur);
shocks = shocks/eSampleRate;%output in seconds