/*
================================================================================
檔案代號:get_file
檔案名稱:公式分类码基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table get_file
(
get01       varchar2(10) NOT NULL,   /*公式分类码                             */
get02       varchar2(80)             /*分类码说明                             */
);

alter table get_file add  constraint get_pk primary key  (get01) enable validate;
grant select on get_file to tiptopgp;
grant update on get_file to tiptopgp;
grant delete on get_file to tiptopgp;
grant insert on get_file to tiptopgp;
grant index on get_file to public;
grant select on get_file to ods;
