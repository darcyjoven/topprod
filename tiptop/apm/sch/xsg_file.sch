/*
================================================================================
檔案代號:xsg_file
檔案名稱:串貨舉報
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsg_file
(
xsg01       varchar2(20) DEFAULT ' ' NOT NULL, /*举报代号*/
xsg02       date,                    /*举报日期                               */
xsg03       varchar2(10),            /*上级组织                               */
xsg04       varchar2(80),            /*窜货目的组织                           */
xsg05       varchar2(10),            /*所在地区                               */
xsg06       varchar2(80),            /*窜货来源组织                           */
xsg07       varchar2(10),            /*所在地区                               */
xsg08       varchar2(255),           /*备注                                   */
xsg09       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
xsg10       varchar2(255),           /*处理意见                               */
xsg99       varchar2(10) DEFAULT ' ' NOT NULL /*经销商*/
);

alter table xsg_file add  constraint xsg_pk primary key  (xsg01) enable validate;
grant select on xsg_file to tiptopgp;
grant update on xsg_file to tiptopgp;
grant delete on xsg_file to tiptopgp;
grant insert on xsg_file to tiptopgp;
grant index on xsg_file to public;
grant select on xsg_file to ods;
