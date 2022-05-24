# Optimization

## Optimize COVID-19 Vaccine Distribution

For covering the demand for Covid-19 vaccines as much as possible, the objective of this work is to maximize the total number of vaccines allocated to all groups of people. The proposed MILP-model is used to find the optimal vaccine distribution strategy according to the following assumptions:

+ We only consider the first dose of one single vaccine product for multiple periods in the model, which will be a limitation if trying to apply it for the multi-product situation. 
+ We consider two-step transshipments consisting of K potential locations of distribution centres, P regional warehouses and I groups of population in T periods. 
+ The Covid-19 vaccines are purchased and stored in distribution centres, transshipped to the warehouses of regions, and allocated to local citizens by group priorities. 
+ K location of potential distribution centres are mapped out and to be selected. 
+ The centres require the corresponding setting up costs according to their location, and each distribution centre has a limit value for capacity in each period.
+ The warehouses, as the intermediate points, receive vaccines from the centres and distribute them to groups. 
+ Differentiated transportation costs incur when vaccines are shipped from these centres to warehouses concerning their distance, and storage cost would incur if the warehouses hold any inventory.
+ The sum of all costs cannot surpass the value of the budget determined. 
+ we separate the total population in demand into I groups, considering their urgency and priority of getting vaccines. Each group would be assigned an α value, indicating their priority level. And for each group, we have a coverage rate θ, meaning the minimum percentage of demand in this group to be covered.

By implementing a MILP model, the vaccine distribution problem was solved.
