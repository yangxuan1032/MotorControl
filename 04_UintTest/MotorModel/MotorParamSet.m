%%
close all
clear
clc

%%
% Model Simulation Base Step
SimBaseStep = 5e-5;



%% Motor Machine Parameters
% Motor Dynamic Parameters
MotorSim_Machine_J = 0;
MotorSim_Machine_Damp = 0;
MotorSim_Machine_Tf = 0;
MotorSim_Machine_Tf_Static = 0;
MotorSim_Machine_TL_Input = 0;
MotorSim_Machine_WindFric = 0;
MotorSim_Machine_WM_Init = 0;
MotorSim_Machine_WE_Init = 0;
MotorSim_Machine_ThetaM_Init = 0;
MotorSim_Machine_ThetaE_Init = 0;
% Motor Structure Parameters
MotorSim_Machine_Solts = 0;
MotorSim_Machine_Poles = 0;
MotorSim_Machine_WindingType = 1;
    
%% Motor Magnetice Parameters

% Motor Permanent magnets Parameters

% Motor Winding Parameters

%% Motor Electric Parameters

% Motor Three Phase Electric Parameters
MotorSim_Electric_TP_Ra = 0;
MotorSim_Electric_TP_Rb = 0;
MotorSim_Electric_TP_Rc = 0;
% Motor Alpha-Beta Phase Electric Parameters

% Motor D-Q Phase Electric Parameters


