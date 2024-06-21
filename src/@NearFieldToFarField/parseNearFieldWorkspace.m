function nearField = parseNearFieldWorkspace(obj, xGrid, yGrid, phasorX, phasorY)
    arguments(Input)
        obj       NearFieldToFarField
        xGrid
        yGrid
        phasorX
        phasorY
    end

    arguments(Output)
        nearField MeshgridQuantity
    end
    
    % find set of coordinate of sampling points in x- and y-coordinate
    
    x_ = unique(xGrid(:));
    y_ = unique(yGrid(:));
    
    % find number of sampling points in each coordinate
    pointX = length(x_);
    pointY = length(y_);
    
    % find dimensions of the scanning plane
    lengthX = (pointX + 1) / (pointX) * (max(x_) - min(x_));
    lengthY = (pointY + 1) / (pointY) * (max(y_) - min(y_));
    
    grid = PlanarGrid(pointX, pointY, lengthX, lengthY);
    
    % find leftmost x and y position
    xMin = min(x_);
    yMin = min(y_);

    % map all data to the corresponding index in the grid
    fieldX = zeros(pointX, pointY);
    fieldY = zeros(pointX, pointY);
    spaceX = lengthX / pointX;
    spaceY = lengthY / pointY;

    for m = 1:pointX
        for n = 1:pointY
            indexX = round((xGrid(m,n) - xMin)/spaceX) + 1;
            indexY = round((yGrid(m,n) - yMin)/spaceY) + 1;
            
            fieldX(indexX, indexY) = phasorX(m,n);
            fieldY(indexX, indexY) = phasorY(m,n);
        end
    end

    % find the maxima position of the beam, 
    % assume that the beam exist the maxima in co-polar
    [maxRowIdx, maxColIdx] = findMaxIndex(abs(fieldX));
    
    % align the maxima of the beam to the center
    fieldX = alignMatrix(fieldX, maxRowIdx, maxColIdx);
    fieldY = alignMatrix(fieldY, maxRowIdx, maxColIdx);
    
    nearField = MeshgridQuantity(grid.x, grid.y, fieldX, fieldY, "20log"); 
    
end

%% find the index of the maxima of the matr
function [rowIndex, columnIndex] = findMaxIndex(matr)
    % find the global maxima and its linear index
    [~, linearIndex] = max(matr(:));

    % convert linear index to row and column indices
    [rowIndex, columnIndex] = ind2sub(size(matr), linearIndex); 
end

%% shift the whole matrix by shifting the element with coordinate
% (rowIdx, colIdx) to the center of matr
function shiftedMatr = alignMatrix(matr, rowIdx, colIdx)

    % define the target of alignment at the center of the matrix
    [ROW, COL] = size(matr);
    AIM_ROW    = ROW / 2;
    AIM_COL    = COL / 2;

    % calculate the amount of rows and columns to be shifted
    SHIFT_ROW = AIM_ROW - rowIdx;
    SHIFT_COL = AIM_COL - colIdx;

    % define the result
    shiftedMatr = zeros(ROW, COL);

    % calculate the masks for shifting function
    rowRange        = max(1, 1 - SHIFT_ROW) : min(ROW, ROW - SHIFT_ROW);
    colRange        = max(1, 1 - SHIFT_COL) : min(COL, COL - SHIFT_COL);
    rowRangeShifted = max(1, 1 + SHIFT_ROW) : min(ROW, ROW + SHIFT_ROW);
    colRangeShifted = max(1, 1 + SHIFT_COL) : min(ROW, ROW + SHIFT_COL);

    % assign the values from the original matrix to the shifted one
    shiftedMatr(rowRangeShifted, colRangeShifted) = matr(rowRange, colRange); 
end