/*
================================================================================
檔案代號:tc_eca_file
檔案名稱:治工具使用配比维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_eca_file
(
tc_eca01    varchar2(40) NOT NULL,   /*成品料号                               */
tc_eca02    varchar2(10) NOT NULL,   /*工艺编号                               */
tc_eca03    number(5) NOT NULL,      /*项次                                   */
tc_eca04    number(5),               /*工艺序号                               */
tc_eca05    varchar2(40),            /*治工具料号                             */
tc_eca06    number(16,8),            /*消耗比率分子                           */
tc_eca07    number(16,8),            /*比率分母                               */
tc_ecaud01  varchar2(255),           /*no use                                 */
tc_ecaud02  varchar2(40),            /*no use                                 */
tc_ecaud03  varchar2(40),            /*no use                                 */
tc_ecaud04  varchar2(40),            /*no use                                 */
tc_ecaud05  varchar2(40),            /*no use                                 */
tc_ecaud06  varchar2(40),            /*no use                                 */
tc_ecaud07  number(15,3),            /*no use                                 */
tc_ecaud08  number(15,3),            /*no use                                 */
tc_ecaud09  number(15,3),            /*no use                                 */
tc_ecaud10  number(10),              /*no use                                 */
tc_ecaud11  number(10),              /*no use                                 */
tc_ecaud12  number(10),              /*no use                                 */
tc_ecaud13  date,                    /*no use                                 */
tc_ecaud14  date,                    /*no use                                 */
tc_ecaud15  date,                    /*no use                                 */
tc_ecaacti  varchar2(1),             /*资料有效码                             */
tc_ecauser  varchar2(10),            /*资料所有者                             */
tc_ecagrup  varchar2(10),            /*资料所有群                             */
tc_ecamodu  varchar2(10),            /*资料更改者                             */
tc_ecadate  date                     /*最近更改日                             */
);

alter table tc_eca_file add  constraint tpc_eca_pk primary key  (tc_eca01,tc_eca02,tc_eca03) enable validate;
grant select on tc_eca_file to tiptopgp;
grant update on tc_eca_file to tiptopgp;
grant delete on tc_eca_file to tiptopgp;
grant insert on tc_eca_file to tiptopgp;
grant index on tc_eca_file to public;
grant select on tc_eca_file to ods;
