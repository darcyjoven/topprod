/*
================================================================================
檔案代號:aaf_file
檔案名稱:账套名称档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aaf_file
(
aaf01       varchar2(5) NOT NULL,    /*帐套编号                               */
aaf02       varchar2(1) NOT NULL,    /*语言别                                 */
aaf03       varchar2(80)             /*名称                                   */
);

alter table aaf_file add  constraint aaf_pk primary key  (aaf01,aaf02) enable validate;
grant select on aaf_file to tiptopgp;
grant update on aaf_file to tiptopgp;
grant delete on aaf_file to tiptopgp;
grant insert on aaf_file to tiptopgp;
grant index on aaf_file to public;
grant select on aaf_file to ods;
