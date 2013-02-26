function extinctionprotocol(numexposures)

for a = 1:numexposures;
    extinction(4000,20)%sound params: first is freq, 2nd is duration
    if a<numexposures
        disp([num2str(a),' out of ',num2str(numexposures)])
        pause (30)%30 sec between
    else
        disp([num2str(a),' out of ',num2str(numexposures)])
    end
end