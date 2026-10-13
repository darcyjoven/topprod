/*
================================================================================
檔案代號:tc_ecu_file
檔案名稱:消耗性料件使用配比维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecu_file
(
tc_ecu01    varchar2(40) NOT NULL,   /*成品料号                               */
tc_ecu02    varchar2(10) NOT NULL,   /*工艺编号                               */
tc_ecu03    number(5) NOT NULL,      /*工艺序号                               */
tc_ecu04    varchar2(40),            /*消耗性料号                             */
tc_ecu05    number(16,8),            /*消耗比率分子                           */
tc_ecu06    number(16,8),            /*消耗比率分母                           */
tc_ecuud01  varchar2(255),           /*no use                                 */
tc_ecuud02  varchar2(40),            /*no use                                 */
tc_ecuud03  varchar2(40),            /*no use                                 */
tc_ecuud04  varchar2(40),            /*no use                                 */
tc_ecuud05  varchar2(40),            /*no use                                 */
tc_ecuud06  varchar2(40),            /*no use                                 */
tc_ecuud07  number(15,3),
tc_ecuud08  number(15,3),            /*no use                                 */
tc_ecuud09  number(15,3),            /*no use                                 */
tc_ecuud10  number(10) NOT NULL,     /*项次                                   */
tc_ecuud11  number(10),              /*no use                                 */
tc_ecuud12  number(10),              /*no use                                 */
tc_ecuud13  date,                    /*no use                                 */
tc_ecuud14  date,                    /*no use                                 */
tc_ecuud15  date,                    /*no use                                 */
tc_ecuacti  varchar2(1),             /*有效否                                 */
tc_ecuuser  varchar2(10),            /*资料所有者                             */
tc_ecugrup  varchar2(10),            /*资料所有群                             */
tc_ecumodu  varchar2(10),            /*资料更改者                             */
tc_ecudate  date                     /*最近更改日                             */
);

alter table tc_ecu_file add  constraint tpc_ecu_pk primary key  (tc_ecu01,tc_ecu02,tc_ecuud10) enable validate;
grant select on tc_ecu_file to tiptopgp;
grant update on tc_ecu_file to tiptopgp;
grant delete on tc_ecu_file to tiptopgp;
grant insert on tc_ecu_file to tiptopgp;
grant index on tc_ecu_file to public;
grant select on tc_ecu_file to ods;
