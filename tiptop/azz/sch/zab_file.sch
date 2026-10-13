/*
================================================================================
檔案代號:zab_file
檔案名稱:报表备注维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table zab_file
(
zab01       varchar2(6) NOT NULL,    /*备注代码                               */
zab02       varchar2(80),            /*备注名称                               */
zab03       varchar2(1) NOT NULL,    /*行序                                   */
zab04       varchar2(1) NOT NULL,    /*语言别                                 */
zab05       varchar2(1000)           /*备注内容                               */
);

alter table zab_file add  constraint zab_pk primary key  (zab01,zab03,zab04) enable validate;
grant select on zab_file to tiptopgp;
grant update on zab_file to tiptopgp;
grant delete on zab_file to tiptopgp;
grant insert on zab_file to tiptopgp;
grant index on zab_file to public;
grant select on zab_file to ods;
