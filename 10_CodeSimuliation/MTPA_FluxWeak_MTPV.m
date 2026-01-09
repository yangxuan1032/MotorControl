%% MTPA代码仿真测试
% 创建人：      杨晅
% 创建时间：    2024.4.5
% 版本：        V0.0.1                    
% 更新记录：       
% 20250830      优化MPTV计算方式；增加FluxWeak仿真代码；增加部分MTPV仿真代码（待继续开发）
% 20250906      初步完成MPTV计算方式优化，并完成初步的整体MTPA-FluxWeak-MTPV仿真；对于整体仿真过程中的转速设定需要优化（无法反映真实的电机转速，只能计算出时刻的理论最大转速）
% 20251213      应考虑
%%
clear 
close all
clc
%% Basic Paramers
J = 6.9683e-5;
Pn = 4;
Psi_f = 2.6e-3;
Rs = 6e-3;
Ld = 2.1e-5;
Lq = 3.3E-5;
Vdc = 13.5;
Ip_max = 150;
Idc_max = 80;
Speed_max_Pro = 6500; % RPM Peak
Speed_max = 5000; % RPM
T_load = 0.9;
%% Deduction Parameres
Vs = Vdc/sqrt(3);
Is = Ip_max;
Id_min = -2*Is/3;
We_max_pro = Speed_max_Pro*pi/30*Pn;
We_max = Speed_max*pi/30*Pn;

%% Variable Parameres
%
MTPA_I = zeros(2,1);
MTPA_Te = zeros(1,1);
MTPA_Wm = zeros(1,1);
MTPA_We = zeros(1,1);
MTPA_Speed = zeros(1,1);
%
FluxWeak_I = zeros(2,1);
FluxWeak_Te = zeros(1,1);
FluxWeak_Wm = zeros(1,1);
FluxWeak_We = zeros(1,1);
FluxWeak_Speed = zeros(1,1);
%
MTPV_I = zeros(2,1);
MTPV_Te = zeros(1,1);
MTPV_Wm = zeros(1,1);
MTPV_We = zeros(1,1);
MTPV_Speed = zeros(1,1);
%
Motor_I = zeros(2,1);
Motor_Te = zeros(1,1);
Motor_Wm = zeros(1,1);
Motor_We = zeros(1,1);
Motor_Speed = zeros(1,1);

%% MTPA Simulation
% Is_MTPA = 0:1e-2:Is;
% len = length(Is_MTPA);
% for i = 1:len
%     Id_temp = -Is_MTPA(i):1e0:Is_MTPA(i);
%     Iq_temp = sqrt(Is_MTPA(i)^2 - Id_temp.^2);
%     Te_temp = 3.*Pn.*Iq_temp.*(Psi_f + ((Ld-Lq).*Id_temp))/2;
%     [~,index_max] = max(Te_temp);
%     MTPA_Te = [MTPA_Te,Te_temp(index_max)];
%     MTPA_I=[MTPA_I,[Id_temp(index_max);Iq_temp(index_max)]];
%     Wm_Temp = 5e-5*(Te_temp(index_max) - ((MTPA_Wm(end)^2*2.5e-4)))/J;
%     MTPA_Wm = [MTPA_Wm,Wm_Temp+(MTPA_Wm(end))];
%     MTPA_We = [MTPA_We,Pn*Wm_Temp+(MTPA_We(end))];
%     MTPA_Speed = [MTPA_Speed,60*Wm_Temp/(2*pi)+(MTPA_Speed(end))];
% end
% clear Iq_temp Id_temp Te_temp Wm_temp index_max Is_MTPA len i;

Id_temp = -65;
Iq_temp = 135.1851;
Wm_temp = 1;

while MTPA_Speed <= 5000
    Te_temp = 3.*Pn.*Iq_temp.*(Psi_f + ((Ld-Lq).*Id_temp))/2;
    Wm_temp = 5e-5*(Te_temp - ((MTPA_Wm(end)^2*1e-6)))/J;
    MTPA_Te = [MTPA_Te,Te_temp];
    MTPA_Wm = [MTPA_Wm,Wm_temp+(MTPA_Wm(end))];
    MTPA_We = [MTPA_We,Pn*Wm_temp+(MTPA_We(end))];
    MTPA_Speed = [MTPA_Speed,60*Wm_temp/(2*pi)+(MTPA_Speed(end))];
    MTPA_I=[MTPA_I,[Id_temp;Iq_temp]];
