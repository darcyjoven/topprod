/*
================================================================================
檔案代號:ect_file
檔案名稱:记录aeci100审核/反审核中间档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ect_file
(
ect01       varchar2(40),            /*作业编号                               */
ect02       varchar2(40) NOT NULL,   /*单据编号                               */
ect03       varchar2(40),            /*操作人                                 */
ect04       varchar2(40) NOT NULL,   /*操作类型                               */
ect05       date NOT NULL,           /*日期                                   */
ect06       varchar2(10) NOT NULL    /*时间                                   */
);

alter table ect_file add  constraint ect_pk primary key  (ect02,ect04,ect05) enable validate;
grant select on ect_file to tiptopgp;
grant update on ect_file to tiptopgp;
grant delete on ect_file to tiptopgp;
grant insert on ect_file to tiptopgp;
grant index on ect_file to public;
grant select on ect_file to ods;
