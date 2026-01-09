%% SVPWM代码仿真测试
% 创建人：      杨晅
% 创建时间：    2024.4.4
% 版本：        V0.0.1                    
% 更新记录：       
% 2025.09.25    初步更新传统SVPWM计算方式的过调剂函数计算架构
% 2025.10.09    正常SVPWM计算公式完成，过调制待补完
% 2025.10.13    增加SVPWM快速过调制功能，设置过调制启动标志位
% 2025.10.20    初步规划SVPWM补偿过调制功能，补充部分快速SVPWM算法
% 2025.11.03    快速SVPWM算法存在问题，和传统SVPWM计算结果存在较大误差，且极限电压状态下无法进行合理的限幅
%%
clear 
close all
clc
%%
% 电压矢量角度步长
N = 500;
% 电压矢量圆周期
cyc = 10;
% 母线电压
Vdc = 13.5;
% SVPWM正六边形调制最大电压
Vref_Hex = 2*Vdc/3;
% SVPWM内接圆调制最大电压
Vref_InC = Vdc/sqrt(3);
% SVPWM调制电压角度
angle = 0:pi/N:cyc*2*pi;
% SVPMW调制时间最大值
Duty_max = 0.98;
% SVPMW调制时间最小值
Duty_min = 0.02;
% SVPWM过调制开启标志位
SVPWM_OverModulationEnableFlag = 1;
SVPWM_OverModulationDisEnableFlag = 0;

% SVPWM正六边形调制电压矢量
V_Hex_SVPWM_abs = (Vref_Hex*(Duty_max))*ones(1,length(angle));
[~,~,~,V_ideal,Theta_ideal] = SVPWM_Origianl(V_Hex_SVPWM_abs,Vref_InC,angle,Duty_max,Duty_min,SVPWM_OverModulationEnableFlag);
V_Hex_Point = zeros(3,length(Theta_ideal));
V_Hex_Point(1,:) = (Vref_Hex.*V_ideal.*cos(Theta_ideal));
V_Hex_Point(2,:) = (Vref_Hex.*V_ideal.*sin(Theta_ideal));
V_Hex_Point(3,:) = 1:1:length(Theta_ideal);

% SVPWM内接圆调制电压矢量
V_InC_SVPWM_abs = (Vref_InC*(Duty_max))*ones(1,length(angle));
[~,~,~,V_ideal,Theta_ideal] = SVPWM_Origianl(V_InC_SVPWM_abs,Vref_InC,angle,Duty_max,Duty_min,SVPWM_OverModulationEnableFlag);
V_InC_Point = zeros(3,length(angle));
V_InC_Point(1,:) = (Vref_Hex.*V_ideal.*cos(Theta_ideal));
V_InC_Point(2,:) = (Vref_Hex.*V_ideal.*sin(Theta_ideal));
V_InC_Point(3,:) = 1:1:length(angle);

% SVPWM调制电压矢量（传统计算方式）
V_SVPWM_Gain_Ori = angle/(5*2*pi);
V_SVPWM_abs_Ori = (Vref_InC.*(Duty_max).*V_SVPWM_Gain_Ori).*ones(1,length(angle));
[~,~,~,V_real_Ori,Theta_real_Ori] = SVPWM_Origianl(V_SVPWM_abs_Ori,Vref_InC,angle,Duty_max,Duty_min,SVPWM_OverModulationEnableFlag);
V_real_Point_Ori = zeros(3,length(Theta_real_Ori));
V_real_Point_Ori(1,:) = (Vref_Hex.*V_real_Ori.*cos(Theta_real_Ori));
V_real_Point_Ori(2,:) = (Vref_Hex.*V_real_Ori.*sin(Theta_real_Ori));
V_real_Point_Ori(3,:) = 1:1:length(Theta_real_Ori);

