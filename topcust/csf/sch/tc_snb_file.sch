/*
================================================================================
檔案代號:tc_snb_file
檔案名稱:维修调拨单单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_snb_file
(
tc_snb01    varchar2(20) NOT NULL,   /*维修单号                     */
tc_snb02    number(5) NOT NULL,      /*项次                                   */
tc_sna03    varchar2(20),            /*lot单号                      */
tc_sna04    varchar2(20),            /*工单单号                               */
tc_sna05       number(5),             /*工艺序号                               */                                    
tc_sna06      varchar2(10),            /*工作中心                               */
tc_sna07     varchar2(6),             /*作业编号                               */
tc_sna08      varchar2(80),            /*作业名称                               */                                    
tc_snb09    varchar2(40),            /*料号                                   */
tc_snb10    number(15,3),            /*调拨数量                               */
tc_snb11    number(15,3),            /*实发数量                               */
tc_snb12    varchar2(4),             /*发料单位                               */
tc_snbud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_snbud02  varchar2(40),            /*自订栏位-文字                          */
tc_snbud03  varchar2(40),            /*自订栏位-文字                          */
tc_snbud04  varchar2(40),            /*自订栏位-文字                          */
tc_snbud05  varchar2(40),            /*自订栏位-文字                          */
tc_snbud06  varchar2(40),            /*自订栏位-文字                          */
tc_snbud07  number(15,3),            /*自订栏位-数值                          */
tc_snbud08  number(15,3),            /*自订栏位-数值                          */
tc_snbud09  number(15,3),            /*自订栏位-数值                          */
tc_snbud10  number(10),              /*自订栏位-整数                          */
tc_snbud11  number(10),              /*自订栏位-整数                          */
tc_snbud12  number(10),              /*自订栏位-整数                          */
tc_snbud13  date,                    /*自订栏位-日期                          */
tc_snbud14  date,                    /*自订栏位-日期                          */
tc_snbud15  date,                    /*自订栏位-日期                          */
tc_snbplant varchar2(10),            /*所属营运中心                           */
tc_snblegal varchar2(10)             /*所属法人                               */
);

alter table tc_snb_file add  constraint tpc_sfs_pk primary key  (tc_snb01,tc_snb02) enable validate;
grant select on tc_snb_file to tiptopgp;
grant update on tc_snb_file to tiptopgp;
grant delete on tc_snb_file to tiptopgp;
grant insert on tc_snb_file to tiptopgp;
grant index on tc_snb_file to public;
grant select on tc_snb_file to ods;
