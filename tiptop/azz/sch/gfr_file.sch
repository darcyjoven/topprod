/*
================================================================================
檔案代號:gfr_file
檔案名稱:Genero注册讯息绑定文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfr_file
(
gfr01       varchar2(1500) DEFAULT ' ' NOT NULL,
gfrdate     date                     /*最近更改日                             */
);

alter table gfr_file add  constraint gfr_pk primary key  (gfr01) enable validate;
grant select on gfr_file to tiptopgp;
grant update on gfr_file to tiptopgp;
grant delete on gfr_file to tiptopgp;
grant insert on gfr_file to tiptopgp;
grant index on gfr_file to public;
grant select on gfr_file to ods;
