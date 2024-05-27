function nearField = parseNearFieldFiles(obj, fileNameX, fileNameY)
    arguments(Input)
        obj       NearFieldToFarField
        fileNameX string
        fileNameY string
    end
    
    
    arguments(Output)
        nearField MeshgridQuantity
    end
    
    % load data files
    dataX = load(fileNameX);
    dataY = load(fileNameY);
    grid = obj.getNearFieldGrid(dataX, dataY);

    % map near-field complex data
    fieldX = obj.getNearField(grid, dataX);
    fieldY = obj.getNearField(grid, dataY);
    
    % return near-field
    nearField = MeshgridQuantity(grid.x, grid.y, fieldX, fieldY);
end