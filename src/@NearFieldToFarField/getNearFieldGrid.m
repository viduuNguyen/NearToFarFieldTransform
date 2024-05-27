function grid = getNearFieldGrid(dataX, dataY)
    % find set of coordinate of sampling points in x- and y-coordinate
    x_ = unique(dataX(:,1));
    y_ = unique(dataY(:,2));
    
    % find number of sampling points in each coordinate
    pointX = length(x_);
    pointY = length(y_);
    
    % find dimensions of the scanning plane
    lengthX = (pointX + 1) / (pointX) * (max(x_) - min(x_)) / 1000;
    lengthY = (pointY + 1) / (pointY) * (max(y_) - min(y_)) / 1000;
    
    grid = PlanarGrid(pointX, pointY, lengthX, lengthY);
end