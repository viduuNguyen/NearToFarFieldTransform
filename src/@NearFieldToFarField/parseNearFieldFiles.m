% parseNearFieldFiles(obj, fileNameX, fileNameY)
%
% Parses near-field data from two input files and returns it as a MeshgridQuantity object.
%
% Input arguments:
%   obj - Instance of NearFieldToFarField class
%   fileNameX - String specifying the filename containing near-field data for X component
%   fileNameY - String specifying the filename containing near-field data for Y component
%
% Output:
%   nearField - MeshgridQuantity object containing parsed near-field data
%
% Details:
%   This function loads near-field data from the files specified by fileNameX and fileNameY,
%   constructs a scanning grid using the NearFieldToFarField instance's getNearFieldGrid method,
%   and maps the loaded data onto this grid using the getNearField method. The resulting
%   near-field data is encapsulated in a MeshgridQuantity object with logarithmic scaling.
%
% Example:
%   % Create an instance of NearFieldToFarField class
%   obj = NearFieldToFarField();
%
%   % Parse near-field data from files "dataX.txt" and "dataY.txt"
%   nearField = obj.parseNearFieldFiles("dataX.txt", "dataY.txt");
%
%   % Display the parsed near-field data
%   [f, ax] = nearField.display();
%
% See also: NearFieldToFarField, getNearFieldGrid, getNearField, MeshgridQuantity


function nearField = parseNearFieldFiles(obj, fileNameX, fileNameY)
    arguments(Input)
        obj       NearFieldToFarField
        fileNameX string
        fileNameY string
    end
    
    
    arguments(Output)
        nearField MeshgridQuantity
    end
    
    error("update required");

     % load data files
    dataX = load(fileNameX);
    dataY = load(fileNameY);
    grid = obj.getNearFieldGrid(dataX, dataY);

    % map near-field complex data
    fieldX = obj.getNearField(grid, dataX);
    fieldY = obj.getNearField(grid, dataY);
    
    % return near-field
    nearField = MeshgridQuantity(grid.x, grid.y, fieldX, fieldY, "20log");
end