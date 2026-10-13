drop index TPC_HRBH_PK;
alter table hrbh_file add constraint TPC_HRBH_PK primary key(hrbh01,hrbh03);
