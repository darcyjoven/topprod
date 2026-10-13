/*
================================================================================
檔案代號:lis_file
檔案名稱:摊位个别费用标准变更单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lis_file
(
lis01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
lis02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lis03       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lis04       varchar2(20),            /*摊位编号                               */
lis05       date,                    /*费用开始日期                           */
lis06       date,                    /*费用结束日期                           */
lis07       number(20,6),            /*参考费用金额                           */
lis071      number(20,6),            /*费用金额                               */
lis08       varchar2(1),             /*计算基数                               */
lis081      number(5,2),             /*参考比例                               */
lis082      number(20,6),            /*参考保底金额                           */
lis083      number(5,2),             /*比例                                   */
lis084      number(20,6),            /*保底金额                               */
lis09       varchar2(1),             /*计算基数                               */
lis091      number(20,6),            /*下限                                   */
lis092      number(20,6),            /*上限                                   */
lis093      number(20,6),            /*参考费用金额                           */
lis094      number(20,6),            /*费用金额                               */
lis10       number(20,6),            /*增长幅度                               */
lislegal    varchar2(10),            /*所属法人                               */
lisplant    varchar2(10)             /*所属营运中心                           */
);

alter table lis_file add  constraint lis_pk primary key  (lis01,lis02,lis03) enable validate;
grant select on lis_file to tiptopgp;
grant update on lis_file to tiptopgp;
grant delete on lis_file to tiptopgp;
grant insert on lis_file to tiptopgp;
grant index on lis_file to public;
grant select on lis_file to ods;
