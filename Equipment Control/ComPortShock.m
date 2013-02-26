function 
disp('output now')
s = serial('COM1');
fopen(s);
fwrite(s,0);
fclose(s);
