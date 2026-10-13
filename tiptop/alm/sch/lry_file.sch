/*
================================================================================
檔案代號:lry_file
檔案名稱:卡开帐维护档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lry_file
(
lry01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lry02       date,                    /*单据日期                               */
lry03       varchar2(20),            /*no use                                 */
lry04       varchar2(20) DEFAULT ' ' NOT NULL, /*no use*/
lry05       varchar2(30) DEFAULT ' ' NOT NULL, /*no use*/
lry06       date,                    /*no use                                 */
lry07       date,                    /*no use                                 */
lry08       number(20,2) DEFAULT '0' NOT NULL, /*no use*/
lry09       number(20) DEFAULT '0' NOT NULL, /*no use*/
lry10       date,                    /*no use                                 */
lry11       number(20) DEFAULT '0' NOT NULL, /*no use*/
lry12       number(20) DEFAULT '0' NOT NULL, /*no use*/
lry13       number(20) DEFAULT '0' NOT NULL, /*no use*/
lry14       number(20,2) DEFAULT '0' NOT NULL, /*no use*/
lry15       varchar2(10) DEFAULT ' ' NOT NULL, /*no use*/
lry16       date,                    /*no use                                 */
lry17       varchar2(10),            /*no use                                 */
lry18       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lry19       varchar2(10),            /*审核人员                               */
lry20       date,                    /*审核日期                               */
lrycrat     date,                    /*资料创建日                             */
lrydate     date,                    /*最近更改日                             */
lrygrup     varchar2(10),            /*资料所有群                             */
lrylegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lrymodu     varchar2(10),            /*资料更改者                             */
lryorig     varchar2(10),            /*资料建立部门                           */
lryoriu     varchar2(10),            /*资料建立者                             */
lryplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lryuser     varchar2(10),            /*资料所有者                             */
lryacti     varchar2(1) DEFAULT ' ' NOT NULL /*资料有效码*/
);

alter table lry_file add  constraint lry_pk primary key  (lry01,lry04,lry05) enable validate;
grant select on lry_file to tiptopgp;
grant update on lry_file to tiptopgp;
grant delete on lry_file to tiptopgp;
grant insert on lry_file to tiptopgp;
grant index on lry_file to public;
grant select on lry_file to ods;
