/*
================================================================================
檔案代號:rwv_file
檔案名稱:营运中心业绩分配单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rwv_file
(
rwv01       varchar2(20) DEFAULT ' ' NOT NULL,
rwv02       date,                    /*销售日期                               */
rwv03       number(20,6) DEFAULT '0' NOT NULL,
rwv04       varchar2(255),           /*备注                                   */
rwvcond     date,                    /*审核日期                               */
rwvconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
rwvcont     varchar2(8),             /*审核时间                               */
rwvconu     varchar2(10),            /*审核人员                               */
rwvcrat     date,
rwvdate     date,                    /*最近更改日                             */
rwvgrup     varchar2(10),            /*资料所有群                             */
rwvlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rwvmodu     varchar2(10),            /*资料更改者                             */
rwvorig     varchar2(10),            /*资料建立部门                           */
rwvoriu     varchar2(10),            /*资料建立者                             */
rwvplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属工厂*/
rwvuser     varchar2(10)             /*资料所有者                             */
);

alter table rwv_file add  constraint rwv_pk primary key  (rwv01) enable validate;
grant select on rwv_file to tiptopgp;
grant update on rwv_file to tiptopgp;
grant delete on rwv_file to tiptopgp;
grant insert on rwv_file to tiptopgp;
grant index on rwv_file to public;
grant select on rwv_file to ods;
