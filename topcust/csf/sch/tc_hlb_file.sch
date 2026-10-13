/*
================================================================================
檔案代號:tc_hlb_file
檔案名稱:RunCard单资料变更维护记录作业(单身)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_hlb_file
(
tc_hlb01    varchar2(20) NOT NULL,   /*变更申请单号                           */
tc_hlb02    number(10) NOT NULL,     /*变更申请项次                           */
tc_hlb03    varchar2(23),            /*RunCard单号                            */
tc_hlb04    varchar2(40),            /*变更来源料件编号                       */
tc_hlb05    varchar2(40),            /*变更来源工艺编号                       */
tc_hlb06    number(5),               /*变更来源版本序号                       */
tc_hlb07    varchar2(6),             /*变更起始作业编号                       */
tc_hlbud01  varchar2(255),           /*自定义字段-文字                        */
tc_hlbud02  varchar2(40),            /*工单单号                               */
tc_hlbud03  varchar2(40),            /*自定义字段-文字                        */
tc_hlbud04  varchar2(40),            /*自定义字段-文字                        */
tc_hlbud05  varchar2(40),            /*自定义字段-文字                        */
tc_hlbud06  number(15,3),            /*自定义字段-数值                        */
tc_hlbud07  number(15,3),            /*自定义字段-数值                        */
tc_hlbud08  number(15,3),            /*自定义字段-数值                        */
tc_hlbud09  number(10),              /*自定义字段-整数                        */
tc_hlbud10  number(10),              /*自定义字段-整数                        */
tc_hlbud11  number(10),              /*自定义字段-整数                        */
tc_hlbud12  date,                    /*自定义字段-日期                        */
tc_hlbud13  date,                    /*自定义字段-日期                        */
tc_hlbud14  date                     /*自定义字段-日期                        */
);

create unique index tic_hlb_01 on tc_hlb_file (tc_hlb01,tc_hlb02);
alter table tc_hlb_file add  constraint tpc_hlb_pk primary key  (tc_hlb01,tc_hlb02) enable validate;
grant select on tc_hlb_file to tiptopgp;
grant update on tc_hlb_file to tiptopgp;
grant delete on tc_hlb_file to tiptopgp;
grant insert on tc_hlb_file to tiptopgp;
grant index on tc_hlb_file to public;
grant select on tc_hlb_file to ods;
