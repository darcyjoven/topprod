/*
================================================================================
檔案代號:cki_file
檔案名稱:核对项目表
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table cki_file
(
cki01       number(5) DEFAULT '0' NOT NULL, /*序号*/
cki02       varchar2(100),           /*核對項目                               */
cki03       varchar2(60),            /*子報表 程式編號                        */
cki04       varchar2(255)
);

alter table cki_file add  constraint cki_pk primary key  (cki01) enable validate;
grant select on cki_file to tiptopgp;
grant update on cki_file to tiptopgp;
grant delete on cki_file to tiptopgp;
grant insert on cki_file to tiptopgp;
grant index on cki_file to public;
grant select on cki_file to ods;
