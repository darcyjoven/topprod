/*
================================================================================
檔案代號:asv_file
檔案名稱:对冲科目MISC明细科目公式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asv_file
(
asv00       varchar2(5) DEFAULT ' ' NOT NULL, /*来源帐套*/
asv01       varchar2(24) DEFAULT ' ' NOT NULL, /*来源会计科目编号*/
asv03       varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目MISC明细科目*/
asv04       varchar2(24) DEFAULT ' ' NOT NULL, /*对冲科目加减项科目*/
asv05       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项 + 加项 - 减项*/
asv09       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
asv10       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
asv12       varchar2(5) DEFAULT ' ' NOT NULL, /*对冲帐套*/
asv13       varchar2(10) DEFAULT ' ' NOT NULL /*族群编号*/
);

alter table asv_file add  constraint asv_pk primary key  (asv00,asv01,asv03,asv04,asv09,asv10,asv12,asv13) enable validate;
grant select on asv_file to tiptopgp;
grant update on asv_file to tiptopgp;
grant delete on asv_file to tiptopgp;
grant insert on asv_file to tiptopgp;
grant index on asv_file to public;
grant select on asv_file to ods;
