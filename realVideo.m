function [vid] = realVideo()

% Define frame rate
NumberFrameDisplayPerSecond=10;
 
% Open figure
hFigure=figure(1);
 
% Set-up webcam video input
try
   % For windows
   vid = videoinput('winvideo', 1);
catch
   try
      % For macs.
      vid = videoinput('macvideo', 1);
   catch
      errordlg('No webcam available');
   end
end
 
% Set parameters for video
% Acquire only one frame each time
set(vid,'FramesPerTrigger',1);
% Go on forever until stopped
set(vid,'TriggerRepeat',Inf);
% Get a grayscale image
set(vid,'ReturnedColorSpace','grayscale');
triggerconfig(vid, 'Manual');
 
% set up timer object
TimerData=timer('TimerFcn', ...
    {@FrameRateDisplay,vid},'Period',1/NumberFrameDisplayPerSecond, ...
    'ExecutionMode','fixedRate','BusyMode','drop');
 
% Start video and timer object
start(vid);
start(TimerData);
 
% We go on until the figure is closed
uiwait(hFigure);
 
% Clean up everything
stop(TimerData);
delete(TimerData);
stop(vid);
delete(vid);
% clear persistent variables
% clear functions;


end

