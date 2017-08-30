classdef DATA < handle
    properties
        data;
        channels;
    end
    methods
        function obj=DATA(data,channels)
            obj.data=data;
            obj.channels=channels;
        end
    end
end