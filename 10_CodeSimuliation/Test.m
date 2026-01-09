%% 脚本测试
% 创建人：      杨晅
% 创建时间：    2025.12.12
% 版本：        V0.0.1                    
% 更新记录：       
% 202501212      代码初步测试脚本
%%
clear 
close all
clc
%% 
Vdc = 13.5;
H = Vdc/sqrt(3);
R_Max = Vdc*2/3;
R = H:1e-4:R_Max;
R_Rate = R./(H);
Theta1 = acos(H./R);
S = (sqrt(3)/18*Vdc^2) - (pi/12.*(R.^2));

%%
figure(1)
plot(R_Rate,S);



