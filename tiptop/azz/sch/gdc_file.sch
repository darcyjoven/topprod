/*
================================================================================
檔案代號:gdc_file
檔案名稱:CR SQL Wizard  Field 记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdc_file
(
gdc01       varchar2(80) NOT NULL,   /*程序编号                               */
gdc02       varchar2(1) NOT NULL,    /*客制码                                 */
gdc03       varchar2(10) NOT NULL,   /*权限类型                               */
gdc04       varchar2(10) NOT NULL,   /*用户                                   */
gdc05       varchar2(15) NOT NULL,   /*档案代码                               */
gdc06       varchar2(20) NOT NULL,   /*字段代码                               */
gdc07       number(5) NOT NULL       /*序号                                   */
);

alter table gdc_file add  constraint gdc_pk primary key  (gdc01,gdc02,gdc03,gdc04,gdc05,gdc06) enable validate;
grant select on gdc_file to tiptopgp;
grant update on gdc_file to tiptopgp;
grant delete on gdc_file to tiptopgp;
grant insert on gdc_file to tiptopgp;
grant index on gdc_file to public;
grant select on gdc_file to ods;
