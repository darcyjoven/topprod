/*
================================================================================
檔案代號:rzb_file
檔案名稱:方案生效范围档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzb_file
(
rzb01       varchar2(100) DEFAULT ' ' NOT NULL, /*方案名称*/
rzb02       varchar2(10) DEFAULT ' ' NOT NULL /*生效营运中心*/
);

alter table rzb_file add  constraint rzb_pk primary key  (rzb01,rzb02) enable validate;
grant select on rzb_file to tiptopgp;
grant update on rzb_file to tiptopgp;
grant delete on rzb_file to tiptopgp;
grant insert on rzb_file to tiptopgp;
grant index on rzb_file to public;
grant select on rzb_file to ods;
