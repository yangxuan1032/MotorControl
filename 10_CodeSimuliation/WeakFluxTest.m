%% 弱磁代码仿真测试
% 创建人：      杨晅
% 创建时间：    2024.4.4
% 版本：        V0.0.1                    
% 更新记录：       
% 2024.09.05    更新电机参数设定
% 2025.04.01    更新电机参数，力矩计算和电压极限圆计算
%%
clear 
close all
clc
%%
Motor_Vdc = 13.5;
Motor_Ibus = 60;
Motor_SpeedMax = 2200; %rpm
Motor_Phi = 0.005919015;

Motor_Rs = 2.86e-2;
Motor_Ld = 5.63e-5;
Motor_Lq = 5.63e-5;
Motor_L0 = 5.63e-5;
Motor_Pn = 4;

Motor_In = 0;
Motor_B = 1;

Motor_Vs = Motor_Vdc/sqrt(3);

Motor_WeMAx = Motor_SpeedMax*Motor_Pn*pi/30;
%%
Id = -Motor_Ibus:1/100:Motor_Ibus;
Iq = sqrt(Motor_Ibus^2 - Id.^2);
Te = 3*Motor_Pn*Iq.*(Motor_Phi+(Motor_Ld-Motor_Lq)*Id);
Umax = sqrt((Motor_WeMAx)^2*Motor_Lq^2*Iq.^2+((Motor_WeMAx)*Motor_Ld*Id+(Motor_WeMAx)*Motor_Phi).^2);

%%
figure(1)
plot3(Id,Iq,Te,'-r*');
hold on
plot3(Id,Iq,Umax,'-b^');

% figure(2)
% plot3(Id,Iq,Umax);

































