/*
================================================================================
檔案代號:odb_file
檔案名稱:集团销售预测版本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odb_file
(
odb01       varchar2(10) NOT NULL,   /*版本编号                               */
odb02       varchar2(80),            /*版本名称                               */
odb03       date,                    /*计划日期                               */
odb04       varchar2(10),            /*时距类型                               */
odb05       date,                    /*预测起始日期                           */
odb06       date,                    /*预测截止日期                           */
odb07       varchar2(10),            /*最上层组织                             */
odb08       varchar2(1),             /*抛转否                                 */
odb09       varchar2(4),             /*预测币种                               */
odbacti     varchar2(1)              /*有效否                                 */
);

alter table odb_file add  constraint odb_pk primary key  (odb01) enable validate;
grant select on odb_file to tiptopgp;
grant update on odb_file to tiptopgp;
grant delete on odb_file to tiptopgp;
grant insert on odb_file to tiptopgp;
grant index on odb_file to public;
grant select on odb_file to ods;
