function v = timeliness(t1, t2)
P_td = 1;
v1 = exp(-P_td.*t1);
v2 = 1-exp(-t2);
v = 1-exp(-v1*v2);
return