 %ADRC-ord1-3SISO
%clear

Ts=0.01;
Tsim=70;
t=0:Ts:Tsim-Ts;
N=Tsim/Ts;

s=tf('s');


%% procesul condus

xyz_X=[7.0118   44.1250   25.2832   99.6786    3.5961]; %cu DZ
a_X=xyz_X(1); b_X=xyz_X(2);c_X=xyz_X(3); d_X=xyz_X(4);e_X=xyz_X(5);
pCart_X=(a_X*s+b_X)/(c_X*s^2+d_X*s+e_X);
pCartd_X=c2d(pCart_X,Ts,'zoh');
num_X=pCartd_X.num{1};
den_X=pCartd_X.den{1};
DZmin_X = -0.096; DZmax_X = 0.149;

xyz_Y=[-12.9931  -41.6624  -36.8969  -98.6392    0.3006]; %cu DZ
a_T=xyz_Y(1); b_T=xyz_Y(2);c_T=xyz_Y(3); d_T=xyz_Y(4);e_T=xyz_Y(5);
pCart_Y=(a_T*s+b_T)/(c_T*s^2+d_T*s+e_T);
pCartd_Y=c2d(pCart_Y,Ts,'zoh');
num_Y=pCartd_Y.num{1};
den_Y=pCartd_Y.den{1};
DZmin_Y = -0.149; DZmax_Y = 0.128;

xyz_Z=[-14.6716  -14.1797  -99.5013  -97.4149   -0.3209]; %cu DZ
a_Z=xyz_Z(1); b_Z=xyz_Z(2);c_Z=xyz_Z(3); d_Z=xyz_Z(4);e_Z=xyz_Z(5);
pCart_Z=(a_Z*s+b_Z)/(c_Z*s^2+d_Z*s+e_Z);
pCartd_Z=c2d(pCart_Z,Ts,'zoh');
num_Z=pCartd_Z.num{1};
den_Z=pCartd_Z.den{1};
DZmin_Z = -0.032; DZmax_Z = 0.138;

%% simulare, afisarea functiei obiectiv
%sim('Crane3D')