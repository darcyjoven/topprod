/*
================================================================================
檔案代號:rza_file
檔案名稱:打印方案名称维护档
檔案目的:打印方案名称维护档
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rza_file
(
rza01       varchar2(100) DEFAULT ' ' NOT NULL, /*方案名称*/
rza02       blob,                    /*打印方案                               */
rza03       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
rza04       varchar2(10) DEFAULT ' ' NOT NULL /*制定營運中心*/
);

alter table rza_file add  constraint rza_pk primary key  (rza01) enable validate;
grant select on rza_file to tiptopgp;
grant update on rza_file to tiptopgp;
grant delete on rza_file to tiptopgp;
grant insert on rza_file to tiptopgp;
grant index on rza_file to public;
grant select on rza_file to ods;
