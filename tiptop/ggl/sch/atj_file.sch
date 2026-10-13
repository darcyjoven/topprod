/*
================================================================================
檔案代號:atj_file
檔案名稱:现金流量群组表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atj_file
(
atj01       varchar2(6) DEFAULT ' ' NOT NULL, /*群组编号*/
atj02       varchar2(100),           /*说明                                   */
atj03       varchar2(1) DEFAULT ' ' NOT NULL, /*变动分类*/
atj04       varchar2(1) DEFAULT ' ' NOT NULL, /*合并否*/
atj05       number(5) DEFAULT '0' NOT NULL /*行序*/
);

alter table atj_file add  constraint atj_pk primary key  (atj01) enable validate;
grant select on atj_file to tiptopgp;
grant update on atj_file to tiptopgp;
grant delete on atj_file to tiptopgp;
grant insert on atj_file to tiptopgp;
grant index on atj_file to public;
grant select on atj_file to ods;
