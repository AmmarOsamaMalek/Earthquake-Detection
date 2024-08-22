function calc = calibrate(s)

    out.s = s;
    calc.offset = 0;
    calc.g = 1;
    mbox = msgbox('Stand accelerometer on edge so that X arrow points up');uiwait(mbox);
    [gx_x,gy_x] = readAcc(out,calc);

    mbox = msgbox('Stand accelerometer on edge so that Y arrow points up');uiwait(mbox);
    [gx_y,gy_y] = readAcc(out,calc);

    
    offsetX =  gx_y;
    offsetY = gy_x;

    gainX = gx_x - offsetX;
    gainY = gy_y - offsetY;

    calc.offset = [offsetX offsetY];
    calc.g = [gainX gainY];

    mbox = msgbox('Sensor Calibration completed..');uiwait(mbox);
end