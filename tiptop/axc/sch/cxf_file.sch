/*
================================================================================
檔案代號:cxf_file
檔案名稱:在制期初金额开账资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxf_file
(
cxf01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
cxf012      varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
cxf02       number(5) NOT NULL,      /*年度                                   */
cxf03       number(5) NOT NULL,      /*月份                                   */
cxf04       varchar2(40) NOT NULL,   /*元件料号                               */
                                     /*元件料號                               */
cxf05       varchar2(1) NOT NULL,    /*元件料号类型                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
cxf11       number(15,3),            /*当月期末数量                           */
                                     /*當月期末數量                           */
cxf12       number(20,6),            /*当月期末金额                           */
                                     /*當月期末金額                           */
cxf12a      number(20,6),            /*当月期末金额-材料                      */
                                     /*當月期末金額-材料                      */
cxf12b      number(20,6),            /*当月期末金额-人工                      */
                                     /*當月期末金額-人工                      */
cxf12c      number(20,6),            /*当月期末金额-制费                      */
                                     /*當月期末金額-製費                      */
cxf12d      number(20,6),            /*当月期末金额-加工                      */
                                     /*當月期末金額-加工                      */
cxf12e      number(20,6),            /*当月期末金额-其他                      */
                                     /*當月期末金額-其他                      */
cxfacti     varchar2(1),             /*资料有效码                             */
cxfuser     varchar2(10),            /*资料所有者                             */
cxfgrup     varchar2(10),            /*资料所有部门                           */
cxfmodu     varchar2(10),            /*资料更改者                             */
cxfdate     date,                    /*最近更改日                             */
cxf06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxf07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxf12f      number(20,6) DEFAULT '0',/*当月期末金额-制费三                    */
cxf12g      number(20,6) DEFAULT '0',/*当月期末金额-制费四                    */
cxf12h      number(20,6) DEFAULT '0',/*当月期末金额-制费五                    */
cxfud01     varchar2(255),           /*自订字段-Textedit                      */
cxfud02     varchar2(40),            /*自订字段-文字                          */
cxfud03     varchar2(40),            /*自订字段-文字                          */
cxfud04     varchar2(40),            /*自订字段-文字                          */
cxfud05     varchar2(40),            /*自订字段-文字                          */
cxfud06     varchar2(40),            /*自订字段-文字                          */
cxfud07     number(15,3),            /*自订字段-数值                          */
cxfud08     number(15,3),            /*自订字段-数值                          */
cxfud09     number(15,3),            /*自订字段-数值                          */
cxfud10     number(10),              /*自订字段-整数                          */
cxfud11     number(10),              /*自订字段-整数                          */
cxfud12     number(10),              /*自订字段-整数                          */
cxfud13     date,                    /*自订字段-日期                          */
cxfud14     date,                    /*自订字段-日期                          */
cxfud15     date,                    /*自订字段-日期                          */
cxflegal    varchar2(10) NOT NULL,   /*所属法人                               */
cxforiu     varchar2(10),            /*资料建立者                             */
cxforig     varchar2(10)             /*资料建立部门                           */
);

create        index cxf_01 on cxf_file (cxf01,cxf012,cxf02,cxf03,cxf04);
alter table cxf_file add  constraint cxf_pk primary key  (cxf01,cxf02,cxf03,cxf04,cxf06,cxf07) enable validate;
grant select on cxf_file to tiptopgp;
grant update on cxf_file to tiptopgp;
grant delete on cxf_file to tiptopgp;
grant insert on cxf_file to tiptopgp;
grant index on cxf_file to public;
grant select on cxf_file to ods;
