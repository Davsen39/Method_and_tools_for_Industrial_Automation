clear;
clc;

orizzonte=100;
campionamento=0.1;
dimensione=(orizzonte/campionamento) +1;
x=zeros(2,dimensione);
u=zeros(1,dimensione-1);
x(:,1)=[0 1]';
A=[-1 0; 0 1];
B=[1 0]';
C=eye(2);
D=[0 0]';
sys = ss(A,B,C,D);
sysd = c2d(sys,campionamento);

autovalori_continuo=eig(A);
autovalori_discreto=eig(abs(sysd.A));

initial(sysd,x(:,1),orizzonte);
%tempo=0:campionamento:orizzonte;
%setpoint=10-ones(1,dimensione);
%errore=x(1)-setpoint(1);


