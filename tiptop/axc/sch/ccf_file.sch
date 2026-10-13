/*
================================================================================
檔案代號:ccf_file
檔案名稱:再制期初金额OPEN资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccf_file
(
ccf01       varchar2(40) NOT NULL,   /*工单单号重覆性生产产品成本             */
                                     /*工單編號                               */
ccf02       number(5) NOT NULL,      /*年度                                   */
ccf03       number(5) NOT NULL,      /*月份                                   */
ccf04       varchar2(40) NOT NULL,   /*元件料号                               */
                                     /*元件料號                               */
ccf05       varchar2(1) NOT NULL,    /*元件料号类型                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
ccf11       number(15,3) NOT NULL,   /*当月期末数量                           */
                                     /*當月期末數量                           */
ccf12       number(20,6) NOT NULL,   /*当月期末金额                           */
                                     /*當月期末金額                           */
ccf12a      number(20,6) NOT NULL,   /*当月期末金额-材料                      */
                                     /*當月期末金額-材料                      */
ccf12b      number(20,6) NOT NULL,   /*当月期末金额-人工                      */
                                     /*當月期末金額-人工                      */
ccf12c      number(20,6) NOT NULL,   /*当月期末金额-制费                      */
                                     /*當月期末金額-製費                      */
ccf12d      number(20,6) NOT NULL,   /*当月期末金额-加工                      */
                                     /*當月期末金額-加工                      */
ccf12e      number(20,6) NOT NULL,   /*当月期末金额-其他                      */
                                     /*當月期末金額-其他                      */
ccfacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
ccfuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
ccfgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
ccfmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
ccfdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
ccf00       varchar2(1),             /*在制开帐类型                           */
                                     /*1=Actual Cost,2=Product Cost           */
ccf06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccf07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccf12f      number(20,6) DEFAULT '0',/*当月期末金额-制费三                    */
ccf12g      number(20,6) DEFAULT '0',/*当月期末金额-制费四                    */
ccf12h      number(20,6) DEFAULT '0',/*当月期末金额-制费五                    */
ccfud01     varchar2(255),           /*自订字段-Textedit                      */
ccfud02     varchar2(40),            /*自订字段-文字                          */
ccfud03     varchar2(40),            /*自订字段-文字                          */
ccfud04     varchar2(40),            /*自订字段-文字                          */
ccfud05     varchar2(40),            /*自订字段-文字                          */
ccfud06     varchar2(40),            /*自订字段-文字                          */
ccfud07     number(15,3),            /*自订字段-数值                          */
ccfud08     number(15,3),            /*自订字段-数值                          */
ccfud09     number(15,3),            /*自订字段-数值                          */
ccfud10     number(10),              /*自订字段-整数                          */
ccfud11     number(10),              /*自订字段-整数                          */
ccfud12     number(10),              /*自订字段-整数                          */
ccfud13     date,                    /*自订字段-日期                          */
ccfud14     date,                    /*自订字段-日期                          */
ccfud15     date,                    /*自订字段-日期                          */
ccflegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccforiu     varchar2(10),            /*资料建立者                             */
ccforig     varchar2(10)             /*资料建立部门                           */
);

alter table ccf_file add  constraint ccf_pk primary key  (ccf01,ccf02,ccf03,ccf04,ccf06,ccf07) enable validate;
grant select on ccf_file to tiptopgp;
grant update on ccf_file to tiptopgp;
grant delete on ccf_file to tiptopgp;
grant insert on ccf_file to tiptopgp;
grant index on ccf_file to public;
grant select on ccf_file to ods;
