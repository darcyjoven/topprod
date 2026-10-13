/*
================================================================================
檔案代號:zar_file
檔案名稱:SQL Wizard  Field 记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zar_file
(
zar01       varchar2(80) NOT NULL,   /*查询单id                               */
zar02       varchar2(15) NOT NULL,   /*档案代码                               */
zar03       varchar2(20) NOT NULL,   /*字段代码                               */
zar04       number(5) NOT NULL,      /*序号                                   */
zar05       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zar_file add  constraint zar_pk primary key  (zar01,zar02,zar03,zar05) enable validate;
grant select on zar_file to tiptopgp;
grant update on zar_file to tiptopgp;
grant delete on zar_file to tiptopgp;
grant insert on zar_file to tiptopgp;
grant index on zar_file to public;
grant select on zar_file to ods;
