/*
================================================================================
檔案代號:aay_file
檔案名稱:账套用户权限设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aay_file
(
aay01       varchar2(5) NOT NULL,    /*帐套                                   */
aay02       varchar2(10) NOT NULL,   /*用户代码                               */
aay03       varchar2(1)              /*No Use                                 */
);

alter table aay_file add  constraint aay_pk primary key  (aay01,aay02) enable validate;
grant select on aay_file to tiptopgp;
grant update on aay_file to tiptopgp;
grant delete on aay_file to tiptopgp;
grant insert on aay_file to tiptopgp;
grant index on aay_file to public;
grant select on aay_file to ods;
