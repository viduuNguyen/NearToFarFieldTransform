function obj = computeNearField(obj)
    % compute the Near-Field and store in attribute obj.nearField
    
    arguments
        obj AutField 
    end
    
    % construct the scanning surface
    % the matrix must have 3 rows (each row is the data series for each coordinate)
    xGrid = obj.nearFieldGrid.x;
    yGrid = obj.nearFieldGrid.y;
    zGrid = ones(size(obj.nearFieldGrid.x)) * obj.scanningDistance;
    size(xGrid), size(yGrid), size(zGrid)
    scanningSurface = [xGrid(:)';yGrid(:)';zGrid(:)'];
    
    % generate electric field at the scanning points
    [field, ~] = EHfields(obj.antenna, obj.frequency, scanningSurface);
    
    % reshape the field dimension to match the grid dimension
    dimension = size(obj.nearFieldGrid.x);
    fieldX = reshape(field(1,:), dimension);
    fieldY = reshape(field(2,:), dimension);
    
    obj.nearField = MeshgridQuantity(xGrid, yGrid, fieldX, fieldY);
end