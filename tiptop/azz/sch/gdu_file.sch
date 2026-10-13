/*
================================================================================
檔案代號:gdu_file
檔案名稱:个资显示Pattern设定
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdu_file
(
gdu01       varchar2(10) DEFAULT ' ' NOT NULL,
gdu02       varchar2(50),
gdu03       number(5),
gdu04       number(5),
gdu05       number(5),
gdu06       varchar2(1),
gdu07       varchar2(30)
);

alter table gdu_file add  constraint gdu_pk primary key  (gdu01) enable validate;
grant select on gdu_file to tiptopgp;
grant update on gdu_file to tiptopgp;
grant delete on gdu_file to tiptopgp;
grant insert on gdu_file to tiptopgp;
grant index on gdu_file to public;
grant select on gdu_file to ods;
