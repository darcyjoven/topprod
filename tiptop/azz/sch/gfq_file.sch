/*
================================================================================
檔案代號:gfq_file
檔案名稱:纪录特殊符号
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfq_file
(
gfq01       number(5) DEFAULT '0' NOT NULL, /*项次*/
gfq02       varchar2(10) DEFAULT ' ' NOT NULL
);

alter table gfq_file add  constraint gfq_pk primary key  (gfq01) enable validate;
grant select on gfq_file to tiptopgp;
grant update on gfq_file to tiptopgp;
grant delete on gfq_file to tiptopgp;
grant insert on gfq_file to tiptopgp;
grant index on gfq_file to public;
grant select on gfq_file to ods;
