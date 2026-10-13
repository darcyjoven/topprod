/*
================================================================================
檔案代號:vlg_file
檔案名稱:aps整合站台設定檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table vlg_file
(
vlg01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心*/
vlg02       varchar2(20),            /*APS站台名称                            */
vlg03       varchar2(15),            /*APS站台IP地址                          */
vlg04       varchar2(255)            /*APS SOAP 网址                          */
);

alter table vlg_file add  constraint vlg_pk primary key  (vlg01) enable validate;
grant select on vlg_file to tiptopgp;
grant update on vlg_file to tiptopgp;
grant delete on vlg_file to tiptopgp;
grant insert on vlg_file to tiptopgp;
grant index on vlg_file to public;
grant select on vlg_file to ods;
