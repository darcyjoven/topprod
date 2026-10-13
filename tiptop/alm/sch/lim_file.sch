/*
================================================================================
檔案代號:lim_file
檔案名稱:费用标准设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lim_file
(
lim01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lim02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lim03       date,                    /*费用开始日期                           */
lim04       date,                    /*费用结束日期                           */
lim05       number(20,6),            /*费用金额                               */
lim051      number(5),               /*费用系数                               */
lim06       varchar2(1),             /*计算基数                               */
lim061      number(5,2),             /*比例                                   */
lim062      number(20,6),            /*保底金额                               */
lim07       varchar2(1),             /*计算基准                               */
lim071      number(20,6),            /*下限                                   */
lim072      number(20,6),            /*上限                                   */
lim073      number(20,6),            /*费用金额                               */
limlegal    varchar2(10),            /*法人                                   */
limplant    varchar2(10)             /*门店编号                               */
);

alter table lim_file add  constraint lim_pk primary key  (lim01,lim02) enable validate;
grant select on lim_file to tiptopgp;
grant update on lim_file to tiptopgp;
grant delete on lim_file to tiptopgp;
grant insert on lim_file to tiptopgp;
grant index on lim_file to public;
grant select on lim_file to ods;
