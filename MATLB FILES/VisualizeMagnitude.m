
%% [1]- Specifies the COM PORT
comPort = 'COM3';

%% [2]- Initialize the Serial Port
if(~exist('flag','var'))
    [Accelerometer.s,flag] = setupSerial(comPort);
end

%% [3]- Calibrate Sensor
if(~exist('calc','var'))
    calc = calibrate(Accelerometer.s);
end

%% [4]- Open a new figure for real time data
if(~exist('h','var') || ~ishandle(h))
    h = figure(1);
    ax = axes('Box','on');
end

if(~exist('button','var'))
    button = uicontrol("Style","pushbutton","String",'stop','Position',[0 0 50 25],'Parent',h,'Callback','stop_magnitude','UserData',1);
end

if(~exist('button','var'))
    button = uicontrol("Style","pushbutton","String",'Close Serial Port','Position',[250 0 150 25],'Parent',h,'Callback','closeSerial','UserData',1);
end

%% [5]- Data collection and plotting
bufferLength = 100;
index = 1:bufferLength;
gxdata = zeros(bufferLength,1);
gxdataFiltered = zeros(bufferLength,1);
gydata = zeros(bufferLength,1);
gydataFiltered = zeros(bufferLength,1);
tapes = 3; %% filter coefficient
thresholdValue = 0.3;
isHightFlag = 0;
stepCount = 0;
while(get(button,'UserData'))
    [gx,gy] = readAcc(Accelerometer,calc);
    gxdata = [gxdata(2:end) ; gx];
    gxdataFiltered = [gxdataFiltered(2:end) ; mean(gxdata(bufferLength:-1:bufferLength-tapes+1))];
    gydata = [gydata(2:end) ; gy];
    gydataFiltered = [gydataFiltered(2:end) ; mean(gydata(bufferLength:-1:bufferLength-tapes+1))];
    if gxdataFiltered(end) > thresholdValue || gydataFiltered(end) > thresholdValue
        stepCount = stepCount + 1;
        %%isHightFlag = 1;
        write(Accelerometer.s,'E','uint8');
    end
    %%gxFilter = (1-alpha)*gxFilter + alpha*gx;
    %% Plot raw X acceleration Data
    %%subplot(2,1,1)
    %%plot(index,gxdata,'r');
    %%axis([1 bufferLength -3.5 3.5]);
    %%xlabel('time');
    %%ylabel('Magnitude of X axis Raw Data');
    %% Plot The Filtered X acceleration
    subplot(2,1,1)
    plot(index,gxdataFiltered,'b',index,thresholdValue*ones(bufferLength,1),'r--');
    axis([1 bufferLength -3.5 3.5]);
    xlabel('time');
    ylabel('Magnitude of X axis Filtered Data');
%% Plot The Filtered Y acceleration
    subplot(2,1,2)
    plot(index,gydataFiltered,'r',index,thresholdValue*ones(bufferLength,1),'b--');
    axis([1 bufferLength -3.5 3.5]);
    xlabel('time');
    ylabel('Magnitude of Y axis Filtered Data')

    drawnow;
end