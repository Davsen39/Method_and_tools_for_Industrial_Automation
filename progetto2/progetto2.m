clear;
clc;

%% parametri
alphabet=('A':'Z')';
num_job = xlsread("progetto2.xlsx","sheet1","B1");
num_constraints = xlsread("progetto2.xlsx","sheet1","B2");

J=(1:num_job)';
p=xlsread("progetto2.xlsx","sheet1",strcat("E2:",alphabet(5+num_job),"2"))';
d=xlsread("progetto2.xlsx","sheet1",strcat("E3:",alphabet(5+num_job),"3"))';
w=xlsread("progetto2.xlsx","sheet1",strcat("E4:",alphabet(5+num_job),"4"))';
constraints=xlsread("progetto2.xlsx","sheet1",strcat("A5:B",num2str(5+num_constraints)));

X0=0;

for i=1:num_job 
    X{i}=combnk(1:num_job,i);
end


%passo num_job;
stati(num_job)=size(X{num_job},1);
Go{num_job}=0;

%passo k=num_job-1...3,2,1;
for k=num_job-1:-1:1
    stati(k)=size(X{k},1); %numero di set per stato
    G{k}=10000*ones(stati(k),stati(k+1));
    for i=1:stati(k)
        start_time=durata(X{k}(i,:),p); % somma di processing time del set scelto
        for j=1:stati(k+1)
            if ismember(X{k}(i,:),X{k+1}(j,:)) % se è subset?
                controllo(i,j)=setdiff(X{k+1}(j,:),X{k}(i,:)); % elemento aggiuntivo nello stadio successivo
                G{k}(i,j)=Go{k+1}(j)+max((start_time+p(controllo(i,j))-d(controllo(i,j)))/num_job,0);
            end
        end
        Go{k}(i)=min(G{k}(i,:));
    end
end

%passo 0;
for i=1:length(J)
    G0(i)=Go{1}(i)+max((p(X{1}(i))-d(X{1}(i)))/num_job, 0);
end

Go0=min(G0);
