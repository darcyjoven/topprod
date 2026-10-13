/*
================================================================================
檔案代號:hrbsa_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrbsa_file
(
hrbsa01     number(5) NOT NULL,      /*序号                                   */
hrbsa02     varchar2(20),            /*字段编码                               */
hrbsa03     varchar2(100)            /*字段名称                               */
);

alter table hrbsa_file add  constraint tpc_hrbsa_pk primary key  (hrbsa01) enable validate;
grant select on hrbsa_file to tiptopgp;
grant update on hrbsa_file to tiptopgp;
grant delete on hrbsa_file to tiptopgp;
grant insert on hrbsa_file to tiptopgp;
grant index on hrbsa_file to public;
grant select on hrbsa_file to ods;
