function [spectra,f,s,meanresampledspectra] = StateSpectra (basename,statenumber,varargin)
% Creates single spectra for epochs of data designated as a particular
% state in "StateEditor", plots the spectrum for each epoch and then
% resamples each spectrum to be along a consistent set of frequency points
% then takes their mean and plots that.  Outputs all spectra and the mean
% spectrum.  By default downsamples the eeg file 1:5 and then runs spectral
% analysis with [50 99] tapers.
%   For spectrum calc uses MTSpectrum from Michael Zugaro's FMAToolbox
% (MTSpectrum is a wrapper for mtspectrumc from Partha Mitra's Chronux
% toolbox
% INPUTS
% >>Requires you be in the folder containing a basename-states.mat file and
% basename.eeg file
% - basename: the base filename of the data you're using, should be same for
% .eeg and -states.mat
% - statenumber: number 1-5 corresponding to the state from StateEditor you
% want to grab every epoch of for spectral analysis
% - (optional) acqsystem - lets you specify neuralynx or amplirec
% OUTPUTS
% - spectra: 1 by numberofepochs cell array of frequency powers (dependent variable)
% - f: 1 by numberofepochs cell array of frequencies sampled for each epoch
% (indep variable)
% - s: 1 by numberofepochs cell array of errors, see MTSpectrum for info
% - meanresampledspectra: frequencies x 2 vector: row 1 is frequencies 
% sampled, row 2 is spectral values at each point (default spectrum is
% 0-125Hz)
%
% Brendon Watson 2013

switch statenumber %make 
    case 1
        statename = 'Waking';
    case 2
        statename = 'Freezing';
    case 3
        statename = 'NREM Sleep';
    case 4
        statename = 'Intermediate Sleep';
    case 5
        statename = 'REM Sleep';
end

load([basename,'-states.mat']);%'states' will be an imported variable

[StateInds,StateBounds] = ExtractStateBounds(states,statenumber,2);%get indices of where states start and stop, states must be longer than 2sec

if ~isempty(varargin);
    acqsystem = varargin{1};
else
    acqsystem = 'amplirec';%default
end%

switch acqsystem %if aquired by with amplirec, eeg sample rate is 1250
    case 'amplirec'
        eegfreq = 1250;
    case 'neuralynx' %if aquired by neuralynx, eeg sample rate is 1252
        eegfreq = 1252;
    otherwise
        error 'unrecognized name given for acquisition system'
end

StateInds = StateInds*1250/eegfreq; %compensating in case acquired by neuralynx
StateBounds = StateBounds*1250/eegfreq;

for a = 1:size(StateBounds,1)
    data{a} = LoadBinary([basename,'.eeg'],14,[],[],[],[],round(eegfreq*StateBounds(a,:)),[]);
end

resamplefrequencypoints = [0:.2:125];%points at which data will be interpolated and resampled for the last averaging step
freqrange = [min(resamplefrequencypoints) max(resamplefrequencypoints)];
sumresampledspectra = zeros(length(resamplefrequencypoints),1);%presetting a matrix for later averaging
for a = 1:length(data)
%     [spectra{a},f,s] = MTSpectrum(data{a}','frequency',1252/5,'tapers',[20 39],'show','on');
    resampleddata{a} = resample(data{a},1,5);
    [spectra{a},f{a},s{a}] = MTSpectrum(resampleddata{a}','frequency',eegfreq/5,'tapers',[50 99],'show','on');
    title([basename,' ',statename, ' epoch ',num2str(a),' spectrum']); 
    xlim(freqrange)
    spectraobj{a} = timeseries(spectra{a},f{a},'name','1');%make it into a timeseries object to run a particular kind of interpolation fcn
    resampledspectra{a} = resample(spectraobj{a},resamplefrequencypoints);%for now resampled spectra is not output as a variable
    sumresampledspectra = sumresampledspectra+resampledspectra{a}.Data;
end

meanresampledspectra = sumresampledspectra/a;%averaging
meanresampledspectra = cat(1,resamplefrequencypoints,meanresampledspectra');%outputting the frequences sampled and the values at each freq
figure;plot(resamplefrequencypoints,log(meanresampledspectra(2,:)));title([basename,' ',statename,' mean spectrum']);%plotting
xlim(freqrange)
