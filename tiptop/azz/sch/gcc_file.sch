/*
================================================================================
檔案代號:gcc_file
檔案名稱:资料上传下载单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcc_file
(
gcc01       varchar2(10) NOT NULL,   /*格式代码                               */
gcc02       varchar2(80)             /*排列顺序                               */
);

alter table gcc_file add  constraint gcc_pk primary key  (gcc01) enable validate;
grant select on gcc_file to tiptopgp;
grant update on gcc_file to tiptopgp;
grant delete on gcc_file to tiptopgp;
grant insert on gcc_file to tiptopgp;
grant index on gcc_file to public;
grant select on gcc_file to ods;
