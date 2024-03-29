%元File 学生実験D　name:pstabrk_hasei.m
%Power system stability analysis with Runge\Kutta method
%ダンピングあり
close all;

prompt = {'k'};
title = ' k の値は？';
numlines = 1;  % 1行分の入力欄
Answer = inputdlg(prompt, title, numlines);
alpha = 1.0002 + (str2double(Answer{1})/100000);

x=zeros(2,4);%状態変数を表す2次元ベクトルの定義
             %x1:δ[rad]
             %x2:w[rad/s]
x(1,1)=0.368;%[rad]
x(2,1)=0.0;%[rad/s]
             
             
dxdt=zeros(2,4);%状態変数の微分値dx/dtを表す2次元ベクトル
a=zeros(2,2);
b=zeros(2,1);


tend=15.0;%シミュレート時間
dt=0.01;%刻み時間
tc=0.20;%故障継続時間

ts=6.0;%自己開始時間

A_pre=1.588;
A_in=0.0;
A_past=1.588;

M=1/37.7;
w0=2.0*pi()*60;
Pm=0.8;
D=M/4;
A=A_pre;

%動的シミュレーションの開始
t=0.0;%シミュレーションの開始時間

it=1;

while t<=tend
    
    outvar(it,1)=tc;
    outvar(it,2)=t;%出力用配列outvarの1列目に時刻tを代入
    outvar(it,3)=x(1,1)*180/pi;%出力用配列outvarの2,3列目にx1,x2を代入
    outvar(it,4)=x(2,1)/(2*pi);
   
    
    %ルンゲクッタ法による微分方程式の数値計算
    
    %行列Aの作成
    
    
    if ts<t && t<(ts+tc)   %事故開始時
    a(1,2)=1.0;
    a(2,1)=-A/M;
    b(2,1)=Pm/M;
        
    elseif tc+ts<t     %事故除去後
        
    Pm=Pm * alpha;%1.1で発散    
        
    a(1,2)=1.0;
    a(2,1)=-A/M;
    a(2,2)=-D/M;
    b(2,1)=(Pm+D)/M;
    
    else         %事故前
    a(1,2)=1.0;
    a(2,1)=-A/M;
    b(2,1)=Pm/M;
        
    end
    
    for j=1:4
        if j==1
             dxdt(1,j)=a(1,1)*x(1,j)+a(1,2)*x(2,j)+b(1,1);
             dxdt(2,j)=a(2,1)*sin(x(1,j))+a(2,2)*x(2,j)+b(2,1);
            for i=1:2
                    x(i,j+1)=x(i,1)+dxdt(i,j)*dt/2.0;
            end
            
        elseif j==2
             dxdt(1,j)=a(1,1)*x(1,j)+a(1,2)*x(2,j)+b(1,1);
             dxdt(2,j)=a(2,1)*sin(x(1,j))+a(2,2)*x(2,j)+b(2,1);
            for i=1:2
                    x(i,j+1)=x(i,1)+dxdt(i,j)*dt/2.0;
            end
        
        elseif j==3
             dxdt(1,j)=a(1,1)*x(1,j)+a(1,2)*x(2,j)+b(1,1);
             dxdt(2,j)=a(2,1)*sin(x(1,j))+a(2,2)*x(2,j)+b(2,1);
            for i=1:2
                    x(i,j+1)=x(i,1)+dxdt(i,j)*dt;
            end
            
        elseif j==4
            dxdt(1,j)=a(1,1)*x(1,j)+a(1,2)*x(2,j)+b(1,1);
            dxdt(2,j)=a(2,1)*sin(x(1,j))+a(2,2)*x(2,j)+b(2,1);
        end
    end
    
    for i=1:2
        x(i,1)=x(i,1)+(dxdt(i,1)+2.0*(dxdt(i,2)+dxdt(i,3))+dxdt(i,4))*dt/6.0;
    end
    it=it+1;
    t=t+dt;
    
    if ts<t && t<(ts+tc)         %事故開始時
        A=A_in;
        
    elseif tc+ts<t     %事故除去後
        A=A_past;
        
    end
   
end

f1 = figure('Name','Phaze','NumberTitle','off');
h = animatedline;
axis([0,14,-150,150])


f2 = figure('Name','Frequency','NumberTitle','off');
Hh = animatedline;
axis([0,14,-2,2])

x = linspace(0,14,1400);

for j=1:1400
    y(j)=outvar(j,3);
    z(j)=outvar(j,4);
end

for k = 1:length(x)
    addpoints(h,x(k),y(k));
    addpoints(Hh,x(k),z(k));
    drawnow
end







