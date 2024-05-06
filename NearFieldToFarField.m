classdef NearFieldToFarField
    
    properties (Access=private)
        waveNumber                  % wave number
        waveNumberX                 % wave number component in x coordinate
        waveNumberY                 % wave number component in y coordinate
        nearFieldGrid PlanarGrid    % near-field scanning grid
        farFieldGrid AngularGrid    % far-field scanning grid
        farFieldDistance            % far-field distance
        fftSizeX                    % size of the fft in x coordinate
        fftSizeY                    % size of the fft in y coordinate
    end

    methods(Access=public)
        function [fieldX, fieldY, grid] = parseNearFieldFiles(o, fileNameX, fileNameY)
            % load data files
            dataX = load(fileNameX);
            dataY = load(fileNameY);
            grid = o.getNearFieldGrid(dataX, dataY);

            % map near-field complex data
            fieldX = o.getNearField(grid, dataX);
            fieldY = o.getNearField(grid, dataY);
        end

        function o = setUp(o, nearFieldGrid, farFieldGrid, wavelength, farFieldDistance, fftSizeX, fftSizeY)
            % set the instance's attributes
            o.farFieldGrid = farFieldGrid;
            o.nearFieldGrid = nearFieldGrid;
            o.farFieldDistance = farFieldDistance;
            o.fftSizeX = fftSizeX;
            o.fftSizeY = fftSizeY;
            
            % find the set of indices (to compute the wave number components)
            x = -fftSizeX/2 : fftSizeX/2 - 1;
            y = -fftSizeY/2 : fftSizeY/2 - 1;

            % compute the wave number and wave number components
            o.waveNumber = 2*pi/wavelength;
            o.waveNumberX = 2*pi*x/(fftSizeX*nearFieldGrid.spaceX);
            o.waveNumberY = 2*pi*y/(fftSizeY*nearFieldGrid.spaceY);
            
        end
        
        function [fieldTheta, fieldPhi] = nf2fft(o, nearFieldX, nearFieldY)
            % compute the plane wave spectrum of the electromagnetic field
            [spectrumRectangularX, spectrumRectangularY, ~] = o.getSpectrum(nearFieldX, nearFieldY);

            % interpolate the spectrum at the far-field scanning grid
            spectrumAngularX = o.interpolateSpectrum(spectrumRectangularX);
            spectrumAngularY = o.interpolateSpectrum(spectrumRectangularY);

            % compute the electric far-field angular components
            [fieldTheta, fieldPhi] = o.getFarField(spectrumAngularX, spectrumAngularY);
        end

        function [directivityX_dBi, directivityY_dBi] = getDirectivity_dBi(o, fieldTheta, fieldPhi)
            % compute the (effective) energy intensity
            intensity = abs(fieldTheta).^2 + abs(fieldPhi).^2;
        
            % compute the total power by applying the numerical approximation
            thetaCoefficient = [1 4 repmat([2 4], 1, floor(length(o.farFieldGrid.theta(:,1))/2) - 1) 1];
            phiCoefficient = [1 4 repmat([2 4], 1, floor(length(o.farFieldGrid.phi(1,:))/2) - 1) 1];
            dphi = abs(o.farFieldGrid.phi(1,1) - o.farFieldGrid.phi(1,2));
            dtheta = abs(o.farFieldGrid.theta(1,1) - o.farFieldGrid.theta(2,1));
            power = dtheta*dphi*sum(sum(intensity.*(thetaCoefficient'*phiCoefficient).*abs(sin(o.farFieldGrid.theta))))/9;
        
            % compute the directivity of the antenna
            directivity = 4*pi*intensity/power;

            % compute the directivity components in dBi
            % co-polarisation plane phi = 0
            directivityX_dBi = 10*log10(directivity(:,1));
            % cross-polarisation plane phi = pi/2
            phiIndex = floor(length(o.farFieldGrid.phi(1,:))/2);
            directivityY_dBi = 10*log10(directivity(:,phiIndex));
        end

    end

    methods(Access=private)

        function grid = getNearFieldGrid(~, dataX, dataY)
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

        function field = getNearField(~, grid, data)
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
        
        function [spectrumX, spectrumY, spectrumZ] = getSpectrum(o, nearFieldX, nearFieldY)
            

            % compute wave number components
            [waveNumberYGrid, waveNumberXGrid] = meshgrid(o.waveNumberY, o.waveNumberX);
            waveNumberZGrid = sqrt(o.waveNumber^2 - waveNumberXGrid.^2 - waveNumberYGrid.^2); 
            
            % compute plane wave spectrum components
            spectrumX = fftshift(fft2(nearFieldX, o.fftSizeX, o.fftSizeY));
            spectrumY = fftshift(fft2(nearFieldY, o.fftSizeX, o.fftSizeY));
            spectrumZ = - (spectrumX.*waveNumberXGrid + spectrumY*waveNumberYGrid)./waveNumberZGrid;
        end

        function spectrumAngular = interpolateSpectrum(o, spectrumRectangular)
            X = o.waveNumberX;
            Y = o.waveNumberY;
            V = abs(spectrumRectangular');
            Xq = o.waveNumber * sin(o.farFieldGrid.theta) .* cos(o.farFieldGrid.phi);
            Yq = o.waveNumber * sin(o.farFieldGrid.theta) .* sin(o.farFieldGrid.phi);
            spectrumAngular = interp2(X, Y, V, Xq, Yq, "spline");
        end

        function [fieldTheta, fieldPhi] = getFarField(o, spectrumX, spectrumY)
            % compute radial-dependent component
            C = 1j*(o.waveNumber*exp(-1j*o.waveNumber*o.farFieldDistance))/(2*pi*o.farFieldDistance);

            % compute far-field components
            spectrumTheta = spectrumX .* cos(o.farFieldGrid.phi) + spectrumY .* sin(o.farFieldGrid.phi);
            fieldTheta = C .* spectrumTheta;

            spectrumPhi = (-spectrumX.*sin(o.farFieldGrid.phi) + spectrumY.*cos(o.farFieldGrid.phi)).*cos(o.farFieldGrid.theta);
            fieldPhi = C.*spectrumPhi;
        end
        
    end

end