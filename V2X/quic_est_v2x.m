% QUIC-EST (Value of Information with Sensor and Time Correlation)

% The script devises the schedule for v2x communication by taking into
% account the value of information provided by the different camera sensors
% on the car as well as the correlation of the packets between different
% sensors and correlation over time between the packets sent out by
% each sensor.

% Size of the packets in bits
size = 8*[1300, 180, 180, 140, 140];
% Capacity of the channel in kbps
C = 20000:5000:120000;
% Number of objects created by the sensors per second
num_of_objs = [10,10,10,10,10];
% Total number of objects to be sent out over the 10000 timesteps
total_num_of_objs = 1000*num_of_objs;
comp = 1;
final_result = {};
pkts_sent = zeros(length(C),5);
y = [];
% Running the script for each capacity values
for it=1:length(C)
%   Value of information vector predefined by the application
    v = [1, 0.7, 0.7, 0.4, 0.4];
%   Correlation Matrix between different sensors as predefined by the application
    W = [1 0.7 0.7 0.7 0.7; 0.7 1 0 0.5 0.5; 0.7 0 1 0 0; 0.7 0.5 0 1 0.1; 0.7 0.5 0 0.1 1];
    p = 0;
    w = 0;
    objs_to_be_txs = zeros(1,5);
    result = [];
    sizes = [];
    seq = {};
    total = C(it);
    new_v = v;
    last_sent = ones(1,5);
%   Run the scheduling algorithm over 10000 timesteps
    for index=1:1000
        w = 0;
        s = [];
        final_size = 0;
        size_final = 0;
        rem_num_of_objs = num_of_objs;
        while final_size < total
            for i=1:length(new_v)
                for j=1:length(new_v)
                    r(i,j) = new_v(i) + new_v(j) - (W(i,j)*new_v(j));
                end
            end
            [maximum, indices] = max(r);
            if (p == 0)
                temp_pkt = mode(indices);
            else
                temp = r(p,:);
                [m,ind] = max(temp);
                
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
                temp_pkt = ind;
                
            end
            if final_size+size(temp_pkt) > total
                break;
            else
                p = temp_pkt;
                s = [s temp_pkt];
                last_sent(p) = index;
                temp2 = timeliness(last_sent);
                new_v = new_v+(temp2/comp);
                final_size = final_size +size(temp_pkt);
                rem_num_of_objs(temp_pkt) = rem_num_of_objs(temp_pkt) - 1;
                pkts_sent(it,temp_pkt) = pkts_sent(it,temp_pkt) + 1;
            end
            
            
        end
%       Update the value of information for the time correlated packets
        if any(index == last_sent+10)
            ch = index == last_sent+10;
            new_v(ch) = v(ch);
            rem_num_of_objs(ch) = 0;
        end
%       Calculate the value of information for the schedule defined
        for k=1:length(s)-1
            if s(k) == s(k+1)
                w = w + 0;
            else
                w = w +(1-W(s(k),s(k+1)))*v(s(k))*v(s(k+1));
            end
            size_final = size_final + size(s(k));
        end
        result(index) = w;
        sizes(index) = size_final;
        seq{index} = s;
        
    end
    final_result{it} = result;
    y(it) = mean(result);
end

