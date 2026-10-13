/*
================================================================================
檔案代號:asuu_file
檔案名稱:对冲科目MISC明细科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asuu_file
(
asuu00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
asuu01      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目编号*/
asuu03      varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目MISC明细科目*/
asuu04      varchar2(1) DEFAULT 'N' NOT NULL, /*是否依公司设置*/
asuu05      varchar2(1) DEFAULT 'N' NOT NULL, /*是否依股权冲销*/
asuu06      varchar2(1) DEFAULT 'N' NOT NULL /*少数股权否*/
);

alter table asuu_file add  constraint asuu_pk primary key  (asuu00,asuu01,asuu03) enable validate;
grant select on asuu_file to tiptopgp;
grant update on asuu_file to tiptopgp;
grant delete on asuu_file to tiptopgp;
grant insert on asuu_file to tiptopgp;
grant index on asuu_file to public;
grant select on asuu_file to ods;
