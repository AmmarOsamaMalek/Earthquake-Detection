function [gx,gy] = readAcc(out,calc)

    write(out.s,'S','uint8');

    readings(1) = read(out.s,1,'uint16');
    readings(2) = read(out.s,1,'uint16');
    offset = calc.offset;
    gain = calc.g;
    accel = (readings - offset) ./ gain;

    gx = accel(1);
    gy = accel(2);
end