%% 系统仿真参数配置
% 创建人：      杨晅
% 创建时间：    2024.05.01
% 版本：        V0.0.1                    
% 更新记录：       
% 
%%
clear 
close all
clc

%% 仿真时间参数
% 模型全局仿真时间基础步长 单位：s
MC_Sim_BaseStep = 5e-8;
% 模型全局仿真时间基础步长 单位：s
MC_Sim_HighFrequenceStep = 5e-5;
% 模型全局仿真时间基础步长 单位：s
MC_Sim_MediumFrequenceStep = 2e-3;


% 模型全局仿真时间基础步长 单位：s
MC_Sim_Compele_Fre = 500;

%% 硬件参数
% % 电机硬件模型-> 1：数学模型 2：物理模型
% MC_Hardware_Motor_Model = 1;
% 电机硬件绕组模型-> 1：星型绕组 2：三角绕组
MC_Hardware_MotorWind_Model = 1;
% % 电机硬件MOS模型-> 1：集成模型 2：自建模型
% MC_Hardware_MotorMOS_Model = 1;

% 转子极对数
MC_Hardware_Motor_Rotor_Pn = 4;
% 电机转子反电势定值角度值
MC_Hardware_Motor_Rotor_BEMFCanstAngle = pi/(2*MC_Hardware_Motor_Rotor_Pn);
% 电机转子反电势常数 单位：V/kRPM
MC_Hardware_Motor_Rotor_BEMFCoff = 4.294; 
% 电机转子最大转动速度 单位：RPM
MC_Hardware_Motor_Rotor_SpeedMax = 3000; 
% 电机转子最大反电势 单位：V
MC_Hardware_Motor_Rotor_BEMFMax = MC_Hardware_Motor_Rotor_BEMFCoff*MC_Hardware_Motor_Rotor_SpeedMax*1e-3;
% 电机转子磁链 单位：Wb
MC_Hardware_Motor_Rotor_Phi = MC_Hardware_Motor_Rotor_BEMFCoff*60/(1000*2*pi*MC_Hardware_Motor_Rotor_Pn)*sqrt(3)/3;

% 电机定子D轴电感 单位：H
MC_Hardware_Motor_Stator_Ld = 5.6345e-5;
% 电机定子Q轴电感 单位：H
MC_Hardware_Motor_Stator_Lq = 5.6345e-5;
% 电机定子零序电感 单位：H
MC_Hardware_Motor_Stator_L0 = 0;
% 电机定子电阻 单位：Ohm
MC_Hardware_Motor_Stator_Rs = 2.86e-2;

% 电机机械转动惯量 单位：kg*m^2
MC_Hardware_Motor_Mechinal_Inertia = 1.03e-2;
% 电机机械转动阻尼 单位：N*m*s/rad
MC_Hardware_Motor_Mechinal_Damp = 0;
%
MC_Hardware_Motor_Mechinal_Fric = 0;
%
MC_Hardware_Motor_Mechinal_TF = 8.59e-2;

% 全桥MOS管D极与S极电阻 单位：Ohm
MC_Hardware_MOS_Rds = 1e-3;
% 全桥MOS管D极与S极电阻 单位：Ohm
MC_Hardware_MOS_OffSateConduction = 1e-6;
% 全桥MOS管G极与S极门限电压 单位：V
MC_Hardware_MOS_Threshold = 0.5;

% 全桥MOS管死区时间步长周期
MC_Hardware_MOS_DeadTimeCounter = 32;
% 全桥MOS管死区时间 单位：s
MC_Hardware_MOS_DeadTimePropotion = MC_Hardware_MOS_DeadTimeCounter*MC_Sim_BaseStep/(MC_Sim_HighFrequenceStep);

% 模型硬件直流电压源电压幅值 单位：V
MC_Hardware_Power_DC = 13.5;


% 硬件ADC采样转换时间
MC_Hardware_ADC_Ts = 0.001;
%
MC_Hardware_Sample_Rs = 1e-3;
%
MC_Hardware_Sample_VbusNoise = 1e-15;
%
MC_Hardware_Sample_CurrentNoise = 1e-15;

%% 电流环PID控制器参数

%% SVPWM参数

% SVPWM 占空比上限值
MC_SVPWM_DutyMax = 0.98 ;
% SVPWM 占空比下限值
MC_SVPWM_DutyMin = 0.02;
%
MC_SVPWM_DutyL_Comp = 0.25;
%
MC_SVPWM_DutyM_Comp = 0.5;
%
MC_SVPWM_DutyS_Comp = 0.75;



