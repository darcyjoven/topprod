/*
================================================================================
檔案代號:ccl_file
檔案名稱:在制成本当月投入金额调整资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccl_file
(
ccl01       varchar2(40) NOT NULL,   /*在制期初金额资料档工单单号             */
                                     /*工單單號                               */
ccl02       number(5) NOT NULL,      /*年度                                   */
ccl03       number(5) NOT NULL,      /*月份                                   */
ccl04       varchar2(20) NOT NULL,   /*参考单号                               */
                                     /*參考單號                               */
ccl05       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ccl21       number(15,3),            /*当月调整数量                           */
                                     /*當月調整數量 (在製品套數)              */
ccl22       number(20,6) NOT NULL,   /*当月调整金额(a+b+c+d)                  */
                                     /*當月調整金額(a+b+c+d)                  */
ccl22a      number(20,6) NOT NULL,   /*当月调整金额-材料                      */
                                     /*當月調整金額-材料                      */
ccl22b      number(20,6) NOT NULL,   /*当月调整金额-人工                      */
                                     /*當月調整金額-人工                      */
ccl22c      number(20,6) NOT NULL,   /*当月调整金额-制费                      */
                                     /*當月調整金額-製費                      */
ccl22d      number(20,6) NOT NULL,   /*当月调整金额-加工                      */
                                     /*當月調整金額-加工                      */
ccl22e      number(20,6) NOT NULL,   /*当月调整金额-其他                      */
                                     /*當月調整金額-其他                      */
cclacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ccluser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
cclgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
cclmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ccldate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccl00       varchar2(1),             /*在制调整类型                           */
                                     /*1=Actual Cost,2=Product Cost           */
ccl06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccl07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccl22f      number(20,6) DEFAULT '0',/*当月调整金额-制费三                    */
ccl22g      number(20,6) DEFAULT '0',/*当月调整金额-制费四                    */
ccl22h      number(20,6) DEFAULT '0',/*当月调整金额-制费五                    */
cclud01     varchar2(255),           /*自订字段-Textedit                      */
cclud02     varchar2(40),            /*自订字段-文字                          */
cclud03     varchar2(40),            /*自订字段-文字                          */
cclud04     varchar2(40),            /*自订字段-文字                          */
cclud05     varchar2(40),            /*自订字段-文字                          */
cclud06     varchar2(40),            /*自订字段-文字                          */
cclud07     number(15,3),            /*自订字段-数值                          */
cclud08     number(15,3),            /*自订字段-数值                          */
cclud09     number(15,3),            /*自订字段-数值                          */
cclud10     number(10),              /*自订字段-整数                          */
cclud11     number(10),              /*自订字段-整数                          */
cclud12     number(10),              /*自订字段-整数                          */
cclud13     date,                    /*自订字段-日期                          */
cclud14     date,                    /*自订字段-日期                          */
cclud15     date,                    /*自订字段-日期                          */
ccllegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccloriu     varchar2(10),            /*资料建立者                             */
cclorig     varchar2(10)             /*资料建立部门                           */
);

alter table ccl_file add  constraint ccl_pk primary key  (ccl01,ccl02,ccl03,ccl04,ccl06,ccl07) enable validate;
grant select on ccl_file to tiptopgp;
grant update on ccl_file to tiptopgp;
grant delete on ccl_file to tiptopgp;
grant insert on ccl_file to tiptopgp;
grant index on ccl_file to public;
grant select on ccl_file to ods;
