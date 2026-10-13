/*
================================================================================
檔案代號:tc_sfb_file
檔案名稱:工单排程表单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfb_file
(
tc_sfb01    varchar2(20) NOT NULL,   /*排程单号                               */
tc_sfb02    number(5) NOT NULL,      /*项次                                   */
tc_sfb03    varchar2(20),            /*工单单号                               */
tc_sfb04    number(5),               /*工艺序号                               */
tc_sfb05    varchar2(10),            /*工艺编号                               */
tc_sfb06    varchar2(10),            /*工作站编号                             */
tc_sfb07    number(15,3),            /*WIP量                                  */
tc_sfb08    number(15,3),            /*当日排产量                             */
tc_sfbud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_sfbud02  varchar2(40),            /*成品料号                               */
tc_sfbud03  varchar2(40),            /*转出单位                               */
tc_sfbud04  varchar2(40),            /*Lot单号                                */
tc_sfbud05  varchar2(40),            /*作业编号                               */
tc_sfbud06  varchar2(40),            /*作业名称                               */
tc_sfbud07  number(15,3),            /*标准产出量                             */
tc_sfbud08  number(15,3),            /*自订栏位-数值                          */
tc_sfbud09  number(15,3),            /*自订栏位-数值                          */
tc_sfbud10  number(10),              /*自订栏位-整数                          */
tc_sfbud11  number(10),              /*自订栏位-整数                          */
tc_sfbud12  number(10),              /*自订栏位-整数                          */
tc_sfbud13  date,                    /*自订栏位-日期                          */
tc_sfbud14  date,                    /*自订栏位-日期                          */
tc_sfbud15  date,                    /*自订栏位-日期                          */
tc_sfbplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_sfblegal varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tc_sfb_file add  constraint tpc_sfb_pk primary key  (tc_sfb01,tc_sfb02) enable validate;
grant select on tc_sfb_file to tiptopgp;
grant update on tc_sfb_file to tiptopgp;
grant delete on tc_sfb_file to tiptopgp;
grant insert on tc_sfb_file to tiptopgp;
grant index on tc_sfb_file to public;
grant select on tc_sfb_file to ods;
