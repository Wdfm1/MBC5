set default to M:\mbc5
set path to M:\mbc5
use cust in 0 shared
select cust
set order to schcode
seek("002253")
replace cust.sourdate with{}
clear all
close all
release all