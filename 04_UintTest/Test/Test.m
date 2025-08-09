%%
close all
clear
clc
%%
A = (4294967295);

resultRef = int32(sqrt(A));
resultUser =  Sqrt_User(A);

%% 存在最低位1的误差
function [x] = Sqrt_User(Data)
    x = uint32(getsqrtInit(Data));
    Datatemp = Data - x^2;
    xtemp = bitshift(x,-1);
    while(xtemp>0)
        xtemp2 = ((bitshift(x,1)) + xtemp)*xtemp;
       if(xtemp2<Datatemp)
           x = x + xtemp;
           Datatemp = Datatemp - xtemp2;
       end
       xtemp = bitshift(xtemp,-1);
    end
end

function [y] = getsqrtInit(A)
    Datatemp = uint32(A);
    Abit = bitor(Datatemp,bitshift(Datatemp,-1));
    Abit = bitor(Abit,bitshift(Abit,-2));
    Abit = bitor(Abit,bitshift(Abit,-4));
    Abit = bitor(Abit,bitshift(Abit,-8));
    Abit = bitor(Abit,bitshift(Abit,-16));
    Abit = bitshift(Abit+1,-1);
    switch(Abit)
        case 1
            y = 2^0;
        case 2
            y = 2^0;
        case 4
            y = 2^1;
        case 8
            y = 2^1;
        case 16
            y = 2^2;
        case 32
            y = 2^2;
        case 64
            y = 2^3;
        case 128
            y = 2^3;
        case 256
            y = 2^4;
        case 512
            y = 2^4;
        case 1024
            y = 2^5;
        case 2048
            y = 2^5;
        case 4096
            y = 2^6;
        case 8192
            y = 2^6;
        case 16384
            y = 2^7;
        case 32768
            y = 2^7;
        case 65536
            y = 2^8;
        case 131072
            y = 2^8;
        case 262144
            y = 2^9;
        case 524288
            y = 2^9;
        case 1048576
            y = 2^10;
        case 2097152
            y = 2^10;
        case 4194304
            y = 2^11;
        case 8338608
            y = 2^11;
        case 16777216
            y = 2^12;
        case 33554432
            y = 2^12;
        case 67108864
            y = 2^13;
        case 134217728
            y = 2^13;
        case 268435456
            y = 2^14;
        case 536870912
            y = 2^14;
        case 1073741824
            y = 2^15;
        case 2147483647
            y = 2^15;
        case 4294967295
            y = 2^16;
        otherwise
            y = 0;
    end
end
