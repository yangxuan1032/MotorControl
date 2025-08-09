%% 雨刮转速减速曲线代码仿真
% 创建人：      杨晅
% 创建时间：    2025.05.10
% 版本：        V0.0.1                    
% 更新记录：       
% 2025.05.10    采用指数函数替代位置环P环节，在接近目标位置是实现先快后慢的减速曲线
%%
clear 
close all
clc

%% Const Param
SpeedBase = 20000;  %RPM
SpeedUserReq = 40; %RPM
SpeedAngle = 225; %RPM
ThetaMax = 130;
SpeedDecle_a = 10;
SpeedDecle_b = 0.1667;
SpeedDecle_c = -(SpeedDecle_a+50);
%% FloatPoint Data 
Theta_FloatPoint = 180:-1:0;
SpeedRefMax_FloatPoint = ThetaMax*SpeedUserReq*2*3600/360/60;
SpeedRefMin_FloatPoint = 0; 
MotorSpeedRef_FloatPoint = Theta_FloatPoint*SpeedAngle;
MotorSpeedRef_FloatPoint(MotorSpeedRef_FloatPoint>SpeedRefMax_FloatPoint) = SpeedRefMax_FloatPoint;
MotorSpeedRef_FloatPoint(MotorSpeedRef_FloatPoint<SpeedRefMin_FloatPoint) = SpeedRefMin_FloatPoint;
SpeedRefDecle_FloatPoint = SpeedDecle_a*2.^(Theta_FloatPoint.*SpeedDecle_b) + SpeedDecle_c;
SpeedRefDecle_FloatPoint(SpeedRefDecle_FloatPoint>SpeedRefMax_FloatPoint) = SpeedRefMax_FloatPoint;
SpeedRefDecle_FloatPoint(SpeedRefDecle_FloatPoint<SpeedRefMin_FloatPoint) = SpeedRefMin_FloatPoint;

%% FixedPoint Data 
Theta_FixedPoint = 32768:-1:0;
SpeedRefMax_FixedPoint = int32(ThetaMax*SpeedUserReq*2*3600/360/60/SpeedBase*32768);
SpeedRefMin_FixedPoint = int32(0);
MotorSpeedRef_FixedPoint = int32(Theta_FixedPoint*SpeedAngle*180/32768/SpeedBase*32768);
MotorSpeedRef_FixedPoint(MotorSpeedRef_FixedPoint>SpeedRefMax_FixedPoint) = SpeedRefMax_FixedPoint;
MotorSpeedRef_FixedPoint(MotorSpeedRef_FixedPoint<SpeedRefMin_FixedPoint) = SpeedRefMin_FixedPoint;

SpeedRefDecle_FixedPoint = int32((SpeedDecle_a*(2.^int32(Theta_FixedPoint.*31/32768)) + SpeedDecle_c)/SpeedBase*32768);

SpeedRefDecle_FixedPoint(SpeedRefDecle_FixedPoint>SpeedRefMax_FixedPoint) = SpeedRefMax_FixedPoint;
SpeedRefDecle_FixedPoint(SpeedRefDecle_FixedPoint<SpeedRefMin_FixedPoint) = SpeedRefMin_FixedPoint;

%%
figure(1)
plot(Theta_FloatPoint,MotorSpeedRef_FloatPoint);
hold on
plot(Theta_FloatPoint,SpeedRefDecle_FloatPoint);
legend("PoseLoop","SpeedDecle");

figure(2)
plot(Theta_FixedPoint,MotorSpeedRef_FixedPoint);
hold on
plot(Theta_FixedPoint,SpeedRefDecle_FixedPoint);
legend("PoseLoop","SpeedDecle");



















