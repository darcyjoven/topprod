/*
================================================================================
檔案代號:tc_sfa_file
檔案名稱:工单留置数量
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfa_file
(
tc_sfa01    varchar2(20) NOT NULL,   /*排程单号                               */
tc_sfa02    date,                    /*排程日期                               */
tc_sfa03    varchar2(10),            /*排程人员                               */
tc_sfa04    varchar2(1),             /*状态                                   */
tc_sfa05    varchar2(10),            /*审核人员                               */
tc_sfa06    varchar2(10),            /*审核时间                               */
tc_sfaud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_sfaud02  varchar2(40),            /*自订栏位-文字                          */
tc_sfaud03  varchar2(40),            /*自订栏位-文字                          */
tc_sfaud04  varchar2(40),            /*自订栏位-文字                          */
tc_sfaud05  varchar2(40),            /*自订栏位-文字                          */
tc_sfaud06  varchar2(40),            /*自订栏位-文字                          */
tc_sfaud07  number(15,3),            /*自订栏位-数值                          */
tc_sfaud08  number(15,3),            /*自订栏位-数值                          */
tc_sfaud09  number(15,3),            /*自订栏位-数值                          */
tc_sfaud10  number(10),              /*自订栏位-整数                          */
tc_sfaud11  number(10),              /*自订栏位-整数                          */
tc_sfaud12  number(10),              /*自订栏位-整数                          */
tc_sfaud13  date,                    /*自订栏位-日期                          */
tc_sfaud14  date,                    /*自订栏位-日期                          */
tc_sfaud15  date,                    /*自订栏位-日期                          */
tc_sfauser  varchar2(10),            /*资料所有者                             */
tc_sfagrup  varchar2(10),            /*资料所有群                             */
tc_sfamodu  varchar2(10),            /*资料更改者                             */
tc_sfadate  date,                    /*最近更改日                             */
tc_sfaplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_sfalegal varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tc_sfa_file add  constraint tpc_sfa_pk primary key  (tc_sfa01) enable validate;
grant select on tc_sfa_file to tiptopgp;
grant update on tc_sfa_file to tiptopgp;
grant delete on tc_sfa_file to tiptopgp;
grant insert on tc_sfa_file to tiptopgp;
grant index on tc_sfa_file to public;
grant select on tc_sfa_file to ods;