end
clear Iq_temp Id_temp Te_temp Wm_temp;
%% WeakFlux Simulation
Id_FluxWeak = MTPA_I(1,end):-1e-2:Id_min;
FluxWeak_Wm = MTPA_Wm(end);
FluxWeak_We = MTPA_We(end);
FluxWeak_Speed = MTPA_Speed(end);
len = length(Id_FluxWeak);
for i = 1:len
    Id_temp = Id_FluxWeak(i);
    Iq_temp = sqrt(Is^2 - Id_temp^2);
    Vd_temp = Rs*Id_temp - FluxWeak_Wm(end).*(Lq*Iq_temp);
    Vq_temp = Rs*Iq_temp + FluxWeak_Wm(end).*(Ld*Id_temp+Psi_f);
    Vs_temp = Vd_temp.^2 + Vq_temp.^2;
    [~,index_max] = max(find(Vs_temp<(Vs^2)));
    Te_temp = 3.*Pn.*Iq_temp(index_max).*(Psi_f - ((Lq-Ld).*Id_temp(index_max)))/2;
    FluxWeak_I = [FluxWeak_I,[Id_temp(index_max);Iq_temp(index_max)]];
    FluxWeak_Te = [FluxWeak_Te,Te_temp];
    Wm_temp = 5e-5*(Te_temp - ((FluxWeak_Wm(end)^2*1e-6)))/J;
    FluxWeak_Wm = [FluxWeak_Wm,Wm_temp + FluxWeak_Wm(end)];
    FluxWeak_We = [FluxWeak_We,Pn*Wm_temp+(FluxWeak_We(end))];
    FluxWeak_Speed = [FluxWeak_Speed,60*Wm_temp/(2*pi)+(FluxWeak_Speed(end))];
end
clear Iq_temp Id_temp Te_temp Wm_temp Vd_temp Vq_temp Vs_temp index_max Id_FluxWeak len i;
%% MTPV Simulation
% Id_MTPV = FluxWeak_I(1,end):1e-2:-10;
% Iq_MTPV = 0:1:FluxWeak_I(2,end);
% MTPV_Wm = FluxWeak_Wm(end);
% MTPV_We = FluxWeak_We(end);
% MTPV_Speed = FluxWeak_Speed(end);
% Te_temp = 0;
% I_temp = zeros(2,1);
% len_we = length(We_MTPV);
% len_iq = length(Iq_MTPV);
% for i = 1:len_we
%     We_temp = We_MTPV(i);
%     Te_temp_I = 0;
%     for j = 1:len_iq
%         Iq_temp = Iq_MTPV(j);  
%         Id_temp = Id_MTPV;
%         Vd_temp = Rs.*Id_temp - We_temp.*(Lq*Iq_temp);
%         Vq_temp = Rs*Iq_temp + We_temp.*(Ld*Id_temp+Psi_f);
%         Vs_temp = Vd_temp.^2 + Vq_temp.^2;
%         Id_temp = Id_MTPV(find(Vs_temp<=(Vs^2)));
%         Te_temp_I = 3.*Pn.*Iq_temp.*(Psi_f - ((Lq-Ld).*Id_temp))/2;
%         [~,index_max] = max(find(Te_temp_I));
%         if(Te_temp<Te_temp_I(index_max))
%             Te_temp = Te_temp_I(index_max);
%             I_temp(1,1) = Id_temp(index_max);
%             I_temp(2,1) = Iq_temp;
%         end
%     end
%     MTPV_We = [MTPV_We,We_temp];
%     MTPV_I = [MTPV_I,I_temp];
%     MTPV_Te = [MTPV_Te,Te_temp];
% end
% clear Iq_temp Id_temp Te_temp We_temp Vd_temp Vq_temp Vs_temp index_max Id_MTPV Iq_MTPV We_MTPV Te_temp I_temp len_we len_iq Te_temp_I j i;

%% Motor Simulation
Motor_Wm = [MTPA_Wm(2:end),FluxWeak_Wm(2:end),MTPV_Wm(2:end)];
Motor_We = [MTPA_We(2:end),FluxWeak_We(2:end),MTPV_We(2:end)];
Motor_Speed = [MTPA_Speed(2:end),FluxWeak_Speed(2:end),MTPV_Speed(2:end)];
Motor_I = [MTPA_I(:,2:end),FluxWeak_I(:,2:end),MTPV_I(:,2:end)];
Motor_Te = [MTPA_Te(2:end),FluxWeak_Te(2:end),MTPV_Te(2:end)];

%% Display
figure(1);
plot(Motor_Speed);
figure(2);
plot(Motor_Te);
figure(3);
plot(Motor_I(1,:));
figure(4);
plot(Motor_I(2,:));
% figure(3)
% plot3(Motor_I(1,:),Motor_I(2,:),Motor_Te);














