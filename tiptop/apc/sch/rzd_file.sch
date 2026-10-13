/*
================================================================================
檔案代號:rzd_file
檔案名稱:POS参数值
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table rzd_file
(
rzd01       varchar2(50) DEFAULT ' ' NOT NULL, /*参数编号*/
rzd02       varchar2(60) DEFAULT ' ' NOT NULL, /*参数值*/
rzdacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

create unique index rzd_01 on rzd_file (rzd01,rzd02);
alter table rzd_file add  constraint rzd_pk primary key  (rzd01,rzd02) enable validate;
grant select on rzd_file to tiptopgp;
grant update on rzd_file to tiptopgp;
grant delete on rzd_file to tiptopgp;
grant insert on rzd_file to tiptopgp;
grant index on rzd_file to public;
grant select on rzd_file to ods;
