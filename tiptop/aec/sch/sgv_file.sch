/*
================================================================================
檔案代號:sgv_file
檔案名稱:产品工艺单元变更档
檔案目的:产品工艺单元变更单头档
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sgv_file
(
sgv01       varchar2(40) DEFAULT ' ' NOT NULL, /*产品料号*/
sgv02       varchar2(10) DEFAULT ' ' NOT NULL, /*工艺编号*/
sgv03       number(5) DEFAULT '0' NOT NULL, /*工艺序号*/
sgv04       number(5) DEFAULT '0' NOT NULL, /*单元变更序号*/
sgv05       varchar2(10),            /*变更原因                               */
sgv06       varchar2(80),            /*变更原因说明                           */
sgv07       date DEFAULT sysdate NOT NULL, /*变更日期*/
sgv08       date,                    /*发放日期                               */
sgv09       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
sgv10       varchar2(1),             /*发放码                                 */
sgvacti     varchar2(1),             /*资料有效码                             */
sgvdate     date,                    /*最近更改日                             */
sgvgrup     varchar2(10),            /*资料所属群组                           */
sgvmodu     varchar2(10),            /*资料更改者                             */
sgvuser     varchar2(10),            /*资料所有者                             */
sgvoriu     varchar2(10),            /*资料建立者                             */
sgvorig     varchar2(10),            /*资料建立部门                           */
sgv012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table sgv_file add  constraint sgv_pk primary key  (sgv01,sgv02,sgv03,sgv04,sgv012) enable validate;
grant select on sgv_file to tiptopgp;
grant update on sgv_file to tiptopgp;
grant delete on sgv_file to tiptopgp;
grant insert on sgv_file to tiptopgp;
grant index on sgv_file to public;
grant select on sgv_file to ods;
