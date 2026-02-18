function [X, Y] = Load2Dcsv(FileName)
% 'SELECT A ' Name ' ".csv" FILE'

[Name, Path] = uigetfile('*',FileName);

csv = uiimport([Path Name]);
csv = struct2array(csv);
X = csv(:,1);
Y = csv(:,2);
