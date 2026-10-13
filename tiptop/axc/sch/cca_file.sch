/*
================================================================================
檔案代號:cca_file
檔案名稱:库存期初金额OPEN资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cca_file
(
cca01       varchar2(40) NOT NULL,   /*料号                                   */
                                     /*料號                                   */
cca02       number(5) NOT NULL,      /*年度                                   */
cca03       number(5) NOT NULL,      /*月份                                   */
cca04       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
cca11       number(15,3),            /*当月期末数量                           */
                                     /*當月期末數量                           */
cca12       number(20,6),            /*当月期末金额                           */
                                     /*當月期末金額                           */
cca12a      number(20,6),            /*当月期末金额-材料                      */
                                     /*當月期末金額-材料                      */
cca12b      number(20,6),            /*当月期末金额-人工                      */
                                     /*當月期末金額-人工                      */
cca12c      number(20,6),            /*当月期末金额-制费                      */
                                     /*當月期末金額-製費                      */
cca12d      number(20,6),            /*当月期末金额-加工                      */
                                     /*當月期末金額-加工                      */
cca12e      number(20,6),            /*当月期末金额-其他                      */
                                     /*當月期末金額-其他                      */
cca23       number(20,6),            /*当月平均单价(a+b+c+d+e)                */
                                     /*當月平均單價(a+b+c+d+e)                */
cca23a      number(20,6),            /*当月平均单价-材料   (a)                */
                                     /*當月平均單價-材料   (a)                */
cca23b      number(20,6),            /*当月平均单价-人工   (b)                */
                                     /*當月平均單價-人工   (b)                */
cca23c      number(20,6),            /*当月平均单价-制费   (c)                */
                                     /*當月平均單價-製費   (c)                */
cca23d      number(20,6),            /*当月平均单价-加工   (d)                */
                                     /*當月平均單價-加工   (d)                */
cca23e      number(20,6),            /*当月平均单价-其他   (e)                */
                                     /*當月平均單價-其他   (e)                */
ccaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ccauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ccamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ccadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cca06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cca07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cca12f      number(20,6) DEFAULT '0',/*当月期末金额-制费三                    */
cca12g      number(20,6) DEFAULT '0',/*当月期末金额-制费四                    */
cca12h      number(20,6) DEFAULT '0',/*当月期末金额-制费五                    */
cca23f      number(20,6) DEFAULT '0',/*当月平均单价-制费三                    */
cca23g      number(20,6) DEFAULT '0',/*当月平均单价-制费四                    */
cca23h      number(20,6) DEFAULT '0',/*当月平均单价-制费五                    */
ccaud01     varchar2(255),           /*自订字段-Textedit                      */
ccaud02     varchar2(40),            /*自订字段-文字                          */
ccaud03     varchar2(40),            /*自订字段-文字                          */
ccaud04     varchar2(40),            /*自订字段-文字                          */
ccaud05     varchar2(40),            /*自订字段-文字                          */
ccaud06     varchar2(40),            /*自订字段-文字                          */
ccaud07     number(15,3),            /*自订字段-数值                          */
ccaud08     number(15,3),            /*自订字段-数值                          */
ccaud09     number(15,3),            /*自订字段-数值                          */
ccaud10     number(10),              /*自订字段-整数                          */
ccaud11     number(10),              /*自订字段-整数                          */
ccaud12     number(10),              /*自订字段-整数                          */
ccaud13     date,                    /*自订字段-日期                          */
ccaud14     date,                    /*自订字段-日期                          */
ccaud15     date,                    /*自订字段-日期                          */
ccalegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccaoriu     varchar2(10),            /*资料建立者                             */
ccaorig     varchar2(10)             /*资料建立部门                           */
);

alter table cca_file add  constraint cca_pk primary key  (cca01,cca02,cca03,cca06,cca07) enable validate;
grant select on cca_file to tiptopgp;
grant update on cca_file to tiptopgp;
grant delete on cca_file to tiptopgp;
grant insert on cca_file to tiptopgp;
grant index on cca_file to public;
grant select on cca_file to ods;
