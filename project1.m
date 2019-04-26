clear;
clc;

%% Parametri
orizzonte=10;
campionamento=0.1;
dimensione=(orizzonte/campionamento) +1;
x=zeros(2,dimensione);
u=zeros(1,dimensione-1);
x(:,1)=[0 1]';
A=[0 1; -1 0];
B=[0 1]';
C=eye(2);
D=[0 0]';
sys = ss(A,B,C,D);
sysd = c2d(sys,campionamento);
Ad=sysd.A;
Bd=sysd.B;

%% Stabilità
autovalori_continuo=eig(A);
autovalori_discreto=abs(eig(sysd.A));
figure(1);
initial(sysd,x(:,1),orizzonte);

%% Ottimizzazione
Q=eye(2);
Qf=Q;
R=1;
[K,S,E] = dlqr(Ad,Bd,Q,R);

%% Stabilità ciclo chiuso
Ad_chiuso=Ad-Bd*K;
autovalori_discreto_chiuso=abs(eig(Ad_chiuso));
sysd_chiuso=ss(Ad_chiuso,Bd,C,D,campionamento);
figure(2);
initial(sysd_chiuso,x(:,1),orizzonte);



