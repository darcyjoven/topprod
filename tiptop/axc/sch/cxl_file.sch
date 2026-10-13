/*
================================================================================
檔案代號:cxl_file
檔案名稱:在制成本当月投入金额调整资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxl_file
(
cxl01       varchar2(20) NOT NULL,   /*工单单号                               */
                                     /*工單單號                               */
cxl012      varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
cxl02       number(5) NOT NULL,      /*年度                                   */
cxl03       number(5) NOT NULL,      /*月份                                   */
cxl04       varchar2(20) NOT NULL,   /*参考单号                               */
                                     /*參考單號                               */
cxl05       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
cxl21       number(15,3),            /*当月调整数量                           */
                                     /*當月調整數量 (在製品套數)              */
cxl22       number(20,6) NOT NULL,   /*当月调整金额(a+b+c+d)                  */
                                     /*當月調整金額(a+b+c+d)                  */
cxl22a      number(20,6) NOT NULL,   /*当月调整金额-材料                      */
                                     /*當月調整金額-材料                      */
cxl22b      number(20,6) NOT NULL,   /*当月调整金额-人工                      */
                                     /*當月調整金額-人工                      */
cxl22c      number(20,6) NOT NULL,   /*当月调整金额-制费                      */
                                     /*當月調整金額-製費                      */
cxl22d      number(20,6) NOT NULL,   /*当月调整金额-加工                      */
                                     /*當月調整金額-加工                      */
cxl22e      number(20,6) NOT NULL,   /*当月调整金额-其他                      */
                                     /*當月調整金額-其他                      */
cxlacti     varchar2(1),             /*资料有效码                             */
cxluser     varchar2(10),            /*资料所有者                             */
cxlgrup     varchar2(10),            /*资料所有部门                           */
cxlmodu     varchar2(10),            /*资料更改者                             */
cxldate     date,                    /*最近更改日                             */
cxl06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxl07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxl22f      number(20,6) DEFAULT '0',/*当月调整金额-制费三                    */
cxl22g      number(20,6) DEFAULT '0',/*当月调整金额-制费四                    */
cxl22h      number(20,6) DEFAULT '0',/*当月调整金额-制费五                    */
cxlud01     varchar2(255),           /*自订字段-Textedit                      */
cxlud02     varchar2(40),            /*自订字段-文字                          */
cxlud03     varchar2(40),            /*自订字段-文字                          */
cxlud04     varchar2(40),            /*自订字段-文字                          */
cxlud05     varchar2(40),            /*自订字段-文字                          */
cxlud06     varchar2(40),            /*自订字段-文字                          */
cxlud07     number(15,3),            /*自订字段-数值                          */
cxlud08     number(15,3),            /*自订字段-数值                          */
cxlud09     number(15,3),            /*自订字段-数值                          */
cxlud10     number(10),              /*自订字段-整数                          */
cxlud11     number(10),              /*自订字段-整数                          */
cxlud12     number(10),              /*自订字段-整数                          */
cxlud13     date,                    /*自订字段-日期                          */
cxlud14     date,                    /*自订字段-日期                          */
cxlud15     date,                    /*自订字段-日期                          */
cxllegal    varchar2(10) NOT NULL,   /*所属法人                               */
cxloriu     varchar2(10),            /*资料建立者                             */
cxlorig     varchar2(10)             /*资料建立部门                           */
);

alter table cxl_file add  constraint cxl_pk primary key  (cxl01,cxl02,cxl03,cxl04,cxl06,cxl07) enable validate;
grant select on cxl_file to tiptopgp;
grant update on cxl_file to tiptopgp;
grant delete on cxl_file to tiptopgp;
grant insert on cxl_file to tiptopgp;
grant index on cxl_file to public;
grant select on cxl_file to ods;
