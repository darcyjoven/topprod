/*
================================================================================
檔案代號:ccb_file
檔案名稱:库存成本当月入库金额调整资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccb_file
(
ccb01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
ccb02       number(5) NOT NULL,      /*年度                                   */
ccb03       number(5) NOT NULL,      /*月份                                   */
ccb04       varchar2(20) NOT NULL,   /*参考单号                               */
                                     /*參考單號                               */
ccb05       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ccb22       number(20,6) NOT NULL,   /*当月调整金额(a+b+c+d)                  */
                                     /*當月調整金額(a+b+c+d)                  */
ccb22a      number(20,6) NOT NULL,   /*当月调整金额-材料                      */
                                     /*當月調整金額-材料                      */
ccb22b      number(20,6) NOT NULL,   /*当月调整金额-人工                      */
                                     /*當月調整金額-人工                      */
ccb22c      number(20,6) NOT NULL,   /*当月调整金额-制费                      */
                                     /*當月調整金額-製費                      */
ccb22d      number(20,6) NOT NULL,   /*当月调整金额-加工                      */
                                     /*當月調整金額-加工                      */
ccb22e      number(20,6) NOT NULL,   /*当月调整金额-其他                      */
                                     /*當月調整金額-其他                      */
ccbacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ccbuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccbgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ccbmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ccbdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccb06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccb07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccb22f      number(20,6) DEFAULT '0',/*当月调整金额-制费三                    */
ccb22g      number(20,6) DEFAULT '0',/*当月调整金额-制费四                    */
ccb22h      number(20,6) DEFAULT '0',/*当月调整金额-制费五                    */
ccbud01     varchar2(255),           /*自订字段-Textedit                      */
ccbud02     varchar2(40),            /*自订字段-文字                          */
ccbud03     varchar2(40),            /*自订字段-文字                          */
ccbud04     varchar2(40),            /*自订字段-文字                          */
ccbud05     varchar2(40),            /*自订字段-文字                          */
ccbud06     varchar2(40),            /*自订字段-文字                          */
ccbud07     number(15,3),            /*自订字段-数值                          */
ccbud08     number(15,3),            /*自订字段-数值                          */
ccbud09     number(15,3),            /*自订字段-数值                          */
ccbud10     number(10),              /*自订字段-整数                          */
ccbud11     number(10),              /*自订字段-整数                          */
ccbud12     number(10),              /*自订字段-整数                          */
ccbud13     date,                    /*自订字段-日期                          */
ccbud14     date,                    /*自订字段-日期                          */
ccbud15     date,                    /*自订字段-日期                          */
ccblegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccboriu     varchar2(10),            /*资料建立者                             */
ccborig     varchar2(10),            /*资料建立部门                           */
ccb23       varchar2(1) DEFAULT ' ' NOT NULL, /*资料来源*/
ccbglno     varchar2(20)             /*凭证编号                               */
);

alter table ccb_file add  constraint ccb_pk primary key  (ccb01,ccb02,ccb03,ccb04,ccb06,ccb07) enable validate;
grant select on ccb_file to tiptopgp;
grant update on ccb_file to tiptopgp;
grant delete on ccb_file to tiptopgp;
grant insert on ccb_file to tiptopgp;
grant index on ccb_file to public;
grant select on ccb_file to ods;
