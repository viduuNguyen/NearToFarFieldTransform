function obj = computeDirectivity(obj)
    
    arguments
        obj AutField 
    end

    elevation_degree = 90 - 180/pi * obj.farFieldGrid.theta(:,1);
    directivityX = patternElevation(obj.antenna, obj.frequency,  0, "Elevation", elevation_degree);
    directivityY = patternElevation(obj.antenna, obj.frequency, 90, "Elevation", elevation_degree);
    
    obj.directivityX = VectorQuantity(elevation_degree, directivityX);
    obj.directivityY = VectorQuantity(elevation_degree, directivityY);
end