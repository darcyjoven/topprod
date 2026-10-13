/*
================================================================================
檔案代號:rch_file
檔案名稱:专柜对账单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rch_file
(
rch01       varchar2(20) DEFAULT ' ' NOT NULL, /*专柜对账单号*/
rch02       date,                    /*单据日期                               */
rch03       number(5),               /*对账年度                               */
rch04       number(5),               /*对账月份                               */
rch05       varchar2(10),            /*对账营运中心                           */
rch06       varchar2(10),            /*进驻百货客户编号                       */
rch07       varchar2(4),             /*税种                                   */
rch071      number(5,2),             /*税率                                   */
rch072      varchar2(1) DEFAULT ' ' NOT NULL, /*联数*/
rch073      varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
rch08       number(20,6) DEFAULT '0' NOT NULL, /*未税抽成金额*/
rch09       number(20,6) DEFAULT '0' NOT NULL, /*含税抽成金额*/
rch10       number(20,6) DEFAULT '0' NOT NULL, /*未税费用金额*/
rch11       number(20,6) DEFAULT '0' NOT NULL, /*含税费用金额*/
rchacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rchcond     date,                    /*审核日期                               */
rchconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rchcont     varchar2(8),             /*审核时间                               */
rchconu     varchar2(10),            /*审核人员                               */
rchcrat     date,                    /*资料创建日                             */
rchdate     date,                    /*最近更改日                             */
rchgrup     varchar2(10),            /*资料所有群                             */
rchlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rchmodu     varchar2(10),            /*资料更改者                             */
rchorig     varchar2(10),            /*资料建立部门                           */
rchoriu     varchar2(10),            /*资料建立者                             */
rchplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
rchuser     varchar2(10)             /*资料所有者                             */
);

alter table rch_file add  constraint rch_pk primary key  (rch01) enable validate;
grant select on rch_file to tiptopgp;
grant update on rch_file to tiptopgp;
grant delete on rch_file to tiptopgp;
grant insert on rch_file to tiptopgp;
grant index on rch_file to public;
grant select on rch_file to ods;
