function soundshock_traceprotocol(numexposures)

for a = 1:numexposures;
    soundshock_trace(4000,20)%sound params: first is freq, 2nd is duration
    if a<numexposures
        disp([num2str(a),' out of ',num2str(numexposures),' done'])
        pause (30)%30 sec between
    end
end