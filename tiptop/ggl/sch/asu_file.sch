/*
================================================================================
檔案代號:asu_file
檔案名稱:对冲科目MISC明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asu_file
(
asu00       varchar2(5) DEFAULT ' ' NOT NULL, /*来源帐套*/
asu01       varchar2(24) DEFAULT ' ' NOT NULL, /*来源会计科目编号*/
asu03       varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目MISC明细科目*/
asu04       varchar2(1) DEFAULT 'N' NOT NULL, /*是否依据公式设置*/
asu05       varchar2(1) DEFAULT 'N' NOT NULL, /*是否依股权冲销*/
asu06       varchar2(1) DEFAULT 'N' NOT NULL, /*少数股权否*/
asu09       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
asu10       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
asu12       varchar2(5) DEFAULT ' ' NOT NULL, /*对冲帐套*/
asu13       varchar2(10) DEFAULT ' ' NOT NULL /*族群编号*/
);

alter table asu_file add  constraint asu_pk primary key  (asu00,asu01,asu03,asu09,asu10,asu12,asu13) enable validate;
grant select on asu_file to tiptopgp;
grant update on asu_file to tiptopgp;
grant delete on asu_file to tiptopgp;
grant insert on asu_file to tiptopgp;
grant index on asu_file to public;
grant select on asu_file to ods;
