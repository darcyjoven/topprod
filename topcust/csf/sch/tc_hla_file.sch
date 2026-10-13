/*
================================================================================
檔案代號:tc_hla_file
檔案名稱:run-card单变更资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_hla_file
(
tc_hla01    varchar2(20) NOT NULL,   /*变更申请单号                           */
tc_hla02    date,                    /*变更日期                               */
tc_hla03    varchar2(20),            /*变更申请人                             */
tc_hla04    varchar2(1),             /*审核否                                 */
tc_hla05    date,                    /*审核日期                               */
tc_hla06    varchar2(10),            /*审核人                                 */
tc_hla07    varchar2(40),            /*变更来源料件编号                       */
tc_hla08    varchar2(40),            /*变更来源工艺编号                       */
tc_hla09    number(5),               /*变更来源版本序号                       */
tc_hla10    varchar2(6),             /*变更起始作业编号                       */
tc_hla11    varchar2(255),           /*备注                                   */
tc_hlaud01  varchar2(255),           /*自定义字段-文字                        */
tc_hlaud02  varchar2(40),            /*自定义字段-文字                        */
tc_hlaud03  varchar2(40),            /*自定义字段-文字                        */
tc_hlaud04  varchar2(40),            /*自定义字段-文字                        */
tc_hlaud05  varchar2(40),            /*自定义字段-文字                        */
tc_hlaud06  number(15,3),            /*自定义字段-数值                        */
tc_hlaud07  number(15,3),            /*自定义字段-数值                        */
tc_hlaud08  number(15,3),            /*自定义字段-数值                        */
tc_hlaud09  number(10),              /*自定义字段-整数                        */
tc_hlaud10  number(10),              /*自定义字段-整数                        */
tc_hlaud11  number(10),              /*自定义字段-整数                        */
tc_hlaud12  date,                    /*自定义字段-日期                        */
tc_hlaud13  date,                    /*自定义字段-日期                        */
tc_hlaud14  date                     /*自定义字段-日期                        */
);

create unique index tic_hla_01 on tc_hla_file (tc_hla01);
alter table tc_hla_file add  constraint tpc_hla_pk primary key  (tc_hla01) enable validate;
grant select on tc_hla_file to tiptopgp;
grant update on tc_hla_file to tiptopgp;
grant delete on tc_hla_file to tiptopgp;
grant insert on tc_hla_file to tiptopgp;
grant index on tc_hla_file to public;
grant select on tc_hla_file to ods;
