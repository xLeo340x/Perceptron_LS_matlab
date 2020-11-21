clear variables;
clc;
close all;

% in=imread('train/000002-num4.png');

i=60000; %%% Число от 1 до 59999

[Num,inpu(:)]=inputting(i);
target(:)=zeros(1,10);
target(Num)=1;

inpu=[inpu./256, ones(size(inpu,1),1)];
in=inpu;



N=readmatrix('N.xls');

for i=1:1:N-1
    s=strcat('weight',num2str(i),'.xls');
    weight{i}=readmatrix(s);
end

j=0;
% for y=1:3:size(in,1)
%     for x=1:3:size(in,2)
%         j=j+1;
%         Im(j)=double(in(y,x));
%     end
% end

% Im=[Im./256, ones(size(Im,1),1)];
sloy{1}=in;
sloy=circle(sloy,weight,N);
(sloy{end});

for i=1:10
    if round(sloy{end}(i))==1
        disp(['Сеть вывела: ',num2str(i)])
    end
end

for i=1:10
    if round(target(i))==1
        disp(['Сеть должна вывести: ',num2str(i)])
    end
end

k=1;
for i=1:1:14
    for j=1:1:14
        AAA(i,j)=sloy{1}(k);
        k=k+1;
    end
end
imagesc(AAA)

function f=activ(aaa)

f=1./(1 + exp(-aaa));

end

function sloy=circle(sloy,weight,N)
for i=1:1:N-1
    sloy{i+1}=activ(sloy{i}*weight{i}');
end
end










