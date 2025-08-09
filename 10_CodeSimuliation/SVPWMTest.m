%% SVPWM代码仿真测试
% 创建人：      杨晅
% 创建时间：    2024.4.4
% 版本：        V0.0.1                    
% 更新记录：       
% 
%%
clear 
close all
clc
%%
cyc = 10;
Vdc = 13.5;
K_Vref = 1;
Vref = (2*Vdc/3) * K_Vref;
angle = 0:pi/5000:cyc*2*pi;
% V abs
% Vref_svpwm_abs = 0:Vref/(length(angle)-1):Vref;
% Vref_abs = 0:Vdc/(length(angle)-1):Vdc;

Vref_svpwm_abs = Vref*ones(1,length(angle));
Vref_abs = Vdc*ones(1,length(angle));

% Vref_SVPWM
Vref_svpwm_Point = zeros(length(angle),3);
Vref_svpwm_Point(:,1) = (Vref_svpwm_abs.*cos(angle))';
Vref_svpwm_Point(:,2) = (Vref_svpwm_abs.*sin(angle))';
Vref_svpwm_Point(:,3) = 1:1:length(angle);
% Vref_real
Vref_Point = zeros(length(angle),3);
Vref_Point(:,1) = (Vref_abs.*cos(angle))';
Vref_Point(:,2) = (Vref_abs.*sin(angle))';
Vref_Point(:,3) = 1:1:length(angle);
Vref_abs = Vref_abs';

[T1,T2,Videal_Point,Videal_abs] = SVPMW(Vref_svpwm_Point,angle,Vdc,1);
[~,~,Vreal_Point,~] = SVPMW(Vref_svpwm_Point,angle,Vdc,0.98);

Varef_Point = 2*Vref_Point(:,1)/3;
Vbref_Point = 1*Vref_Point(:,1)/3 - Vref_Point(:,2)/sqrt(3);
Vcref_Point = -1*Vref_Point(:,1)/3 - Vref_Point(:,2)/sqrt(3);

Vaideal_Point = 2*Videal_Point(:,1)/3;
Vbideal_Point = 1*Videal_Point(:,1)/3 - Videal_Point(:,2)/sqrt(3);
Vcideal_Point = -1*Videal_Point(:,1)/3 - Videal_Point(:,2)/sqrt(3);


Vareal_Point = 2*Vreal_Point(:,1)/3;
Vbreal_Point = 1*Vreal_Point(:,1)/3 - Vreal_Point(:,2)/sqrt(3);
Vcreal_Point = -1*Vreal_Point(:,1)/3 - Vreal_Point(:,2)/sqrt(3);

T = T1+T2;

%% Display
figure(1)
h1 = plot3(Vref_Point(:,1),Vref_Point(:,2),Vref_Point(:,3));
hold on
h2 = plot3(Videal_Point(:,1),Videal_Point(:,2),Videal_Point(:,3));
hold on
h3 = plot3(Vreal_Point(:,1),Vreal_Point(:,2),Vreal_Point(:,3));
legend('参考电压矢量','理想电压矢量','限幅电压矢量');
title('电压矢量图');

% figure(2)
% plot(Vref_svpwm_abs);
% hold on
% plot(Videal_abs);

figure(3)
plot(Varef_Point);
hold on
plot(Vaideal_Point);
hold on
plot(Vareal_Point);
legend('参考电压矢量','理想电压矢量','限幅电压矢量');
title('A相电压');


figure(4)
plot(Vbref_Point);
hold on
plot(Vbideal_Point);
hold on
plot(Vbreal_Point);
legend('参考电压矢量','理想电压矢量','限幅电压矢量');
title('B相电压');


figure(5)
plot(Vcref_Point);
hold on
plot(Vcideal_Point);
hold on
plot(Vcreal_Point);
legend('参考电压矢量','理想电压矢量','限幅电压矢量');
title('C相电压');




%% Function
function [T1,T2,Vreal,Vreal_abs]=SVPMW(Vref,theta,Vdc,Vdc_k)
    [sm,sn] = size(Vref);
    Vreal = zeros(sm,sn);
    Vreal_abs = zeros(sm,1);
    theta_ = mod(theta,pi/3);
    N = fix(theta/(pi/3));
    T1 = zeros(sm,1);
    T2 = zeros(sm,1);
    for i = 1:sm
        Vref_abs = sqrt((Vref(i,1))^2+(Vref(i,2))^2);
        if(mod(N(i),2)==0)
            T1(i) = sqrt(3)*Vref_abs/(Vdc)*sin(pi/3-theta_(i));
            T2(i) = sqrt(3)*Vref_abs/(Vdc)*sin(theta_(i)); 
        else
            T2(i) = sqrt(3)*Vref_abs/(Vdc)*sin(pi/3-theta_(i));
            T1(i) = sqrt(3)*Vref_abs/(Vdc)*sin(theta_(i));
        end
        if((T1(i)+T2(i))>(1+1e-9))
            T1(i) = T1(i)/(T1(i)+T2(i));
            T2(i) = T2(i)/(T1(i)+T2(i));
        end
        if(mod(N(i),2)==0)
            Vreal_abs(i) = sqrt((T1(i)+T2(i)/2)^2+(sqrt(3)*T2(i)/2)^2)*Vdc*Vdc_k;
        else
            Vreal_abs(i) = sqrt((T2(i)+T1(i)/2)^2+(sqrt(3)*T1(i)/2)^2)*Vdc*Vdc_k;
        end
        Vreal(i,1) = Vreal_abs(i)*cos(theta(i));
        Vreal(i,2) = Vreal_abs(i)*sin(theta(i));
        Vreal(i,3) = i;
    end
end

function [T1,T2,Vreal,Vreal_abs] = SVPWM_Over(Vref,theta,Vdc)
    [sm,sn] = size(Vref);
    Vreal = zeros(sm,sn);
    Vreal_abs = zeros(sm,1);
    theta_ = mod(theta,pi/3);
    N = fix(theta/(pi/3));
    T1 = zeros(sm,1);
    T2 = zeros(sm,1);
    for i = 1:sm
        Vref_abs = sqrt((Vref(i,1))^2+(Vref(i,2))^2);
        if(mod(N(i),2)==0)
            T1(i) = sqrt(3)*Vref_abs/(Vdc)*sin(pi/3-theta_(i));
            T2(i) = sqrt(3)*Vref_abs/(Vdc)*sin(theta_(i)); 
        else
            T2(i) = sqrt(3)*Vref_abs/(Vdc)*sin(pi/3-theta_(i));
            T1(i) = sqrt(3)*Vref_abs/(Vdc)*sin(theta_(i));
        end
        if((T1(i)+T2(i))>(1+1e-9))
            T1(i) = T1(i)/(T1(i)+T2(i));
            T2(i) = T2(i)/(T1(i)+T2(i));
        end
        if(mod(N(i),2)==0)
            Vreal_abs(i) = sqrt((T1(i)+T2(i)/2)^2+(sqrt(3)*T2(i)/2)^2)*Vdc*Vdc_k;
        else
            Vreal_abs(i) = sqrt((T2(i)+T1(i)/2)^2+(sqrt(3)*T1(i)/2)^2)*Vdc*Vdc_k;
        end
        Vreal(i,1) = Vreal_abs(i)*cos(theta(i));
        Vreal(i,2) = Vreal_abs(i)*sin(theta(i));
        Vreal(i,3) = i;
    end
end























