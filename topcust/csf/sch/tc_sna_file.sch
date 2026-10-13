/*
================================================================================
檔案代號:tc_sna_file
檔案名稱:维修调拨单头资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sna_file
(
tc_sna00    varchar2(1),             /*类型                                   */
tc_sna01    varchar2(20) NOT NULL,   /*维修调拨单号                     */
tc_sna02    date NOT NULL,           /*录入日期                               */
tc_sna03    date NOT NULL,           /*审核日期                               */
tc_sna04       date,                 /*过账日期                               */
tc_sna05       varchar2(10),            /*员工编号                               */
tc_sna06        varchar2(1),         /*No Use                                 */
tc_sna07        varchar2(10),        /*专案编号                               */
tc_sna08        varchar2(255),       /*备注                                   */
tc_snauser  varchar2(10),            /*资料所有者                             */
tc_snagrup  varchar2(10),            /*资料所有部门                           */
tc_snamodu  varchar2(10),            /*资料更改者                             */
tc_snadate  date NOT NULL,           /*资料更改日                             */
tc_snaconf  varchar2(1),             /*审核码                                 */
tc_snaud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_snaud02  varchar2(40),            /*自订栏位-文字                          */
tc_snaud03  varchar2(40),            /*自订栏位-文字                          */
tc_snaud04  varchar2(40),            /*自订栏位-文字                          */
tc_snaud05  varchar2(40),            /*自订栏位-文字                          */
tc_snaud06  varchar2(40),            /*自订栏位-文字                          */
tc_snaud07  number(15,3),            /*自订栏位-数值                          */
tc_snaud08  number(15,3),            /*自订栏位-数值                          */
tc_snaud09  number(15,3),            /*自订栏位-数值                          */
tc_snaud10  number(10),              /*自订栏位-整数                          */
tc_snaud11  number(10),              /*自订栏位-整数                          */
tc_snaud12  number(10),              /*自订栏位-整数                          */
tc_snaud13  date,                    /*自订栏位-日期                          */
tc_snaud14  date,                    /*自订栏位-日期                          */
tc_snaud15  date,                    /*自订栏位-日期                          */
tc_snaplant varchar2(10),            /*所属营运中心                           */
tc_snalegal varchar2(10)           /*所属法人                               */

);

alter table tc_sna_file add  constraint tc_sfp_pk primary key  (tc_sna01) enable validate;
grant select on tc_sna_file to tiptopgp;
grant update on tc_sna_file to tiptopgp;
grant delete on tc_sna_file to tiptopgp;
grant insert on tc_sna_file to tiptopgp;
grant index on tc_sna_file to public;
grant select on tc_sna_file to ods;
