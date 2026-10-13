/*
================================================================================
檔案代號:tc_sfp_file
檔案名稱:委外采购单发料单头资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfp_file
(
tc_sfp00    varchar2(1),             /*类型                                   */
tc_sfp01    varchar2(20) NOT NULL,   /*工艺委外发料单单号                     */
tc_sfp02    date NOT NULL,           /*录入日期                               */
tc_sfp03    varchar2(20),            /*委外采购单号                           */
tc_sfp04    number(5),               /*委外采购单项次                         */
tc_sfp05    varchar2(40),            /*委外供应商                             */
tc_sfp06    varchar2(20),            /*工单单号                               */
tc_sfp07    varchar2(20),            /*lot单号                                */
tc_sfp08    varchar2(40),            /*委外成品料号                           */
tc_sfp09    number(15,3),            /*委外数量                               */
tc_sfp10    varchar2(20),            /*杂收单号                               */
tc_sfpuser  varchar2(10),            /*资料所有者                             */
tc_sfpgrup  varchar2(10),            /*资料所有部门                           */
tc_sfpmodu  varchar2(10),            /*资料更改者                             */
tc_sfpdate  date NOT NULL,           /*资料更改日                             */
tc_sfpconf  varchar2(1),             /*审核码                                 */
tc_sfpud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_sfpud02  varchar2(40),            /*自订栏位-文字                          */
tc_sfpud03  varchar2(40),            /*自订栏位-文字                          */
tc_sfpud04  varchar2(40),            /*自订栏位-文字                          */
tc_sfpud05  varchar2(40),            /*自订栏位-文字                          */
tc_sfpud06  varchar2(40),            /*自订栏位-文字                          */
tc_sfpud07  number(15,3),            /*自订栏位-数值                          */
tc_sfpud08  number(15,3),            /*自订栏位-数值                          */
tc_sfpud09  number(15,3),            /*自订栏位-数值                          */
tc_sfpud10  number(10),              /*自订栏位-整数                          */
tc_sfpud11  number(10),              /*自订栏位-整数                          */
tc_sfpud12  number(10),              /*自订栏位-整数                          */
tc_sfpud13  date,                    /*自订栏位-日期                          */
tc_sfpud14  date,                    /*自订栏位-日期                          */
tc_sfpud15  date,                    /*自订栏位-日期                          */
tc_sfpplant varchar2(10),            /*所属营运中心                           */
tc_sfplegal varchar2(10),            /*所属法人                               */
tc_sfp11    varchar2(20),            /*收货单号                               */
tc_sfp12    number(5),               /*收货单项次                             */
tc_sfp13    number(5)                /*版本号                                 */
);

alter table tc_sfp_file add  constraint tpc_sfp_pk primary key  (tc_sfp01) enable validate;
grant select on tc_sfp_file to tiptopgp;
grant update on tc_sfp_file to tiptopgp;
grant delete on tc_sfp_file to tiptopgp;
grant insert on tc_sfp_file to tiptopgp;
grant index on tc_sfp_file to public;
grant select on tc_sfp_file to ods;
