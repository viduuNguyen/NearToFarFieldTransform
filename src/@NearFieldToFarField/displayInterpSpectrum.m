function [f, ax] = displayInterpSpectrum(obj, viewAngle)
    
    arguments(Input)
        obj       NearFieldToFarField
        viewAngle (1,2)               = [0, 90]
    end
    
    arguments(Output)
        f
        ax
    end

    f = figure(Name="Interpolated spectrum components in x- and y-coordinate");
    xAxis = subplot(1,2,1);
    yAxis = subplot(1,2,2);
    ax = [xAxis, yAxis];
    
    surface(obj.interpSpectrum, xAxis, yAxis, viewAngle);
    xlabel([xAxis, yAxis], "wavenumber component X (m^{-1})");
    ylabel([xAxis, yAxis], "wavenumber component Y (m^{-1})");
    zlabel([xAxis, yAxis], "spectrum (dB)");
    title(xAxis, "Co-Polar wave spectrum");
    title(yAxis, "Cross-Polar wave spectrum");
end