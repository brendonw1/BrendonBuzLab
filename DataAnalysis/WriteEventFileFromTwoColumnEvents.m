function WriteEventFileFromTwoColumnEvents (events,outputname)
% Makes a neuroscope-compatible event file (.evt) signifying start and stop
% times for events given as a two-column input matrix where column 1 is
% starttime for each event and column 2 is the stoptime of that event.  The
% output is as follows
% timestampforevent1start 'on'
% timestampforevent1stop  'off'
% timestampforevent2start 'on'
% etc...


ev = events';
ev = ev(1:end)';
for a = 1:length(ev);
    outputcell{a,1} = ev(a);
    if mod (a,2)==1;
        outputcell{a,2} = 'on';
    elseif mod(a,2)==0;
        outputcell{a,2} = 'off';
    end
    
end


[nrows,ncols]= size(outputcell);
filename = [outputname,'.evt'];
fid = fopen(filename, 'w');
for row=1:nrows
    fprintf(fid, '%d %s\n', outputcell{row,:});
end
fclose(fid);