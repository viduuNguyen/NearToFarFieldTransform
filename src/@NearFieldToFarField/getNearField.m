% getNearField(grid, data)
%
% Constructs a near-field matrix from given data points and a PlanarGrid
% specification.
%
% Input arguments:
%   grid - Instance of the PlanarGrid class defining the scanning grid
%          parameters.
%   data - Near-field data points, where each row represents a single
%          measurement with format [x_position_mm, y_position_mm,
%          real_part, imaginary_part].
%
% Output:
%   field - Near-field matrix with dimensions grid.pointX by grid.pointY,
%           where each element corresponds to the complex near-field value
%           at the respective grid point.
%
% Details:
%   This function initializes a matrix `field` of size grid.pointX by
%   grid.pointY. It maps each data point from the input `data` to the
%   corresponding index in `field` based on its x and y position relative
%   to the grid. The real and imaginary parts of the near-field data are
%   combined into complex values in `field`.
%
% Example:
%   grid = PlanarGrid(...);  % Initialize PlanarGrid object with appropriate parameters
%   data = [x1_mm, y1_mm, real1, imag1;  % Near-field data points
%           x2_mm, y2_mm, real2, imag2;
%           ...];
%   nearField = getNearField(grid, data);  % Generate the near-field matrix
%
% See also: PlanarGrid


function field = getNearField(grid, data)
    arguments
        grid PlanarGrid 
        data            % near-field data, either vertical or horizontal measurement
    end

    % find rightmost x and y position
    xMax = max(grid.x(:,1));
    yMax = max(grid.y(1,:));

    % calculate the total number of sampling points
    samplingPoint = grid.pointX * grid.pointY;

    % map all data to the corresponding index in the grid
    field = zeros(grid.pointX, grid.pointY);
    for i = 1:samplingPoint
        % calculate the corresponding index depending on the scanning position
        indexX = round((data(i,1)/1000 + xMax)/grid.spaceX) + 1;
        indexY = round((data(i,2)/1000 + yMax)/grid.spaceY) + 1;

        % map the real and imaginary part to the electricNearField matrix
        field(indexX,indexY) = data(i,3) + 1j*data(i,4);
    end   

end