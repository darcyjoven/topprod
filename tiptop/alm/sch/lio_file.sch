/*
================================================================================
檔案代號:lio_file
檔案名稱:费用标准变更单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lio_file
(
lio01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
lio02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lio03       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lio04       date,                    /*费用开始日期                           */
lio05       date,                    /*费用结束日期                           */
lio06       number(20,6),            /*费用金额                               */
lio061      number(5,2),             /*费用系数                               */
lio07       varchar2(1),             /*计算基数                               */
lio071      number(5,2),             /*比例                                   */
lio072      number(20,6),            /*保底费用                               */
lio08       varchar2(1),             /*计算基数                               */
lio081      number(20,6),            /*下限                                   */
lio082      number(20,6),            /*上限                                   */
lio083      number(20,6),            /*费用金额                               */
liolegal    varchar2(10),            /*法人                                   */
lioplant    varchar2(10)             /*門店代號                               */
);

alter table lio_file add  constraint lio_pk primary key  (lio01,lio02,lio03) enable validate;
grant select on lio_file to tiptopgp;
grant update on lio_file to tiptopgp;
grant delete on lio_file to tiptopgp;
grant insert on lio_file to tiptopgp;
grant index on lio_file to public;
grant select on lio_file to ods;
