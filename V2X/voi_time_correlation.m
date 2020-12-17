% Value of Information with Time correlation

% The script devises the schedule for v2x communication by taking into
% account the value of information provided by the different camera sensors
% on the car as well as the correlation over time between the packets sent out by
% each sensor.

% Size of the packets in bits
size = 8*[1300, 180, 180, 140, 140];
% Capacity of the channel in kbps
C = 20000:5000:120000;
% Number of objects created by the sensors per second
num_of_objs = [10,10,10,10,10];
% Total number of objects to be sent out over the 10000 timesteps
total_num_of_objs = 10000*num_of_objs;
% Compensation for the time correlation metric
comp = 100;
final_result4 = {};
pkts_sent4 = zeros(length(C),5);
y4 = [];
% Running the script for each capacity values
for it=1:length(C)
%   Value of information vector predefined by the application
    v = [1, 0.7, 0.7, 0.4, 0.4];
%   Correlation Matrix between different sensors as predefined by the application  
    W = [1 0.7 0.7 0.7 0.7; 0.7 1 0 0.5 0.5; 0.7 0 1 0 0; 0.7 0.5 0 1 0.1; 0.7 0.5 0 0.1 1];
    p = 1;
    w = 0;
    objs_to_be_txs = zeros(1,5);
    result4 = [];
    sizes4 = [];
    seq4 = {};
    total = C(it);
    final_size = inf;
    new_v = v;
    last_sent = ones(1,5);
%   Run the scheduling algorithm over 10000 timesteps
    for index=1:10000
        w = 0;
        s = [];
        final_size = 0;
        size_final = 0;
        rem_num_of_objs = num_of_objs;
        while final_size < total
            temp = new_v;
            [maximum, ind] = max(temp);
            if (ind == 2 || ind == 3)
                t_ind = randperm(2,1);
                if t_ind == 1
                    ind = 2;
                end
                if t_ind == 2
                    ind = 3;
                end
            end
            if (ind == 4 || ind == 5)
                t_ind = randperm(2,1);
                if t_ind == 1
                    ind = 4;
                end
                if t_ind == 2
                    ind = 5;
                end
            end
            while (rem_num_of_objs(ind) == 0)
                check = rem_num_of_objs ~= 0;
                if sum(check) > 1
                    temp(ind) = -inf;
                    [m,ind] = max(temp);
                else
                    ind = find(rem_num_of_objs);
                    break;
                end
                
            end
            if final_size+size(ind) > total
                break;
            else
                s = [s ind];
                rem_num_of_objs(ind) = rem_num_of_objs(ind) - 1;
                pkts_sent4(it,ind) = pkts_sent4(it,ind) + 1;
                p = ind;
                last_sent(p) = index;
                temp2 = timeliness(last_sent);
                new_v = new_v + (temp2/comp);
                final_size = final_size +size(ind);
            end
            
            
        end
%       Update the value of information for the time correlated packets
        if any(index == last_sent+10)
            ch = index == last_sent+10;
            new_v(ch) = v(ch);
            rem_num_of_objs(ch) = 0;
        end
        objs_to_be_txs = rem_num_of_objs;
%       Calculate the value of information for the schedule defined 
        for k=1:length(s)-1
            if s(k) == s(k+1)
                w = w + 0;
            else
                w = w+(1-W(s(k),s(k+1)))*v(s(k))*v(s(k+1));
            end
            size_final = size_final + size(s(k));
        end
        result4(index) = w;
        sizes4(index) = final_size;
        seq4{index} = s;
        
    end
    final_result4{it} = result4;
    y4(it) = mean(result4);
    
end
