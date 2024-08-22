function accelerometer_data()
try
 bt = bluetooth("HC-05",1);
    %set-up graph
h = animatedline;
% set axis using get current axis(gca)
ax = gca;
% set x-axis label
xlabel('Time(sec)');
% set x-axis label
ylabel('Disp(x)');
% set title for graph
title('Accelerometer Dispalcement Graph');
% set y-axis limit from 0 to 5.2V
ax.YLim = [0 1024];
% turn on grid
grid on;

% set start time
startTime = datetime('now');
i = zeros;
while i<1000
    % Read Displacment value
    x = read(bt,i);   
    % Get current time
    t =  datetime('now') - startTime;
    % Add points to animation
    addpoints(h,datetime(t),x);
    % Update X-axis limit
    ax.XLim = datetime([t-seconds(10) t]);
    datetick('x','keeplimits');
    drawnow limitrate;
    i = i+1;
end
catch
    clear;
    close;
end
