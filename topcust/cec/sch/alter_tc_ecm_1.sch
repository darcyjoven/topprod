
alter table tc_ecm_file drop constraint tpc_ecm_pk; 
alter table tc_ecm_file add  constraint tpc_ecm_pk primary key  (tc_ecm00,tc_ecm01,tc_ecm02,tc_ecm09) enable validate;
