function generateNearFieldFiles(obj, fileNameX, fileNameY)
    
    arguments
        obj AutField
        fileNameX string = "nearFieldX.txt"
        fileNameY string = "nearFieldY.txt"
    end
    
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