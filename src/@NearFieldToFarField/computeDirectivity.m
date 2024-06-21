function [directivityX, directivityY] = computeDirectivity(obj, farFieldX, farFieldY)
    % compute the directivity in xz and yz planes and store in obj.directivityX / Y
    arguments
        obj       NearFieldToFarField 
        farFieldX
        farFieldY
    end
    
    % compute the (effective) energy intensity
    intensity = abs(farFieldX).^2 + abs(farFieldY).^2;

    power = computePower(intensity, obj.farFieldGrid);

    % compute the directivity of the antenna
    directivity = 4*pi*intensity/power;

    % compute the directivity components in dBi
    % co-polarisation plane phi = 0
    phiIndex180 = length(obj.farFieldGrid.phi(1,:));
    phiIndex0 = 1;
    phiIndex90 = floor(phiIndex180/2);
    elevation_degree = 90 - 180/pi * obj.farFieldGrid.theta(:,1);
    
    directivityX = VectorQuantity(elevation_degree,directivity(:,phiIndex0), "10log");
    % cross-polarisation plane phi = pi/2
    directivityY = VectorQuantity(elevation_degree,directivity(:,phiIndex90), "10log");
     
end

function power = computePower(intensity, grid)
    % calculate the double integration by numerical approximation
    
    arguments
        intensity (:,:) double {mustBeNumeric}
        grid      AngularGrid
    end
    
    % calculate total samples in theta- and phi-grid
    pointTheta = length(grid.theta(:,1));
    pointPhi = length(grid.phi(1,:));

    % create the coefficients for odd and even number case of pointTheta and pointPhi
    if mod (pointTheta, 2) == 0
        thetaCoefficient = [1 4 repmat([2 4], 1, floor((pointTheta - 3)/2)) 2 1];
    else
        thetaCoefficient = [1 4 repmat([2 4], 1, floor((pointTheta - 3)/2)) 1];
    end

    if mod(pointPhi, 2) == 0
        phiCoefficient = [1 4 repmat([2 4], 1, floor((pointPhi - 3)/2)) 2 1];
    else
        phiCoefficient = [1 4 repmat([2 4], 1, floor((pointPhi - 3)/2)) 1];
    end
    
    % calculate the grid space between two adjacent sampling points
    spacePhi = abs(grid.phi(1,1) - grid.phi(1,2));
    spaceTheta = abs(grid.theta(1,1) - grid.theta(2,1));
    
    % compute the double summation
    % term of the summation
    term = intensity .* (thetaCoefficient' * phiCoefficient) .* sin(grid.theta);
    power = 1/9 * spaceTheta * spacePhi * sum(sum(abs(term)));
end