% SVPWM调制电压矢量（快速计算方式）
V_SVPWM_Gain_Fast = angle/(1*2*pi);
V_SVPWM_abs_Fast = (Vref_InC.*(Duty_max).*V_SVPWM_Gain_Fast).*ones(1,length(angle));
[~,~,~,V_real_Fast,Theta_real_Fast] = SVPWM_Fast(V_SVPWM_abs_Fast,Vref_InC,angle,Duty_max,Duty_min,SVPWM_OverModulationEnableFlag);
V_real_Point_Fast = zeros(3,length(Theta_real_Fast));
V_real_Point_Fast(1,:) = (Vref_Hex.*V_real_Fast.*cos(Theta_real_Fast));
V_real_Point_Fast(2,:) = (Vref_Hex.*V_real_Fast.*sin(Theta_real_Fast));
V_real_Point_Fast(3,:) = 1:1:length(Theta_real_Fast);


%% Display
% figure(1)
% h1 = plot3(V_Hex_Point(1,:),V_Hex_Point(2,:),V_Hex_Point(3,:));
% hold on
% h2 = plot3(V_InC_Point(1,:),V_InC_Point(2,:),V_InC_Point(3,:));
% hold on
% h3 = plot3(V_real_Point_Ori(1,:),V_real_Point_Ori(2,:),V_real_Point_Ori(3,:),":^");%'-ob','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
% hold off
% legend('正六边形电压矢量','内接圆电压矢量','调制电压矢量');
% title('电压矢量图');
% clear h1 h2 h3;

figure(2)
h1 = plot3(V_real_Point_Ori(1,:),V_real_Point_Ori(2,:),V_real_Point_Ori(3,:),":^");%'-ob','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
hold on
h2 = plot3(V_real_Point_Fast(1,:),V_real_Point_Fast(2,:),V_real_Point_Fast(3,:),"-.pentagram");%'-ob','MarkerSize',10,'MarkerFaceColor','#D9FFFF');
legend('SVPWM传统计算方式','快速SVPWM');
% figure(3)
% plot(T1);
% hold on
% plot(T2);



% figure(4)
% plot(Vbref_Point);
% hold on
% plot(Vbideal_Point);
% hold on
% plot(Vbreal_Point);
% legend('参考电压矢量','理想电压矢量','限幅电压矢量');
% title('B相电压');
% 
% 
% figure(5)
% plot(Vcref_Point);
% hold on
% plot(Vcideal_Point);
% hold on
% plot(Vcreal_Point);
% legend('参考电压矢量','理想电压矢量','限幅电压矢量');
% title('C相电压');



%% Function
%
function [T1,T2,T,Vreal,Theta_SVPWM] = SVPWM_Origianl(Vref,Vref_Max,Theta,Duty_max,Duty_min,OverModulationFlag)
    len = length(Theta);
    Vref_ModulationRate = Vref./Vref_Max;
    theta_ = mod(Theta,pi/3);
    Theta_SVPWM = Theta;
    SectorN = fix(Theta/(pi/3));
    T1 = zeros(1,len);
    T2 = zeros(1,len);
    T = zeros(1,len);
    Vreal = zeros(1,len);
    for i = 1:len
        if(mod(SectorN(i),2)==0)
            T1(i) = Vref_ModulationRate(i)*sin(pi/3-theta_(i));
            T2(i) = Vref_ModulationRate(i)*sin(theta_(i));
        else
            T2(i) = Vref_ModulationRate(i)*sin(pi/3-theta_(i));
            T1(i) = Vref_ModulationRate(i)*sin(theta_(i));
        end
        if(((T1(i)+T2(i))>Duty_max) && (OverModulationFlag == 1))%(Vref_ModulationRate(i)>1))
            [T1(i),T2(i),Theta_SVPWM(i)] = OverModulation_Quick(T1(i),T2(i),SectorN(i),Theta(i),Duty_max,Duty_min);
        elseif (((T1(i)+T2(i))>Duty_max) && (OverModulationFlag == 0))
            T1(i) = Duty_max*T1(i)/(T1(i)+T2(i));
            T2(i) = Duty_max*T2(i)/(T1(i)+T2(i));
        else

        end
        T1(i) = max([T1(i),Duty_min]);
        T2(i) = max([T2(i),Duty_min]);
        T1(i) = min([T1(i),Duty_max]);
        T2(i) = min([T2(i),Duty_max]);
        T(i) = T1(i) + T2(i);
        Vreal(i) = min([sqrt(T1(i)^2+T1(i)*T2(i)+T2(i)^2),Duty_max]);
    end
