clear;
clc;

%% Parametri
orizzonte=10;
campionamento=0.1;
dimensione=(orizzonte/campionamento) +1;
x0=[0 1]';
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
initial(sysd,x0,orizzonte);

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
initial(sysd_chiuso,x0,orizzonte);


%% seno
x = 1:0.1:10;
y = zeros(1,length(x));
y_disturbato = zeros(1,length(x));
media=0;
sigma=0.5;
random=media+sigma*randn(1,length(x));

for i=1:length(x)
    y(i) = 4*sin(2*x(i)+10);
    y_disturbato(i) = y(i)+random(i);
end

figure(3);
plot(x,y,x,y_disturbato);
title("4sen(2t+10)");
legend('originale','disturbato');


%% grafico a mano
tempo=0:campionamento:orizzonte;
Y = zeros(2,orizzonte+1);
X = zeros(2,orizzonte+1);
U = zeros(2,orizzonte);
X(:,1) = [0 1]';

for i=1:orizzonte
    Y(:,i) = C*X(:,i);
    X(:,i+1) = (Ad-Bd*K)*X(:,i);
end
Y(:,orizzonte+1) = C*X(:,orizzonte+1);
figure(4);
subplot(2,1,1);
y=interp1(Y(1,:),tempo);
stairs(tempo(1,:),y);
title('y1');

subplot(2,1,2);
y=interp1(Y(2,:),tempo);
stairs(tempo(1,:),y);
title('y2');

