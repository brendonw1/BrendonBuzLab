function metadata = BuildMetadata(fbasename)
%loads file basics, builds some basic info onto the stucture which is
%initially in the XML/Par file

%% load xml file info and eeg file, save into .FileInfo
metadata.FileInfo = LoadPar([fbasename,'.par']);


[Data OrigIndex]= LoadBinary([fbasename,'.eeg'], 1); %loads a single channel of data
metadata.FileInfo.TotalSeconds = numel(Data)/metadata.FileInfo.lfpSampleRate;

%% load in cluster/spiking info
[spiket, spikeind, numclus, iEleClu, spikeph] = ReadEl4CCG2(fbasename);
metadata.Clusters.NumClusters = numclus;
metadata.Clusters.ShankIDs = iEleClu;
metadata.Clusters.AllSpikeTimes = spiket;
metadata.Clusters.AllSpikeIDs = spikeind;

for a = 1:numclus;
    metadata.Clusters.TotalSpikes(a) = sum(spikeind==a);
    metadata.Clusters.SpikeRates(a) = metadata.Clusters.TotalSpikes(a)/metadata.FileInfo.TotalSeconds;
    metadata.Clusters.SpikeTimes{a} = spiket(spikeind==a);
end






%% later call this from a pointer to a merge file... 
% this would have of course the merge file info
% basic stats on the individual files
% broken down/combined spikes etc