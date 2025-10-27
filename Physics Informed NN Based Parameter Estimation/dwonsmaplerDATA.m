clc
clear all
close all
%%
load('LBC_vq_F_IPMSM.mat')
load('LBC_vd_F_IPMSM.mat')
load('LBC_time_F_IPMSM.mat')
load('LBC_omega_e_F_IPMSM.mat')
load('LBC_iq_F_IPMSM.mat')
load('LBC_id_F_IPMSM.mat')
%%
n=100;
LBC_id=downsample(LBC_id,n);
LBC_iq=downsample(LBC_iq,n);
LBC_vq=downsample(LBC_vq,n);
LBC_vd=downsample(LBC_vd,n);
LBC_time=downsample(LBC_time,n);
LBC_omega_e=downsample(LBC_omega_e,n);
