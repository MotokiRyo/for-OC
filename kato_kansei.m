%��File �w������D�@name:pstabrk_hasei.m
%Power system stability analysis with Runge\Kutta method
%�_���s���O����
close all;
x=zeros(2,4);%��ԕϐ���\��2�����x�N�g���̒�`
             %x1:��[rad]
             %x2:w[rad/s]
x(1,1)=0.368;%[rad]
x(2,1)=0.0;%[rad/s]
             
             
dxdt=zeros(2,4);%��ԕϐ��̔����ldx/dt��\��2�����x�N�g��
a=zeros(2,2);
b=zeros(2,1);


tend=15.0;%�V�~�����[�g����
dt=0.01;%���ݎ���
tc=0.20;%�̏�p������

ts=6.0;%���ȊJ�n����


%��H�萔
%L=0.1;
%C=0.001;
%R=10.0;
%e0=100.0;
%f0=50.0;
A_pre=1.588;
A_in=0.0;
A_past=1.588;

M=1/37.7;
w0=2.0*pi()*60;
Pm=0.8;
D=M/4;
A=A_pre;

%���I�V�~�����[�V�����̊J�n
t=0.0;%�V�~�����[�V�����̊J�n����

it=1;

while t<=tend
    
    outvar(it,1)=tc;
    outvar(it,2)=t;%�o�͗p�z��outvar��1��ڂɎ���t����
   
        outvar(it,3)=x(1,1)*180/pi;%�o�͗p�z��outvar��2,3��ڂ�x1,x2����
        outvar(it,4)=x(2,1)/(2*pi);
   
    
    %�����Q�N�b�^�@�ɂ������������̐��l�v�Z
    
    %�s��A�̍쐬
    
    
    if ts<t && t<(ts+tc)   %���̊J�n��
    a(1,2)=1.0;
    a(2,1)=-A/M;
    b(2,1)=Pm/M;
        
    elseif tc+ts<t     %���̏�����
        
    Pm=Pm*1.0008;%1.1�Ŕ��U    
        
    a(1,2)=1.0;
    a(2,1)=-A/M;
    a(2,2)=-D/M;
    b(2,1)=(Pm+D)/M;
    
    else         %���̑O
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
    
    if ts<t && t<(ts+tc)         %���̊J�n��
        A=A_in;
        
    elseif tc+ts<t     %���̏�����
        A=A_past;
        
    end
   
end
%�o�͔z��poutvar���G�N�Z���t�@�C���֏�������
xlswrite('output_data_kato',outvar,1,'P1');





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






