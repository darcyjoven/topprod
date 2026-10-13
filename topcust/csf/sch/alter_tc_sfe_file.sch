alter table tc_sfe_file drop constraint tpc_sfe_pk;
alter table tc_sfe_file add constraint tpc_sfe_pk primary key(tc_sfe01,tc_sfe02,tc_sfe04) enable validate;
