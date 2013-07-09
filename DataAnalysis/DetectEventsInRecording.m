function allevents = DetectEventsInRecording(FileBase)

% Runs a series of scripts to extract basic events from a file - shocks 
% via a recording of shocker command, movements from a movement pad, tones
% from a tone command (?recording also?).  All outputs should be in
% seconds, not timepoints

%% get the basic file parameters etc

lastdot =strfind(FileBase,'.');
if ~isempty(lastdot)
    FileBase=FileName(1:lastdot(end)-1);
end

% if ~FileExists(FileBase)
%     error('File %s does not exist or cannot be open\n',FileBase);
% end



%% at some point may want to make efficient and just get the eeg and par files once and pass them into the fcns... no time now

% if FileExists([FileBase '.xml']) || FileExists([FileBase '.par'])
%     Par = LoadPar([FileBase]);
%     nChannels = Par.nChannels;
% else
%     nChannels = 0;
% end
% % [nChannels, method, intype, outtype, Resample] = DefaultArgs([],{nChannels,2,'int16','double',1});

% %% now get the eeg file
% if FileExists([FileBase '.eeg'])
%     try 
%         Eeg = LoadBinary([FileBase '.eeg'], Channels,Par.nChannels,4)';
%     catch
%         Eeg = LoadBinary([FileBase '.eeg'], Channels,Par.nChannels,2)';
%     end
% elseif FileExists([FileBase '.eeg.0'])
%     Eeg = bload([FileBase '.eeg.0'],[1 inf]); 
% else
%     error('no eeg file or eeg.0 file! \n');
% end

%% Get the channel numbers we'll need
boxtitle = 'Enter Channels (First is 1)';
prompt = {'Enter channel num for shock command:',...
'Enter channel num for movement pad:',...};
'Enter channel num for sound command:'};
answer = inputdlg(prompt,boxtitle);

shockchannel = str2num(answer{1});
movementchannel = str2num(answer{2});
tonechannel = str2num(answer{3});

%% Get shock times

%get channel for shock
shocks = DetectShocks(FileBase, shockchannel);

%% Get movement times based on the motion pad

%get channel for movement
movementtimes = DetectPadMovement (FileBase, movementchannel);

%% Get tone-on times
tones = DetectEventsUsingDat(FileBase, tonechannel);

%% Output
allevents.shocks = shocks;
allevents.movementtimes = movementtimes;
allevents.tones = tones;