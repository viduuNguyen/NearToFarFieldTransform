function surface(obj, xAxis, yAxis, options)
    arguments
        obj MeshgridQuantity  
        xAxis
        yAxis
        options.Scale (1,1) string = "linear"
    end
    
    switch options.Scale
        case "20log"
            X = 20*log10(abs(obj.X));
            Y = 20*log10(abs(obj.Y));
        case "10log"
            X = 10*log10(abs(obj.X));
            Y = 10*log10(abs(obj.Y));
        case "linear"
            X = abs(obj.X);
            Y = abs(obj.X);
        otherwise
            error("Wrong option for Scale");
    end
    
    surf(xAxis, obj.x, obj.y, X);
    shading(xAxis, "flat");
    pbaspect(xAxis,[1,1,1]);
    view(xAxis, 2);
    colorbar();
    
    surf(yAxis, obj.x, obj.y, Y);
    shading(yAxis, "flat");
    pbaspect(yAxis,[1,1,1]);
    view(yAxis, 2);
    colorbar();
end