end

% 快速SVPWM算法
function [T1,T2,T,Vreal,Theta_SVPWM] = SVPWM_Fast(Vref,Vref_Max,Theta,Duty_max,Duty_min,OverModulationFlag)
    len = length(Theta);
    Vref_ModulationRate = Vref./Vref_Max;
    Vref_A = Vref_ModulationRate.*cos(Theta);
    Vref_B = -(1/2)*Vref_ModulationRate.*cos(Theta) + (sqrt(3)/2)*Vref_ModulationRate.*sin(Theta);
    Vref_C = -(1/2)*Vref_ModulationRate.*cos(Theta) - (sqrt(3)/2)*Vref_ModulationRate.*sin(Theta);
    Theta_SVPWM = Theta;
    T1 = zeros(1,len);
    T2 = zeros(1,len);
    T = zeros(1,len);
    Vreal = zeros(1,len);
    for i = 1:len
        Vmed = median([Vref_A(i),Vref_B(i),Vref_C(i)]);
        DutyA = (1/2) - (Vmed/2 + Vref_A(i));
        DutyB = (1/2) - (Vmed/2 + Vref_B(i));
        DutyC = (1/2) - (Vmed/2 + Vref_C(i));
        
        DutyL = min([DutyA,DutyB,DutyC]);
        DutyM = median([DutyA,DutyB,DutyC]);
        DutyS = max([DutyA,DutyB,DutyC]);
        DutyL = max([DutyL,Duty_min]);
        DutyM = max([DutyM,Duty_min]);
        DutyS = max([DutyS,Duty_min]);
        DutyL = min([DutyL,Duty_max]);
        DutyM = min([DutyM,Duty_max]);
        DutyS = min([DutyS,Duty_max]);

        T1(i) = (DutyM-DutyL);
        T2(i) = (DutyS-DutyM);
        T1(i) = max([T1(i),Duty_min]);
        T2(i) = max([T2(i),Duty_min]);
        T1(i) = min([T1(i),Duty_max]);
        T2(i) = min([T2(i),Duty_max]);
        T(i) = T1(i) + T2(i);
        Vreal(i) = min([sqrt(T1(i)^2+T1(i)*T2(i)+T2(i)^2),Duty_max]);
    end
end

%% Inline Function
% 快速过调制算法
function [T1_Pro,T2_Pro,Theta_Pro] = OverModulation_Quick(T1,T2,SectorN,Theta,Duty_max,Duty_min)
    if((T1+(T2/2)>Duty_max) && (T1>T2))
        T1_Pro = Duty_max;
        T2_Pro = Duty_min;
        if(mod(SectorN,2)==0)
            Theta_Pro = SectorN*pi/3;
        else
            Theta_Pro = (SectorN+1)*pi/3;
        end
    else
        if(T2+(T1/2)>Duty_max)
            T2_Pro = Duty_max;
            T1_Pro = Duty_min;
            if(mod(SectorN,2)==0)
                Theta_Pro = (SectorN+1)*pi/3;
            else
                Theta_Pro = SectorN*pi/3;
            end
        else
            T1_Pro = Duty_max*T1/(T1+T2);
            T2_Pro = Duty_max*T2/(T1+T2);
            Theta_Pro = Theta;
        end
    end
    % Theta_Pro = Theta;
end

% 补偿过调制算法：动态调节输出的参考电压矢量幅值，以补偿在六边形边上损失的电压矢量
function [T1_Pro,T2_Pro,Theta_Pro] = OverModulation_Compensation(SectorN,Theta,Duty_max,Duty_min)

end













