function soundshockprotocol(numexposures)

for a = 1:numexposures;
    soundshock(4000,20)%sound params
    if a<numexposures
        pause (40)%30 sec between
    end
end