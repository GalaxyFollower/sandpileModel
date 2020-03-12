function [tide, flag] = changeTide(tide, flag)

if flag
    if tide == 3
        flag = 0;
    end
    tide = tide + 1;
    flag =1;
else
    if tide == 2
        flag = 1;
    end
    tide = tide - 1;
    flag = 0;
end