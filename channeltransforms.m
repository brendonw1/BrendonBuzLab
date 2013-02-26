%USE PIN NUMBERS ONLY  (? then use that to create elegant transforms?),
%channel numbers based on numbering from plexon preamp numbering.  
%then plug in actual channel numbers

%64 CHANNEL NEURONEXUS H64 PACKAGE PROBE
% the probe sites are numbered by neuronexus 1-64 in a reasonable way
spationumericsequenceonprobe = 1:64;
%this next signifies what was 1 becomes 17 etc, note this is degenerate,
%64 input channels go to 72 output channels
probesitestoprobepins = [17 35 16 34 15 33 14 32 13 31 12 30 11 29 10 28 ...
    63 62 61 59 58 57 38 39 40 42 43 44 45 41 56 60 ... %16 on each line here: 17-32
    67 71 50 46 47 48 49 51 52 53 70 69 68 66 65 64 ... %33-48
    27 9 26 8 25 7 24 6 23 5 22 4 21 3 20 2]; %49-64

%PLEXON TRANSFORM - NUMBERING IS ONLY AT THE LEVEL OF PLEXON, THIS IS AN
%INDEPENDENT TRANSFORM FROM THE ABOVE
%yet more degeneracy at the level of the plexon, 72 channels become 80.
%note the first 2 rows are one transform and the second 2 rows are
%repeated, but with the addition of 40 to the output channel numbers.

plexonoutputchannels = 1:72;
% %NOTE... only including data channels, not ground or ref below
% plexoninputtooutputtransform = [23 24 25 26 27 28 29 30 12 13 14 15 16 17 18 19 ... %inputs 1-18
%     3 4 5 6 7 8 9 10 31 32 33 34 35 36 37 38  ... %19-36
%     63 64 65 66 67 68 69 70 52 53 54 55 56 57 58 59  ... %37-54
%     43 44 45 46 47 48 49 50 71 72 73 74 75 76 77 78]; %55-72

%BELOW Includes ground and ref channels
plexoninputtooutputtransform = [22 23 24 25 26 27 28 29 30 12 13 14 15 16 17 18 19 21 ... %inputs 1-18
    1 3 4 5 6 7 8 9 10 31 32 33 34 35 36 37 38 39 ... %19-36
    62 63 64 65 66 67 68 69 70 52 53 54 55 56 57 58 59 61  ... %37-54
    41 43 44 45 46 47 48 49 50 71 72 73 74 75 76 77 78 79]; %55-72

plexonoutputchannelassignments = [0 0 1 2 3 4 5 6 7 8 0 25 26 27 28 29 30 31 32 0 0 ... %
    0 17 18 19 20 21 22 23 24 9 10 11 12 13 14 15 16 0 0 ... 
    0 0 41 42 43 44 45 46 47 48 0 65 66 67 68 69 70 71 72 0 0 ...
    0 57 58 59 60 61 62 63 64 49 50 51 52 53 54 55 56 0 0];    


probesitesgoingtochannels = ...
    plexonoutputchannelassignments(plexoninputtooutputtransform(probesitestoprobepins))

% %TRANSFORM OVER MY CABLE FROM PLEXON PRE-AMP TO NEURALYNX CHANNELS
% %degenerate from 40 channels to 50.  This again includes in this case 2
% %separate cables, so the second two rows are simply the first two +50 to
% %each digit
% 
% neuralynxoutputchannels = 1:100;
% %NOTE... only including data channels, not ground or ref or power below
% neuralynxcabletransform = [2 3 4 5 10 11 12 13 20 21 22 23 45 46 47 48 ... %1-21 due to layout of plexon
%     35 36 37 38 39 40 41 42 14 15 16 17 28 29 30 31 ... %22-40
%     52 53 54 55 60 61 62 63 70 71 72 73 95 96 97 98 ... %41-61
%     85 86 87 88 89 90 91 92 64 65 66 67 78 79 80 81]; %62-80
% %BELOW Includes ground, ref and power channels
% % neuralynxcabletransform = [34 1 2 3 4 5 10 11 12 13 49 20 21 22 23 45 46 47 48 50 43 ... %1-21 due to layout of plexon
% %     44 35 36 37 38 39 40 41 42 14 15 16 17 28 29 30 31 27 26 ... %22-40
% %     84 51 52 53 54 55 60 61 62 63 99 70 71 72 73 95 96 97 98 100 93 ... %41-61
% %     94 85 86 87 88 89 90 91 92 64 65 66 67 78 79 80 81 77 76]; %62-80



