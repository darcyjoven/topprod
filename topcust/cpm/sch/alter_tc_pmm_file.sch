alter table tc_pmm_file drop constraint tpc_pmm_pk;
alter table tc_pmm_file add constraint tpc_pmm_pk primary key(tc_pmm01,tc_pmmud10) enable validate;
