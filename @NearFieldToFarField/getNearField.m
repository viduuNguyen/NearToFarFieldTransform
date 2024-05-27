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