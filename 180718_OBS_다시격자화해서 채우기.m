%% ���ð��а� OBS
% ������ �Ÿ�����ġ �༭ ����ȭ�ؼ� �ڷ� �̱�

% n_year
% 1: n day
% 2: start
% 3: end
% 4: 0
% 5: 0

% time
% 1: year
% 2: ���� year (year-1984)
% 3: month
% 4: day
% 5: summer (1)

% a_city/ a_stn
% 1: longitude
% 2: latitude
% a_city1 = min(a_city(:,1));
% a_city2 = max(a_city(:,1));
% a_city3 = min(a_city(:,2));
% a_city4 = max(a_city(:,2));
%     a_city1 = (a_city2 - a_city1)/230;
%     a_city2 = (a_city4 - a_city3)/230;
%     clear a_city3 a_city4
% 0.01�� �������� �ؾ���


% �����갪 �ٽ� ���ϱ� (n_year�̿�)
s_stn = zeros(33,100);
for i = 1:33
    temp1 = n_year(i,2);
    temp2 = n_year(i,3);
    for j = 1:100
        s_stn(i,j) = sum(OBS_stn_raw(temp1:temp2,j+1));
    end
end
clear i j temp1 temp2

% �������� ���� �����ڷ� �����ϰ�, ����ȭ�ؼ� OBS_city �����
x = 125.67:0.02:130.86;
y = 33.32:0.02:38.38;
[XI, YI] = meshgrid(x,y);
 %���� ����� �ּ� x,y ã�Ƶα�
a_city(:,3) =0;
a_city(:,4) =0;
for i = 1:230
    temp1 = zeros(260,1);
    temp2 = zeros(254,1);
    for j = 1:260
        temp1(j,1) = (x(1,j)-a_city(i,1))^2;
    end
    clear j
    [a b] = min(temp1(:,1));
    a_city(i,3) = b;
    for j = 1:254
        temp2(j,1) = (y(1,j)-a_city(i,2))^2;
    end
    clear j
    [a b] = min(temp2(:,1));    
    a_city(i,4) = b;
end
clear i temp1 temp2 a b

OBS_city = zeros(12053,230);
for i = 1:33
    i
    temp = 0;
    temp1 = n_year(i,2);
    temp2 = n_year(i,3);
    for j = 1:100
        if s_stn(i,j)>600
            temp = temp+1;
        end
    end
    clear j
    b_grid = zeros(temp,4);
        %1: a_stn1
        %2: a_stn2
        %3: OBS
        %4: n_stn (�����ƴ� ����Ʈ ������ȣ!!)
    temp=0;
    for j = 1:100
        if s_stn(i,j)>600
            temp = temp+1;
            b_grid(temp,1) = a_stn(j,1);
            b_grid(temp,2) = a_stn(j,2);
            b_grid(temp,4) = j;
        end
    end
    clear j
    for j = temp1:temp2 %�Ϸ翡 �ѹ��� ����ȭ
        for k = 1:temp
            b_grid(k,3) = 0;
            b_grid(k,3) = OBS_stn_raw(j,b_grid(k,4)+1);
        end
        clear k
        % gridding
        ZI = griddata(b_grid(:,1),b_grid(:,2),b_grid(:,3),XI,YI,'v4'); %1�� ����ȭ ���
        % ����� �� �̾Ƽ� ä��� 
        for k = 1:230
            if ZI(a_city(k,4),a_city(k,3))>0.5
                OBS_city(j,k) = ZI(a_city(k,4),a_city(k,3));
            end
        end
        clear k
    end
    clear j temp1 temp2 ZI
end
clear i


