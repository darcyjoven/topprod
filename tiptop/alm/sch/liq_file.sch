/*
================================================================================
檔案代號:liq_file
檔案名稱:摊位个别费用标准设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table liq_file
(
liq01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
liq02       number(5) DEFAULT '0' NOT NULL, /*项次*/
liq03       varchar2(20),            /*摊位编号                               */
liq04       date,                    /*费用开始日期                           */
liq05       date,                    /*费用结束日期                           */
liq06       number(20,6),            /*参考费用金额                           */
liq061      number(20,6),            /*费用金额                               */
liq07       varchar2(1),             /*计算基数                               */
liq071      number(5,2),             /*参考比例                               */
liq072      number(20,6),            /*参考保底费用                           */
liq073      number(5,2),             /*比例                                   */
liq074      number(20,6),            /*保底费用                               */
liq08       varchar2(1),             /*计算基数                               */
liq081      number(20,6),            /*下限                                   */
liq082      number(20,6),            /*上限                                   */
liq083      number(20,6),            /*参考费用金额                           */
liq084      number(20,6),            /*费用金额                               */
liq09       number(20,6),            /*增长幅度                               */
liqlegal    varchar2(10),            /*所属法人                               */
liqplant    varchar2(10)             /*所属营运中心                           */
);

alter table liq_file add  constraint liq_pk primary key  (liq01,liq02) enable validate;
grant select on liq_file to tiptopgp;
grant update on liq_file to tiptopgp;
grant delete on liq_file to tiptopgp;
grant insert on liq_file to tiptopgp;
grant index on liq_file to public;
grant select on liq_file to ods;
