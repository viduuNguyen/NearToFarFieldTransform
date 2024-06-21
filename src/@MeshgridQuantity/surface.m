function surface(obj, xAxis, yAxis, viewAngle)
    arguments
        obj       MeshgridQuantity  
        xAxis
        yAxis
        viewAngle (1,2) = [0, 90] % azimuth and elevation of observation view
    end
    
    switch obj.scale
        case "20log"
            X = 20*log10(abs(obj.X));
            Y = 20*log10(abs(obj.Y));
        case "10log"
            X = 10*log10(abs(obj.X));
            Y = 10*log10(abs(obj.Y));
        case "linear"
            X = abs(obj.X);
            Y = abs(obj.Y);
        case "signed"
            X = obj.X;
            Y = obj.Y;
        otherwise
            error("Wrong option for scale");
    end

    surf(xAxis, obj.xGrid, obj.yGrid, X);
    shading(xAxis, "flat");
    pbaspect(xAxis,[1,1,1]);
    view(xAxis, viewAngle);
    colorbar(xAxis);
    
    surf(yAxis, obj.xGrid, obj.yGrid, Y);
    shading(yAxis, "flat");
    pbaspect(yAxis,[1,1,1]);
    view(yAxis, viewAngle);
    colorbar(yAxis);
end