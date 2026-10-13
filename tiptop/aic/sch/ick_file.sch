/*
================================================================================
檔案代號:ick_file
檔案名稱:ICD料件FT资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ick_file
(
ick01       varchar2(40) NOT NULL,   /*料件编号                               */
ick02       varchar2(40) NOT NULL,   /*产品型号                               */
ick03       varchar2(20),            /*ECN No                                 */
ick04       varchar2(255),           /*Remark                                 */
ick05       varchar2(30),            /*完成品测试程序                         */
ick06       varchar2(10),            /*测试程序版本                           */
ick07       date,                    /*放行日期                               */
ick08       varchar2(5),             /*警告                                   */
ick09       varchar2(10) NOT NULL,   /*FT Vendor                              */
ick10       number(15,6),            /*Holding Yield(%)                       */
ick11       varchar2(1),             /*no use                                 */
ick12       varchar2(1),             /*no use                                 */
ick13       varchar2(1),             /*no use                                 */
ick14       varchar2(1),             /*no use                                 */
ick15       varchar2(1),             /*no use                                 */
ick16       varchar2(1),             /*no use                                 */
ickacti     varchar2(1),             /*资料有效码                             */
ickdate     date,                    /*资料更改日                             */
ickgrup     varchar2(10),            /*资料所有群                             */
ickmodu     varchar2(10),            /*资料更改者                             */
ickuser     varchar2(10),            /*资料所有者                             */
ickoriu     varchar2(10),            /*资料建立者                             */
ickorig     varchar2(10)             /*资料建立部门                           */
);

alter table ick_file add  constraint ick_pk primary key  (ick01,ick02,ick09) enable validate;
grant select on ick_file to tiptopgp;
grant update on ick_file to tiptopgp;
grant delete on ick_file to tiptopgp;
grant insert on ick_file to tiptopgp;
grant index on ick_file to public;
grant select on ick_file to ods;
