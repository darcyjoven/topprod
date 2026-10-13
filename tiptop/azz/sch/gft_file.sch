/*
================================================================================
檔案代號:gft_file
檔案名稱:GR报表样版设定作业文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gft_file
(
gft01       varchar2(1) DEFAULT ' ' NOT NULL, /*语言别*/
gft02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
gft03       varchar2(20),
gft04       number(5),
gft05       varchar2(1) DEFAULT ' ' NOT NULL,
gft06       varchar2(20),            /*颜色                                   */
gft07       varchar2(10),
gft08       varchar2(1)              /*位置                                   */
);

create unique index gft_01 on gft_file (gft01,gft02);
alter table gft_file add  constraint gft_pk primary key  (gft01,gft02) enable validate;
grant select on gft_file to tiptopgp;
grant update on gft_file to tiptopgp;
grant delete on gft_file to tiptopgp;
grant insert on gft_file to tiptopgp;
grant index on gft_file to public;
grant select on gft_file to ods;
