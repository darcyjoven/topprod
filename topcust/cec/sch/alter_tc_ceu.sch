ALTER  TABLE tc_ceb_file DROP Constraint  tpc_ceb_pk;
alter table tc_ceb_file add  constraint tpc_ceb_pk primary key  (tc_ceb01,tc_ceb02,tc_ceb03,tc_ceb012,tc_cebud11) enable validate;
