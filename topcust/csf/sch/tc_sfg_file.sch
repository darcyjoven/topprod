/*
================================================================================
檔案代號:tc_sfg_file
檔案名稱:工单申请发料变更记录
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfg_file
(
tc_sfg01    varchar2(20) NOT NULL,   /*申请单单号                             */
tc_sfg02    varchar2(40) NOT NULL,   /*工单单号                               */
tc_sfg03    number(15,3),            /*发料套数                               */
tc_sfg04    varchar2(10) NOT NULL,   /*作业编号                               */
tc_sfg05    date,                    /*计划日期                               */
tc_sfgud01  varchar2(255),           /*自订字段-Textedit                      */
tc_sfgud02  varchar2(40),            /*是否发料                               */
tc_sfgud03  varchar2(40),            /*变更人员                               */
tc_sfgud04  varchar2(40),            /*变更时间     HH:MM:SS                  */
tc_sfgud05  varchar2(40),            /*变更状态                               */
tc_sfgud06  varchar2(40),            /*自订字段-文字                          */
tc_sfgud07  number(15,3),            /*自订字段-数值                          */
tc_sfgud08  number(15,3),            /*自订字段-数值                          */
tc_sfgud09  number(15,3),            /*自订字段-数值                          */
tc_sfgud10  number(10) NOT NULL,     /*变更版次                               */
tc_sfgud11  number(10),              /*自订字段-整数                          */
tc_sfgud12  number(10),              /*自订字段-整数                          */
tc_sfgud13  date,                    /*变更日期                               */
tc_sfgud14  date,                    /*自订字段-日期                          */
tc_sfgud15  date,                    /*自订字段-日期                          */
tc_sfg06    varchar2(20),            /*特性码                                 */
tc_sfg07    number(15,3),            /*计划发料套数                           */
tc_sfg012   varchar2(10),            /*制程段号                               */
tc_sfg014   varchar2(23),            /*Run Card                               */
tc_sfgplant varchar2(10),            /*所属法人                               */
tc_sfglegal varchar2(10)             /*所属营运中心                           */
);

alter table tc_sfg_file add  constraint tpc_sfg_pk primary key  (tc_sfg01,tc_sfg02,tc_sfg04,tc_sfgud10) enable validate;
grant select on tc_sfg_file to tiptopgp;
grant update on tc_sfg_file to tiptopgp;
grant delete on tc_sfg_file to tiptopgp;
grant insert on tc_sfg_file to tiptopgp;
grant index on tc_sfg_file to public;
grant select on tc_sfg_file to ods;
