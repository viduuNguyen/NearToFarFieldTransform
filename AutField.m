classdef AutField

    properties(Access=private)
        nearFieldGrid PlanarGrid    % near-field grid
        farFieldGrid AngularGrid    % far-field grid
        frequency                   % operating frequency of the antenna
        antenna                     % antenna object
        scanningDistance            % distance between the scanning plane and the antenna

    end

    methods (Access=public)
        function o = AutField(antenna, frequency, nearFieldGrid, farFieldGrid, scanningDistance)
            if (~(isa(nearFieldGrid, "PlanarGrid") && isa(farFieldGrid, "AngularGrid")))
                error("Incorrect argument datatypes");
            end

            % attributes assignment
            o.antenna = antenna;
            o.frequency = frequency;
            o.nearFieldGrid = nearFieldGrid;
            o.farFieldGrid = farFieldGrid;
            o.scanningDistance = scanningDistance;

        end

        function [directivityX_dBi, directivityY_dBi] = getDirectivity_dBi(o)
            elevation_degree = 90 - 180/pi*o.farFieldGrid.theta(:,1);
            directivityX_dBi = patternElevation(o.antenna, o.frequency, 0, "Elevation", elevation_degree);
            directivityY_dBi = patternElevation(o.antenna, o.frequency, 90, "Elevation", elevation_degree);
        end

        function [fieldX, fieldY, fieldZ] = getNearField(o)
            % construct the scanning surface
            % the matrix must have 3 rows (each row is the data series for each coordinate)
            xGrid = o.nearFieldGrid.x;
            yGrid = o.nearFieldGrid.y;
            zGrid = ones(size(xGrid)) * o.scanningDistance;
            scanningSurface = [xGrid(:)';yGrid(:)';zGrid(:)'];
            [fieldX, fieldY, fieldZ] = o.computeNearField(scanningSurface);

        end

        function o = generateNearFieldFiles(o, fileNameX, fileNameY)
            [fieldX, fieldY, ~] = o.getNearField();
            x_ = o.nearFieldGrid.x(:,1);
            y_ = o.nearFieldGrid.x(1,:);

            fileX = fopen(fileNameX, "w");
            fileY = fopen(fileNameY, "w");

            for i = 1 : o.nearFieldGrid.pointX

                for j = 1 : o.nearFieldGrid.pointY
                % distances are measured in (mm)
                % display format: %a.bt
                %   a: field width
                %   b: precision
                %   t: subtype
                fprintf(fileX,'%6.3f %6.3f %6.3f %6.3f\n', x_(i)*1000, y_(j)*1000, real(fieldX(i,j)), imag(fieldX(i,j)));
                fprintf(fileY,'%6.3f %6.3f %6.3f %6.3f\n', x_(i)*1000, y_(j)*1000, real(fieldY(i,j)), imag(fieldY(i,j)));
                end 

            end

        end

    end
    
    methods(Access=private)
        
        function [electricFieldX, electricFieldY, electricFieldZ] = computeNearField(self, scanningSurface)
            % generate electric field at the scanning points
            [electricField,~] = EHfields(self.antenna, self.frequency, scanningSurface);

            % reshape electric field components to match grid dimensions
            pointX = self.nearFieldGrid.pointX;
            pointY = self.nearFieldGrid.pointY;
            electricFieldX = reshape(electricField(1,:),[pointX, pointY]);
            electricFieldY = reshape(electricField(2,:),[pointX, pointY]);
            electricFieldZ = reshape(electricField(3,:),[pointX, pointY]);
        end

    end
end