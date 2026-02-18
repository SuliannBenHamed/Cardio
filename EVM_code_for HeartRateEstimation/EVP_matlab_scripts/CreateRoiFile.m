[VideoName, VideoPath]= uigetfile('*','SELECT A VIDEO'); %La video doit être mise dans EVM_MATLAB/data
[RoiName,RoiPath] = uiputfile('ROI.mat', 'CREATE A NEW ROI FILE');
SelectROI([VideoPath VideoName], [RoiPath RoiName]);