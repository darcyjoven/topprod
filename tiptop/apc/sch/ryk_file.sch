/*
================================================================================
檔案代號:ryk_file
檔案名稱:下传资料设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryk_file
(
ryk01       number(5) DEFAULT '0' NOT NULL, /*项次*/
ryk02       varchar2(20),            /*ERP table name                         */
ryk03       varchar2(20),            /*POS table name                         */
ryk04       varchar2(120),           /*表内容描述                             */
ryk05       varchar2(1) DEFAULT 'Y' NOT NULL /*选择否 Y-选择,N-取消*/
);

alter table ryk_file add  constraint ryk_pk primary key  (ryk01) enable validate;
grant select on ryk_file to tiptopgp;
grant update on ryk_file to tiptopgp;
grant delete on ryk_file to tiptopgp;
grant insert on ryk_file to tiptopgp;
grant index on ryk_file to public;
grant select on ryk_file to ods;
