/*
================================================================================
檔案代號:zas_file
檔案名稱:SQL Wizard 条件式记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zas_file
(
zas01       varchar2(80) NOT NULL,   /*查询单id                               */
zas02       number(5) NOT NULL,      /*条件式序号                             */
zas03       varchar2(5),             /*(                                      */
zas04       varchar2(15),            /*档案代码                               */
zas05       varchar2(20),            /*字段代码                               */
zas06       varchar2(5),             /*条件式                                 */
zas07       varchar2(20),            /*档案代码                               */
zas08       varchar2(80),            /*字段代码/数值                          */
zas09       varchar2(5),             /*)                                      */
zas10       varchar2(1),             /*or/and                                 */
zas11       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zas_file add  constraint zas_pk primary key  (zas01,zas02,zas11) enable validate;
grant select on zas_file to tiptopgp;
grant update on zas_file to tiptopgp;
grant delete on zas_file to tiptopgp;
grant insert on zas_file to tiptopgp;
grant index on zas_file to public;
grant select on zas_file to ods;
