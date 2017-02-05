import os

curdir = os.getcwd()
pairsPath = curdir+'\\pairs.txt'
pairs2Path = curdir+'\\pairs4folds.txt'
reduced=[]
with open(pairsPath) as f:
    lines = f.readlines()
    for i in range(len(lines)):
        print(str(i))
        if i==0:
            continue
        else:
       	    modd = i%10
       	    if modd==0:
       	        reduced.append(lines[i])
       	    elif modd!=0:
       	        continue
devider = (300/10)-5;
skip=5;
inside=[];
iterate=0;
for i in range(8):
    if i==0:
        temp_a = [x for x in range(iterate,devider)];
        iterate+=devider;
        iterate+=skip;
    else:
        temp_a = [x for x in range(iterate,iterate+devider)];
        iterate+=devider;
        iterate+=skip;
    temp_b = [x for x in range(iterate, iterate+devider)]
    iterate+=devider;
    iterate+=skip;
    inside = inside+temp_a;
    inside= inside+temp_b;
    
reduced2=[];
for i in range(0,len(inside)):
    reduced2.append(reduced[inside[i]])
    
devider2 = (400/16)
inside_folds=[]
iterate=0
for i in range(4):
    if i==0:
        sama_a = [x for x in range(iterate,devider)]
        iterate+=devider 
    else:
        sama_a = [x for x in range(iterate,iterate+devider)]
        iterate+=devider 
    beda_a = [x for x in range(iterate, iterate+devider)]
    iterate+=devider
    sama_b = [x for x in range(iterate,iterate+devider)] 
    iterate+=devider
    beda_b = [x for x in range(iterate, iterate+devider)]
    iterate+=devider
    temp=[]; temp=temp+sama_a; temp=temp+sama_b;
    temp=temp+beda_a; temp=temp+beda_b;
    inside_folds.append(temp)
    
reduced3=[]
for i in range(len(inside_folds)):
    for j in range(len(inside_folds[i])):
        reduced3.append(reduced2[inside_folds[i][j]])
     	        
with open(pairs2Path, 'w') as f:
    for i in range(len(reduced3)):
        f.write(reduced3[i])
        print(str(i)+'written')
        
	    
			


