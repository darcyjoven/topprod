/*
================================================================================
檔案代號:gco_file
檔案名稱:触发器模板定义档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gco_file
(
gco01       varchar2(15) NOT NULL,   /*表名                                   */
gco02       varchar2(1000),          /*所有字段名称                           */
gco03       varchar2(3000),          /*所有新值                               */
gco04       varchar2(3000),          /*所有旧值                               */
gco05       varchar2(20),            /*用户                                   */
gco06       varchar2(10),            /*操作类型                               */
gco07       date,                    /*操作日期                               */
gco08       varchar2(20)             /*程序代码                               */
);

alter table gco_file add  constraint gco_pk primary key  (gco01) enable validate;
grant select on gco_file to tiptopgp;
grant update on gco_file to tiptopgp;
grant delete on gco_file to tiptopgp;
grant insert on gco_file to tiptopgp;
grant index on gco_file to public;
grant select on gco_file to ods;