% channelsequenceonprobe = 1:64;
% 
% transformtoconnector1 = [64 62 60 58 56 54 52 50 15 13 11 9 7 5 3 1 ...
%     63 61 59 57 55 53 51 49 16 14 12 10 8 6 4 2 ...
%     23 24 25 30 26 27 28 29 36 37 38 39 35 40 41 42 ...
%     31 22 21 20 32 19 18 17 48 47 46 33 45 44 43 34];
% 
% connector1pinnumbers = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 ...
%     20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 ...
%     38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 ...
%     56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71];
% 
% lengthconnector1 = 72;
% 
% % transformtoconnector1 = [1 64 62 60 58 56 54 52 50 15 13 11 9 7 5 3 1 1 ...
% %     1 63 61 59 57 55 53 51 49 16 14 12 10 8 6 4 2 1 ...
% %     1 23 24 25 30 26 27 28 29 36 37 38 39 35 40 41 42 1 ...
% %     1 31 22 21 20 32 19 18 17 48 47 46 33 45 44 43 34 1];
% 
% channelsequenceoutofconnector1 = zeros(1,lengthconnector1);
% for a = 1:length(transformtoconnector1);
%     channelsequenceoutofconnector1(connector1pinnumbers(a)) = transformtoconnector1(a);
% end
% 
% 
% transformtoconnector2 = [17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 ...
%     1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 ...
%     49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 ...
%     33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48];
% 
% connector2pinnumbers = [2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 ...
%     20 21 22 23 24 25 26 27 28 29 30 31 32 33 34 35 ...
%     38 39 40 41 42 43 44 45 46 47 48 49 50 51 52 53 ...
%     56 57 58 59 60 61 62 63 64 65 66 67 68 69 70 71];
% 
% lengthconnector2 = 72;
% 
% % transformtoconnector2 = [1 17 18 19 20 21 22 23 24 25 26 27 28 29 30 31 32 1 ...
% %     1 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 1 ...
% %     1 49 50 51 52 53 54 55 56 57 58 59 60 61 62 63 64 1 ...
% %     1 33 34 35 36 37 38 39 40 41 42 43 44 45 46 47 48 1];
% 
% channelsequenceoutofconnector2 = zeros(1,lengthconnector2);
% for a = 1:length(transformtoconnector2);
%     channelsequenceoutofconnector2(connector2pinnumbers(a)) = channelsequenceoutofconnector1(connector2pinnumbers(a));
% end
% 
% transformtoconnector3 = [1 1 20 21 22 23 24 25 26 27 1 10 11 12 13 14 15 16 17 1 1 ...
%     1 2 3 4 5 6 7 8 9 28 29 30 31 32 33 34 35 1 1 ...
%     1 1 56 57 58 59 60 61 62 63 1 46 47 48 49 50 51 52 53 1 1 ...
%     1 38 39 40 41 42 43 44 45 64 65 66 67 68 69 70 71 1 1];
% 
% connector1pinnumber
% 
% % transformtoconnector3 = [1 1 20 21 22 23 24 25 26 27 1 10 11 12 13 14 15 16 17 1 1 ...
% %     1 2 3 4 5 6 7 8 9 28 29 30 31 32 33 34 35 1 1 ...
% %     1 1 56 57 58 59 60 61 62 63 1 46 47 48 49 50 51 52 53 1 1 ...
% %     1 38 39 40 41 42 43 44 45 64 65 66 67 68 69 70 71 1 1];
% 
% channelsequenceoutofconnector3 = transformtoconnector3(channelsequenceoutofconnector2);
% 
% transformtoconnector4 = [1  