ALTER TABLE cfc_file DROP constraint tpc_cfc_pk;
alter table cfc_file add constraint tpc_cfc_pk primary key (cfc00,cfc01,cfc02,cfc03,cfc04,cfc05,cfc06,cfc21,cfc22) enable validate;
