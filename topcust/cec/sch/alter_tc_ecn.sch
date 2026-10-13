drop index tic_ecn_01;
alter table tc_ecn_file drop constraint tpc_ecn_pk; 
create unique index tic_ecn_01 on tc_ecn_file (tc_ecn01,tc_ecn02,tc_ecn09);
alter table tc_ecn_file add  constraint tpc_ecn_pk primary key  (tc_ecn01,tc_ecn02,tc_ecn09) enable validate;
