/*
================================================================================
檔案代號:tc_sfe_file
檔案名稱:工单申请发料单
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfe_file
(
tc_sfe01    varchar2(20) NOT NULL,   /*申请单单号                             */
tc_sfe02    varchar2(40) NOT NULL,   /*工单单号                               */
tc_sfe03    number(15,3),            /*发料套数                               */
tc_sfe04    varchar2(10) NOT NULL,   /*作业编号                               */
tc_sfe05    date,                    /*计划日期                               */
tc_sfeud01  varchar2(255),           /*自订字段-Textedit                      */
tc_sfeud02  varchar2(40),            /*是否发料                               */
tc_sfeud03  varchar2(40),            /*自订字段-文字                          */
tc_sfeud04  varchar2(40),            /*自订字段-文字                          */
tc_sfeud05  varchar2(40),            /*自订字段-文字                          */
tc_sfeud06  varchar2(40),            /*自订字段-文字                          */
tc_sfeud07  number(15,3),            /*自订字段-数值                          */
tc_sfeud08  number(15,3),            /*自订字段-数值                          */
tc_sfeud09  number(15,3),            /*自订字段-数值                          */
tc_sfeud10  number(10),              /*自订字段-整数                          */
tc_sfeud11  number(10),              /*自订字段-整数                          */
tc_sfeud12  number(10),              /*自订字段-整数                          */
tc_sfeud13  date,                    /*自订字段-日期                          */
tc_sfeud14  date,                    /*自订字段-日期                          */
tc_sfeud15  date,                    /*自订字段-日期                          */
tc_sfe06    varchar2(20),            /*特性码                                 */
tc_sfe07    number(15,3),            /*计划发料套数                           */
tc_sfe012   varchar2(10),            /*制程段号                               */
tc_sfe014   varchar2(23),            /*Run Card                               */
tc_sfeplant varchar2(10),            /*所属法人                               */
tc_sfelegal varchar2(10)             /*所属营运中心                           */
);

alter table tc_sfe_file add  constraint tpc_sfe_pk primary key  (tc_sfe01,tc_sfe02,tc_sfe04) enable validate;
grant select on tc_sfe_file to tiptopgp;
grant update on tc_sfe_file to tiptopgp;
grant delete on tc_sfe_file to tiptopgp;
grant insert on tc_sfe_file to tiptopgp;
grant index on tc_sfe_file to public;
grant select on tc_sfe_file to ods;
