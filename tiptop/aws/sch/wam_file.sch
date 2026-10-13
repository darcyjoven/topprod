/*
================================================================================
檔案代號:wam_file
檔案名稱:对象操作对应处理方法维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wam_file
(
wam01       varchar2(20) DEFAULT ' ' NOT NULL, /*对象别*/
wam02       varchar2(20) DEFAULT ' ' NOT NULL, /*操作别*/
wam03       varchar2(100) DEFAULT ' ' NOT NULL, /*方法函数*/
wam04       varchar2(20),            /*no use                                 */
wam05       varchar2(20),            /*no use                                 */
wam06       varchar2(100),           /*no use                                 */
wam07       varchar2(1)              /*no use                                 */
);

alter table wam_file add  constraint wam_pk primary key  (wam01,wam02) enable validate;
grant select on wam_file to tiptopgp;
grant update on wam_file to tiptopgp;
grant delete on wam_file to tiptopgp;
grant insert on wam_file to tiptopgp;
grant index on wam_file to public;
grant select on wam_file to ods;
