/*
================================================================================
檔案代號:zay_file
檔案名稱:自定义资料转换设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zay_file
(
zay01       varchar2(80) NOT NULL,   /*查询单id                               */
zay02       number(5) NOT NULL,      /*序号                                   */
zay03       varchar2(1) NOT NULL,    /*客制否                                 */
zay04       varchar2(1),             /*转换项目                               */
zay05       varchar2(80) NOT NULL,   /*原转换值                               */
zay06       varchar2(1),             /*取代类型                               */
zay07       varchar2(80)             /*取代值                                 */
);

alter table zay_file add  constraint zay_pk primary key  (zay01,zay02,zay03,zay05) enable validate;
grant select on zay_file to tiptopgp;
grant update on zay_file to tiptopgp;
grant delete on zay_file to tiptopgp;
grant insert on zay_file to tiptopgp;
grant index on zay_file to public;
grant select on zay_file to ods;
