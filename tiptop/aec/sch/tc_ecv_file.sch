/*
================================================================================
檔案代號:tc_ecv_file
檔案名稱:消耗性料件耗用情况维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecv_file
(
tc_ecv01    varchar2(40) NOT NULL,   /*成品料号                               */
tc_ecv02    varchar2(10) NOT NULL,   /*工艺编号                               */
tc_ecv03    varchar2(10) NOT NULL,   /*班别                                   */
tc_ecv04    date NOT NULL,           /*日期                                   */
tc_ecv05    number(5) NOT NULL,      /*工艺序号                               */
tc_ecv06    varchar2(40),            /*消耗性料号                             */
tc_ecv07    number(15,3),            /*消耗数量                               */
tc_ecvud01  varchar2(255),           /*no use                                 */
tc_ecvud02  varchar2(40),            /*no use                                 */
tc_ecvud03  varchar2(40),            /*no use                                 */
tc_ecvud04  varchar2(40),            /*no use                                 */
tc_ecvud05  varchar2(40),            /*no use                                 */
tc_ecvud06  varchar2(40),            /*no use                                 */
tc_ecvud07  number(15,3),            /*no use                                 */
                                     /*                                       */
                                     /*                                       */
                                     /*                                       */
tc_ecvud08  number(15,3),            /*no use                                 */
tc_ecvud09  number(15,3),            /*no use                                 */
tc_ecvud10  number(10) NOT NULL,     /*项次                                   */
tc_ecvud11  number(10),              /*no use                                 */
tc_ecvud12  number(10),              /*no use                                 */
tc_ecvud13  date,                    /*no use                                 */
tc_ecvud14  date,                    /*no use                                 */
tc_ecvud15  date,                    /*no use                                 */
tc_ecvacti  varchar2(1),             /*资料有效码                             */
tc_ecvuser  varchar2(10),            /*资料所有者                             */
tc_ecvgrup  varchar2(10),            /*资料所有群                             */
tc_ecvmodu  varchar2(10),            /*资料更改者                             */
tc_ecvdate  date                     /*最近更改日                             */
);

alter table tc_ecv_file add  constraint tpc_ecv_pk primary key  (tc_ecv01,tc_ecv02,tc_ecv03,tc_ecv04,tc_ecvud10) enable validate;
grant select on tc_ecv_file to tiptopgp;
grant update on tc_ecv_file to tiptopgp;
grant delete on tc_ecv_file to tiptopgp;
grant insert on tc_ecv_file to tiptopgp;
grant index on tc_ecv_file to public;
grant select on tc_ecv_file to ods;
