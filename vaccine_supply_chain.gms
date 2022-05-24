$Title Vaccine Supply Chain Porlblem

$Ontext

This is the model of vaccine supply chain
Date 11 Nov 2021

$Offtext

Option MIP = Cplex; 

Sets
i   group type    /group1*group5/
k   distribution center     /center1*center5/
t   periods     /time1*time4/
p   province (we call it 'region' in our essay)    /province1*province12/
;

Alias(t,tt);


Table POP(p,i) group demand
	        Group1	Group2	Group3	Group4	Group5
province1	2006029	1974220	2530234	957364	1748826
province2	1959285	1928217	2471275	935056	1708075
province3	1603440	1578014	2022442	765231	1397854
province4	1364409	1342774	1720949	651155	1189471
province5	1297543	1276968	1636611	619244	1131179
province6	1231645	1212116	1553493	587795	1073730
province7	1202745	1183673	1517040	574002	1048535
province8	1189610	1170747	1500473	567734	1037084
province9	1058937	1042145	1335652	505370	923165
province10	689823	678885	870084	329213	601377
province11	583436	574185	735897	278441	508631
province12	412535	405994	520337	196880	359642
;


Table TR(p,k)

            center1 center2 center3 center4 center5
province1   0.45 	0.25 	0.35 	1.11 	1.19  
province2   0.39 	0.36 	0.38 	0.98 	1.06
province3   1.23 	1.02 	1.13 	0.55 	0.37 
province4   0.27 	0.44 	0.36 	0.91 	1.08
province5   0.67 	0.39 	0.53 	0.94 	0.98
province6   0.66 	0.41 	0.54 	1.12 	1.05
province7   0.99 	0.67 	0.83 	0.43 	0.48
province8   1.65 	1.76 	1.71 	1.21 	1.23
province9   0.71 	0.52 	0.62 	0.78 	0.88
province10  0.96 	0.89    0.93 	0.84 	0.75
province11  1.29 	1.33    1.31 	0.38 	0.33
province12  1.77 	1.98    1.88 	1.51 	1.25
;

Table CAP(k,t)

        time1       time2       time3       time4
center1 3500000     4000000     8000000     4000000
center2 2500000     2800000     5500000     2200000
center3 3300000     3800000     7000000     3800000
center4 2300000     2600000     4500000     2500000
center5 3000000     3500000     5800000     3000000
;

Table a(i,t)
        time1   time2   time3   time4
group1  0.45     0.40    0.20    0.15
group2  0.35     0.38    0.35    0.20
group3  0.10     0.12    0.25    0.30
group4  0.07     0.06    0.15    0.25
group5  0.03     0.04    0.05    0.10
;

Parameter
    POP(p,i) The total demand of group i for Covid vaccine in province p 
    ST(k)   Cost of setting up the distribution center k
    /
    center1	34000
    center2	42000
    center3	50000
    center4	36000
    center5	48000
    /
    PR  The per-dose purchasing cost of the Coivd vaccine /13/
    TR(p,k) The per-dose transportation cost of the Covid vaccine from distribution center k to province p
    HL(p)   The per-dose holding cost of the vaccine in province p warehouse for each time-period
    /
    province1	0.55
    province2	0.76
    province3	0.45
    province4	0.62
    province5	0.6
    province6	0.53
    province7	0.47
    province8	0.53
    province9	0.55
    province10	0.43
    province11	0.49
    province12	0.44
    /
    RATE(i) The minimum percentage of group i to be covered (coverage rate)
    /
    group1  0.9
    group2  0.9
    group3  0.7
    group4  0.6
    group5  0.4
    /
    CAP(k,t)    The maximum capacity of distribution center k for supplying Covid vaccine in time-period t
    BG  budget /1050000000/
    a(i,t)    the priority index of each group in time t
    ;
    

variables
    Z           Opjective function value
    y(p,i,t)    Number of Covid vaccines allocated to group i in province p in time-period t
    w(p,t)      Number of Covid vaccines stored in province p warehouse in time-period t
    x(k,p,t)    Number of Covid vaccines shipped from distribution center k to province p warehouse in time-period t
    s(k)        binary - set up or not
    m           total number of vaccines
;

Binary   Variable s;

*positive variables y,w,x;
integer variables y,w,x;

Scalar division /10/;
Scalar BG;

Equations
of1             Objective function of model 1
demand_coverage Demand coverage constraint: Ensure the minimum number of people in each group will receive enough vaccines
demand_balance  Demand balance constaint t>1
demand_balance_t  Demand balance constaint t=1
capacity        Capacity Constraint
budget_cover    budget constraint: The total cost should not surpass budget
minimum_amount  minimum vaccine amount for each group according to their priority index
total_vaccine   shows the total number of vaccines
;
of1..                    Z=E=sum((p,i,t),y(p,i,t)*a(i,t));
demand_coverage(p,i)..   sum(t,y(p,i,t)) =G= RATE(i)*POP(p,i);
demand_balance(p,t)$(ord(t)>1)..    w(p,t)+sum(i,y(p,i,t)) =E= sum(k,x(k,p,t)) + w(p,t-1);
demand_balance_t(p,t)$(ord(t)=1).. w(p,t)+sum(i,y(p,i,t)) =E= sum(k,x(k,p,t));
capacity(k,t)..          sum(p,x(k,p,t)) =L= CAP(k,t)*s(k);               
budget_cover..           sum((k),ST(k)*s(k)) +sum((p,t),HL(p)*w(p,t))+ sum((k,p,t),PR*X(k,p,t))+sum((k,p,t),TR(p,k)*x(k,p,t))=L=BG;
minimum_amount(p,i,t)..  y(p,i,t)=G=RATE(i)*POP(p,i)*a(i,t)/division;
total_vaccine..          m=E=sum((p,i,t),y(p,i,t))

Model Model1 /all/;

Solve Model1 using MIP maximising Z;
Display s.l,x.l,w.l,y.l,m.l;

$onText

We use this function to find the optimal division in total_vaccine constraint, we found /10/ is an optimal value for this constraint

Scalar ms;
File output;

for (division= 1 to 10 by 1,
    Solve Model1 using MIP maximising Z;
    ms = Model1.modelstat;
    put output/division, ms, Z.l/;
    Display x.l,w.l,y.l;
)
;


* sensitivity analysis for budget

Scalar ms;
File output;

for (BG= 650000000 to 1100000000 by 50000000,
    Solve Model1 using MIP maximising Z;
    ms = Model1.modelstat;
    put output/BG, ms,m.l/;
    Display x.l,w.l,y.l;
)
;
$offtext