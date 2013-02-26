function events = DetectEventsUsingDat(FileBase, Channels)

% A framework to detect events from huge dat files that are too big to load
% into RAM.  Basically grabs chunks at a time and does detection on each
% bit, then looks for chunks that should be concatenated together.  
% Top part taken from LoadBinary.m (Anton) and some doc from that is below.
% FileName = name of dat file to load
% Channels = the channel to use to detect on (note counting starts at 1,
% neuroscope starts with 0)
% 
% Threshold



%   Channels - list of channels to load starting from 1
%   nChannels - number of channels in a file, will be read from par/xml file
% if present
%   intype/outtype - data types in the file and in the matrix to load to
% by default assume input file is eeg/dat = int16 type (short int), and
% output is single (to save space) unless it is version 6.5 that cannot
% handle single type
%   method: (1,2,  3 or 4) differes by the way the loading is done - just for
% efficiency purposes some are better then others, default =2;
% method 2 works with buffers-works even for huge files. other methods
% don't work so far ..
% NB: method =3 allows to load data from within certain time epochs , give
% in variable Periods : [beg1 end1; beg2 end2....] (in sampling rate of the
% file you are loading, so if you are loading eeg - then Periods should be
% in eeg samples
% OrigIndex then returns the original samples index that samples in Data correspond
% to , so that you can use it for future spikes and other point process
% analysis
% NB: for method 4 for efficiency and historical reasons output is nCh x nT 
% complaints to : Anton


% if ~FileExists(FileName)
%     error('File %s does not exist or cannot be open\n',FileName);
% end
% 
% lastdot =strfind(FileName,'.');
% FileBase=FileName(1:lastdot(end)-1);
if FileExists([FileBase '.xml']) || FileExists([FileBase '.par'])
    Par = LoadPar([FileBase]);
    nChannels = Par.nChannels;
else
    nChannels = 0;
end
FileName = [FileBase,'.dat'];
[nChannels, method, intype, outtype, Resample] = DefaultArgs([],{nChannels,2,'int16','double',1});

if ~nChannels error('nChannels is not specified and par/xml file is not present'); end

ver = version; ver = str2num(ver(1));
if ver<7 outtype ='double';end

PrecString =[intype '=>' outtype];
fileinfo = dir(FileName);
% get file size, and calculate the number of samples per channel
nSamples = ceil(fileinfo(1).bytes /datatypesize(intype) / nChannels);

%have not fixed the case of method 1 for periods extraction
filept = fopen(FileName,'r');
% data = feval(outtype,zeros(length(Channels), nSamples));

% OrigIndex = [];
Periods = [1 nSamples];
nPeriods = size(Periods,1);
buffersize = 400000;
% totel=0;
events = [0 0];
thresh = 10000;
% for ii=1:nPeriods
ii = 1;
numel=0;
numelm=0;
Position = (Periods(ii,1)-1)*nChannels*datatypesize(intype);
ReadSamples = diff(Periods(ii,:))+1;
fseek(filept, Position, 'bof');
while numel<ReadSamples 
    if numel==ReadSamples break; end
    [temp,count] = fread(filept,[nChannels,min(buffersize,ReadSamples-numel)],PrecString);
    temp = temp(Channels,1:Resample:end);

%%%%%% this is where the detector comes in... could turn this into an "eval"
    temp = conv(abs(temp),ones(1,5));%smooth the data
    ft = find(temp>thresh);
    if ~isempty(ft)
       cotemp = continuousabove(temp,0,thresh,Par.SampleRate*2,inf);
       if ~isempty(cotemp)
           events(end+1:end+size(cotemp,1),:) = cotemp+numel;
       end
    end
    numel = numel+count/nChannels;
%         totel = totel+ceil(count/nChannels/Resample);
end

if size(events,1)>1;%if more than one potential event detected
        e2=events(:,2);%take ends of all event
        b2=events(:,1);%filt(ends(good))-(lengths(good)-1)';%take all beginnings
        e2(end)=[];%prepare for comparison
        b2(1)=[];%ditto
        between=b2-e2;%subtract beginning of each event from end of last
        for j=length(between):-1:1;%for each difference
%             bet2=filt(e2(j):b2(j));%find portion of convolved reading between the depolarized areas
            if between(j)<10;%for periods less than 10 apart
%                 trash=find(bet2<1);%is there any area that dips below 1mV above baseline?
%                 if isempty(trash);%if not...
                    events(j,2)=events(j+1,2);%make end of the first event now equal to the end of the 2nd... 1 big upstate
                    events(j+1,:)=[];%eliminate record of 2nd event
%                 end
            end
        end
end

events = events/Par.SampleRate;

%     OrigIndex = [OrigIndex; Periods(ii,1)+[0:Resample:ReadSamples-1]'];
% end

% if method<4
%     fclose(filept);
% end


