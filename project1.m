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
Q=eye(2)*2;
Qf=Q;
R=0.25;
[K,S,E] = dlqr(Ad,Bd,Q,R);

%% Stabilità ciclo chiuso
Ad_chiuso=Ad-Bd*K;
autovalori_discreto_chiuso=abs(eig(Ad_chiuso));
sysd_chiuso=ss(Ad_chiuso,Bd,C,D,campionamento);
figure(2);
initial(sysd_chiuso,x(:,1),orizzonte);


%% seno
x = 1:0.1:10;
y = zeros(1,length(x));
for i=1:length(x)
    y(i) = 4*sin(2*x(i)+10);
end

figure(3);
plot(x,y);


%% grafico a mano
Y = zeros(2,orizzonte);
X = zeros(2,orizzonte);
U = zeros(2,orizzonte - 1);
X(:,1) = [0 1]';

for i=1:orizzonte-1
    Y(:,i) = C*X(:,i);
    X(:,i+1) = A*X(:,i);
end
figure(4);
plot(1:orizzonte,Y(1,:));
figure(5);
plot(1:orizzonte,Y(2,:));

