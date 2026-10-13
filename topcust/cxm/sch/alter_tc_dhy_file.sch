alter table tc_dhy_file drop constraint tpc_dhy_pk;
alter table tc_dhy_file add constraint tpc_dhy_pk primary key(tc_dhyud02) enable validate;
