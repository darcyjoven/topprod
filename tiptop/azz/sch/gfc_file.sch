/*
================================================================================
檔案代號:gfc_file
檔案名稱:客户开发记录 (程式修改清单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gfc_file
(
gfc01       varchar2(20) NOT NULL,   /*开发单号                               */
gfc02       number(5) NOT NULL,      /*项次                                   */
gfc03       varchar2(5),             /*系统                                   */
gfc04       varchar2(5),             /*档案类型                               */
gfc05       varchar2(80),            /*档案名称                               */
gfc06       varchar2(80),            /*备注                                   */
gfc07       varchar2(1),             /*程序状态                               */
gfc08       varchar2(10),            /*拥有者                                 */
gfc09       date,                    /*锁定日期                               */
gfc10       date,                    /*最后下载日期                           */
gfc11       date,                    /*最后上载日期                           */
gfc12       varchar2(255)            /*档案下载位置                           */
);

alter table gfc_file add  constraint gfc_pk primary key  (gfc01,gfc02) enable validate;
grant select on gfc_file to tiptopgp;
grant update on gfc_file to tiptopgp;
grant delete on gfc_file to tiptopgp;
grant insert on gfc_file to tiptopgp;
grant index on gfc_file to public;
grant select on gfc_file to ods;
