% getNearFieldGrid(dataX, dataY)
%
% Generates a PlanarGrid object based on the provided near-field data
% points in x and y coordinates.
%
% Input arguments:
%   dataX - Near-field data points in x-coordinate, where each row
%           represents a single measurement with format [x_position_mm,
%           y_position_mm, real_part, imaginary_part].
%   dataY - Near-field data points in y-coordinate, with the same format
%           as dataX.
%
% Output:
%   grid - Instance of the PlanarGrid class, which represents the scanning
%          grid parameters based on the provided data points.
%
% Details:
%   This function extracts unique x and y coordinates from the input dataX
%   and uses them to determine the number of sampling points (pointX and
%   pointY) in the respective dimensions. It calculates the dimensions
%   (lengthX and lengthY) of the scanning plane based on the range of x and
%   y coordinates in dataX. It then creates a PlanarGrid object with these
%   parameters.
%
% Example:
%   dataX = [x1_mm, y1_mm, real1, imag1;  % Near-field data points in x-coordinate
%            x2_mm, y2_mm, real2, imag2;
%            ...];
%   dataY = [x1_mm, y1_mm, real1, imag1;  % Near-field data points in y-coordinate
%            x2_mm, y2_mm, real2, imag2;
%            ...];
%   grid = getNearFieldGrid(dataX, dataY);  % Generate PlanarGrid object
%
% See also: PlanarGrid


function grid = getNearFieldGrid(dataX, dataY)
    % find set of coordinate of sampling points in x- and y-coordinate
    x_ = unique(dataX(:,1));
    y_ = unique(dataX(:,2));
    
    % find number of sampling points in each coordinate
    pointX = length(x_);
    pointY = length(y_);
    
    % find dimensions of the scanning plane
    lengthX = (pointX + 1) / (pointX) * (max(x_) - min(x_)) / 1000;
    lengthY = (pointY + 1) / (pointY) * (max(y_) - min(y_)) / 1000;
    
    grid = PlanarGrid(pointX, pointY, lengthX, lengthY);
end