alter table tc_ecu_file drop constraint tpc_ecu_pk;
alter table tc_ecu_file add constraint tpc_ecu_pk primary key(tc_ecu01,tc_ecu02,tc_ecuud10) enable validate;
