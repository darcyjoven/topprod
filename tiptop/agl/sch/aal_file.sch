/*
================================================================================
檔案代號:aal_file
檔案名稱:关系人代号对应基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aal_file
(
aal01       varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
aal02       varchar2(10) DEFAULT ' ' NOT NULL, /*关系人编号(转换前)*/
aal03       varchar2(10) DEFAULT ' ' NOT NULL /*关系人编号(转换后)*/
);

alter table aal_file add  constraint aal_pk primary key  (aal01,aal02,aal03) enable validate;
grant select on aal_file to tiptopgp;
grant update on aal_file to tiptopgp;
grant delete on aal_file to tiptopgp;
grant insert on aal_file to tiptopgp;
grant index on aal_file to public;
grant select on aal_file to ods;
