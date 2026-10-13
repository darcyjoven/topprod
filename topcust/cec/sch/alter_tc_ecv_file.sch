alter table tc_ecv_file drop constraint tpc_ecv_pk;
alter table tc_ecv_file add constraint tpc_ecv_pk primary key(tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04,tc_ecvud10) enable validate;
