alter table tc_ogd_file modify tc_ogd03 NOT NULL;
alter table tc_ogd_file drop constraint tpc_ogd_pk;
alter table tc_ogd_file add constraint tpc_ogd_pk primary key(tc_ogd01,tc_ogd02,tc_ogd03) enable validate;
