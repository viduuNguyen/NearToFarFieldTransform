function singlePlot(obj, ax)
    arguments
       obj VectorQuantity 
       ax
    end
    
    switch obj.scale
        case "linear"
            y = obj.y;
        case "10log"
            y = 10*log10(abs(obj.y));
        case "20log"
            y = 20*log10(abs(obj.y));
        otherwise
            error("Wrong option for scale");
    end
    plot(ax, obj.x, y);
end
