function obj = computeFarField(obj)
    
    arguments(Input)
        obj OerwgField  
    end
    
    X = 0.5 * obj.waveNumber * obj.width .* sin(obj.grid.theta) .* cos(obj.grid.phi);
    
    Y = 0.5 * obj.waveNumber * obj.height .* sin(obj.grid.theta) .* sin(obj.grid.phi);
    
    C = j*(obj.width * obj.height * obj.waveNumber * ...
        exp(-j*obj.waveNumber*obj.distance)) / (2*pi*obj.distance);
    
    term       = cos(X) ./ (X^2 - (pi/2)^2) .* sin(Y) ./ Y;
    fieldTheta = -(pi/2) * C * sin(obj.grid.phi) .* term;
    fieldPhi   = - (pi/2) * C * cos(obj.grid.theta) * cos(obj.grid.phi) .* term;
    
    % meshgrid of data points in x- and y- coordinate
    x_ = obj.distance .* sin(obj.grid.theta) .* cos(obj.grid.phi);
    y_ = obj.distance .* sin(obj.grid.theta) .* sin(obj.grid.phi);
    
    obj.farField = MeshgridQuantity(x_,         ...
                                    y_,         ...
                                    fieldTheta, ...
                                    fieldPhi);
                                
end