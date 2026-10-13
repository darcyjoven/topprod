/*
================================================================================
檔案代號:gdd_file
檔案名稱:CR SQL Wizard 条件式记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdd_file
(
gdd01       varchar2(80) NOT NULL,   /*程序编号                               */
gdd02       varchar2(1) NOT NULL,    /*客制码                                 */
gdd03       varchar2(10) NOT NULL,   /*权限类型                               */
gdd04       varchar2(10) NOT NULL,   /*用户                                   */
gdd05       number(5) NOT NULL,      /*条件式序号                             */
gdd06       varchar2(5),             /*(                                      */
gdd07       varchar2(15),            /*档案代码                               */
gdd08       varchar2(20),            /*字段代码                               */
gdd09       varchar2(5),             /*条件式                                 */
gdd10       varchar2(15),            /*档案代码                               */
gdd11       varchar2(80),            /*字段代码/数值                          */
gdd12       varchar2(5),             /*)                                      */
gdd13       varchar2(1)              /*or/and                                 */
);

alter table gdd_file add  constraint gdd_pk primary key  (gdd01,gdd02,gdd03,gdd04,gdd05) enable validate;
grant select on gdd_file to tiptopgp;
grant update on gdd_file to tiptopgp;
grant delete on gdd_file to tiptopgp;
grant insert on gdd_file to tiptopgp;
grant index on gdd_file to public;
grant select on gdd_file to ods;
