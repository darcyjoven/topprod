/*
================================================================================
檔案代號:rvx_file
檔案名稱:入库采购金额变更异动档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table rvx_file
(
rvx01       varchar2(20) NOT NULL,   /*入库单号                               */
rvx02       number(5) NOT NULL,      /*项次                                   */
rvx03       date NOT NULL,           /*变更日期                               */
rvx04       number(20,6) NOT NULL,   /*变更前单价(税前)                       */
rvx04t      number(20,6),            /*变更前单价(含税)                       */
rvx05       number(20,6),            /*变更后单价(税前)                       */
rvx05t      number(20,6),            /*变更后单价(含税)                       */
rvx06       number(20,6),            /*变更后金额(税前)                       */
rvx06t      number(20,6),            /*变更后金额(含税)                       */
rvxuser     varchar2(10),            /*资料所有者                             */
rvx031      varchar2(8) DEFAULT ' ' NOT NULL, /*作业时间*/
rvxplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvxlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvxorig     varchar2(10),            /*资料建立部门                           */
rvxoriu     varchar2(10)             /*资料建立者                             */
);

alter table rvx_file add  constraint rvx_pk primary key  (rvx01,rvx02,rvx03,rvx031,rvx04) enable validate;
grant select on rvx_file to tiptopgp;
grant update on rvx_file to tiptopgp;
grant delete on rvx_file to tiptopgp;
grant insert on rvx_file to tiptopgp;
grant index on rvx_file to public;
grant select on rvx_file to ods;
