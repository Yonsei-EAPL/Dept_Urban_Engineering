RCP(1:7305,:)=[]; % remove 2000-2019

% % n_year (from 2020 to 2100, 81 year)
% 1: start
% 2: end

% % time열 만들기
time_raw = RCP(:,1);
RCP(:,1)=[];

time= zeros(29585,5);
% (1)실제 연, (2)순서 연, (3)월, (4)일, (5)여름유무
for i = 1:29585
    time(i,1) = (time_raw(i,1)-mod(time_raw(i,1),10000))/10000;
    time(i,2) = time(i,1)-2019;
    time(i,3) = mod(time_raw(i,1),10000);
    time(i,4) = mod(time(i,3),100);
    time(i,3) = (time(i,3) - mod(time(i,3),100))/100;
    if (time(i,3)>=6)&&(time(i,3)<=8)
        time(i,5) = 1;
    end
end
clear i
clear time_raw

var1 = zeros(81,230); % 80mm초과일 평균강수량
var2 = var1; % 80mm초과일수
var3 = var1; % 최대5일누적강수
var4 = var1; % 전체10%의 연별강수비율
var5 = var1; % 여름누적강수
var6 = var1; % 최대일강수
var7 = var1; % 누적강수



%% var7 연누적강수량
for i = 1:81
    temp1 = n_year(i,1);
    temp2 = n_year(i,2);
    for j = 1:230
        var7(i,j) = sum(RCP(temp1:temp2,j));
    end
    clear j
end
clear i temp1 temp2

%% var6 연최대일강수량
for i = 1:81
    temp1 = n_year(i,1);
    temp2 = n_year(i,2);
    for j = 1:230
        var6(i,j) = max(RCP(temp1:temp2,j));
    end
    clear j
end
clear i temp1 temp2

%% var1,2,5 
for i = 1:81
    temp1 = n_year(i,1);
    temp2 = n_year(i,2);
    for j = temp1:temp2
        for k = 1:230
            if RCP(j,k)>80
                var2(i,k) = var2(i,k)+1;
                var1(i,k) = var1(i,k)+RCP(j,k);
            end
            if time(j,5)==1
                if RCP(j,k)>0
                    var5(i,k) = var5(i,k)+RCP(j,k);
                end
            end
        end
        clear k
    end
    clear j
end
clear i temp1 temp2
for i =1:81
    for j = 1:230
        if var2(i,j)>0
            var1(i,j) = var1(i,j)/var2(i,j);
        end
    end
end
clear i j

%% var3
for i = 1:81
    temp1 = n_year(i,1);
    temp2 = n_year(i,2);
    for j = 1:230
        temp3=0;
        for k = temp1:temp2
            if (k-temp1)>=4
                temp3 = RCP(k,j)+RCP(k-1,j)+RCP(k-2,j)+RCP(k-3,j)+RCP(k-4,j);
                if temp3>var3(i,j)
                    var3(i,j)=temp3;
                    temp3=0;
                end
            end
        end
    end
end
clear i j k temp1 temp2 temp3

%% var4
for i =1:230
    temp3 = zeros(29585,3);
    temp3(:,1) = RCP(:,i); % 일강수량
    temp4=0; % total 강수일수
    for j = 1:29585
        temp3(j,2) = j; % 원래순서 기록
        if temp3(j,1)>0
            temp4 = temp4+1;
        end
    end
    clear j
    temp3 = sortrows(temp3,-1);
    for j = 1:29585
        if j<=temp4/10
            temp3(j,3) = 1; % 10% tag
        end
    end
    clear j
    temp3 = sortrows(temp3,2);

    for j =1:81
        temp1 = n_year(j,1);
        temp2 = n_year(j,2);
        for k = temp1:temp2
            if temp3(k,3)==1
                var4(j,i) = var4(j,i)+ temp3(k,1);
            end
        end
        clear k
        var4(j,i)= var4(j,i)/var7(j,i);
    end
    clear j
end
clear i temp1 temp2 temp3 temp4
