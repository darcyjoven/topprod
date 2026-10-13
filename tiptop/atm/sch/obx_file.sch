/*
================================================================================
檔案代號:obx_file
檔案名稱:车辆保养维修记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obx_file
(
obx01       varchar2(10) NOT NULL,   /*车辆编号                               */
obx02       number(5) NOT NULL,      /*序号                                   */
obx03       date,                    /*异动日期                               */
obx04       varchar2(4),             /*保养编码                               */
obx05       varchar2(255),           /*问题描述一                             */
obx06       varchar2(255),           /*问题描述二                             */
obx07       varchar2(255),           /*问题描述三                             */
obx08       varchar2(255),           /*处理状况一                             */
obx09       varchar2(255),           /*处理状况二                             */
obx10       varchar2(255),           /*处理状况三                             */
obx11       varchar2(10)             /*处理人员                               */
);

alter table obx_file add  constraint obx_pk primary key  (obx01,obx02) enable validate;
grant select on obx_file to tiptopgp;
grant update on obx_file to tiptopgp;
grant delete on obx_file to tiptopgp;
grant insert on obx_file to tiptopgp;
grant index on obx_file to public;
grant select on obx_file to ods;
