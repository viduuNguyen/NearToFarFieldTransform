% generateNearFieldFiles - Export near-field data to text files.
%
%   generateNearFieldFiles(obj, fileNameX, fileNameY)
%
%   Inputs:
%       obj       - AutField object.
%       fileNameX - Name of the file to save the x-component of the near-field data.
%                   Default is "nearFieldX.txt".
%       fileNameY - Name of the file to save the y-component of the near-field data.
%                   Default is "nearFieldY.txt".
%
%   This function exports the x-component and y-component of the near-field data
%   stored in obj.nearField to text files specified by fileNameX and fileNameY,
%   respectively. The data is formatted with x and y coordinates (in meters) followed
%   by the real and imaginary parts of the field components. Each data point is written
%   in a new line.
%
%   Notes:
%   - The near-field data must be stored in obj.nearField as a MeshgridQuantity object.
%   - Coordinates are converted to millimeters (mm) for display in the text files.
%
%   Example:
%       antenna = AntennaObject(); % Replace with actual antenna object designed by MATLAB Antenna Toolbox
%       frequency = 3e9; % 3 GHz
%       nearFieldGrid = PlanarGrid(256, 256, 1.0, 1.0);
%       farFieldGrid = AngularGrid(0.01);
%       scanningDistance = 1.0;
%       autField = AutField(antenna, frequency, nearFieldGrid, farFieldGrid, scanningDistance);
%
%       autField.generateNearFieldFiles('myNearFieldX.txt', 'myNearFieldY.txt');
%
%   See also: MeshgridQuantity.


function generateNearFieldFiles(obj, fileNameX, fileNameY)
    
    arguments
        obj AutField
        fileNameX string = "nearFieldX.txt"
        fileNameY string = "nearFieldY.txt"
    end
    
    error("Update required");
    
    % resolve the electric Near-Field and scanning coordinates
    fieldX = obj.nearField.X;
    fieldY = obj.nearField.Y;
    
    x_ = o.nearFieldGrid.x(:,1);
    y_ = o.nearFieldGrid.y(1,:);
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