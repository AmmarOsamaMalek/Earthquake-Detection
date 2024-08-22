function [s,flag] = setupSerial(comPort)


flag = 1;

s = serialport(comPort,9600);
set(s,'Timeout',60);
c = 'b';
while (c ~= 'c')
    c = read(s,1,'uint8');
end
if(c == 'c')
    disp('serial read');
write(s,'v','uint8');
mbox = msgbox('Serial Communication setup. ');uiwait(mbox);
end
end