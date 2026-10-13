/*
================================================================================
檔案代號:tc_omb_file
檔案名稱:出货单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_omb_file
(
tc_omb001   number(5) NOT NULL,      /*年度                                   */
tc_omb002   number(5) NOT NULL,      /*月份                                   */
tc_omb003   varchar2(20),            /*凭证编号                               */
tc_omb005   number(5) NOT NULL,
tc_omb01    varchar2(20) NOT NULL,   /*出货单号                               */
tc_omb02    date,                    /*出货日期                               */
tc_omb03    varchar2(10),            /*帐款客户编号                           */
tc_omb032   varchar2(40),            /*帐款客户简称                           */
tc_omb04    varchar2(10),            /*送货客户编号                           */
tc_omb042   varchar2(40),            /*帐款客户简称                           */
tc_omb05    varchar2(10),            /*人员编号                               */
tc_omb06    varchar2(10),            /*部门编号                               */
tc_omb07    varchar2(4),             /*税别                                   */
tc_omb08    number(9,4),             /*税率                                   */
tc_omb10    number(5) NOT NULL,      /*项次                                   */
tc_omb11    varchar2(40),            /*产品编号                               */
tc_omb12    varchar2(4),             /*销售单位                               */
tc_omb13    varchar2(120),           /*品名规格                               */
tc_omb14    varchar2(10),            /*额外品名编号                           */
tc_omb15    varchar2(20),            /*订单单号                               */
tc_omb16    number(5),               /*订单项次                               */
tc_omb17    varchar2(4),             /*币别                                   */
tc_omb18    number(20,10),           /*汇率                                   */
tc_omb19    number(15,3) NOT NULL,   /*实际出货数量                           */
tc_omb20    number(15,3) NOT NULL,   /*已开发票数量                           */
tc_omb21    number(15,3) NOT NULL,   /*未开发票数量                           */
tc_omb22    number(20,6) NOT NULL,   /*原币单价                               */
tc_omb23    varchar2(24) NOT NULL,   /*主营业务收入科目编号                   */
tc_omb24    number(20,6) NOT NULL,   /*原币未税金额                           */
tc_omb25    varchar2(24) NOT NULL,   /*税金科目编号                           */
tc_omb26    number(20,6) NOT NULL,   /*原币税额                               */
tc_omb27    varchar2(24) NOT NULL,   /*应收账款科目编号                       */
tc_omb28    number(20,6) NOT NULL,   /*原币含税金额                           */
tc_omb29    number(20,6) NOT NULL,   /*本币未税金额                           */
tc_omb30    number(20,6) NOT NULL,   /*本币税额                               */
tc_omb31    number(20,6) NOT NULL,   /*本币含税金额                           */
tc_omb50    varchar2(255),           /*No Use                                 */
tc_omb51    varchar2(80),            /*No Use                                 */
tc_omb52    varchar2(80),            /*No Use                                 */
tc_omb901   varchar2(80),            /*No Use                                 */
tc_omb902   varchar2(40),            /*成本凭证编号                           */
tc_omb903   varchar2(40),            /*主营业务成本科目编号                   */
tc_omb904   varchar2(40),            /*存货科目编号                           */
tc_omb905   varchar2(40),            /*No Use                                 */
tc_omb906   varchar2(80),            /*No Use                                 */
tc_omb907   varchar2(80),            /*No Use                                 */
tc_ombud01  varchar2(255),           /*自订栏位-Textedit                      */
tc_ombud02  varchar2(40),            /*自订栏位-文字                          */
tc_ombud03  varchar2(40),            /*自订栏位-文字                          */
tc_ombud04  varchar2(40),            /*自订栏位-文字                          */
tc_ombud05  varchar2(40),            /*自订栏位-文字                          */
tc_ombud06  varchar2(40),            /*自订栏位-文字                          */
tc_ombud07  number(15,3),            /*自订栏位-数值                          */
tc_ombud08  number(15,3),            /*自订栏位-数值                          */
tc_ombud09  number(15,3),            /*自订栏位-数值                          */
tc_ombud10  number(10),              /*自订栏位-整数                          */
tc_ombud11  number(10),              /*自订栏位-整数                          */
tc_ombud12  number(10),              /*自订栏位-整数                          */
tc_ombud13  date,                    /*自订栏位-日期                          */
tc_ombud14  date,                    /*自订栏位-日期                          */
tc_ombud15  date,                    /*自订栏位-日期                          */
tc_omb908   number(20,6),            /*单位销售成本                           */
tc_omb909   number(20,6)             /*销售成本金额                           */
);

alter table tc_omb_file add  constraint tpc_omb_pk primary key  (tc_omb001,tc_omb002,tc_omb005) enable validate;
grant select on tc_omb_file to tiptopgp;
grant update on tc_omb_file to tiptopgp;
grant delete on tc_omb_file to tiptopgp;
grant insert on tc_omb_file to tiptopgp;
grant index on tc_omb_file to public;
grant select on tc_omb_file to ods;
