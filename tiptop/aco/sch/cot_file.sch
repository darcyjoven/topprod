/*
================================================================================
檔案代號:cot_file
檔案名稱:进口设备征免证明明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cot_file
(
cot01       varchar2(20) NOT NULL,   /*申请编号                               */
cot02       number(5) NOT NULL,      /*项次                                   */
cot03       varchar2(20),            /*海关编号                               */
cot04       varchar2(80),            /*中文名称                               */
cot05       varchar2(80),            /*申请名称                               */
cot06       varchar2(120),           /*规格型号                               */
cot07       varchar2(10),            /*原产地                                 */
cot08       number(15,3),            /*数量                                   */
cot09       varchar2(4),             /*单位                                   */
cot10       number(20,6),            /*单价                                   */
cot11       varchar2(20),            /*新旧程度                               */
cot12       number(15,3),            /*净重                                   */
cot13       number(15,3),            /*毛重                                   */
cot14       varchar2(6),             /*包装材质                               */
cot15       number(5),               /*箱数                                   */
cot16       number(5),               /*箱/栈板                                */
cot17       varchar2(11),            /*体积                                   */
cot18       varchar2(1),             /*是否列入固定资产                       */
cot19       varchar2(10),            /*固定资产代码                           */
cot191      varchar2(4),             /*附号                                   */
cot20       varchar2(10),            /*费用代码                               */
cot21       varchar2(10),            /*使用部门                               */
cotud01     varchar2(255),           /*自订字段-Textedit                      */
cotud02     varchar2(40),            /*自订字段-文字                          */
cotud03     varchar2(40),            /*自订字段-文字                          */
cotud04     varchar2(40),            /*自订字段-文字                          */
cotud05     varchar2(40),            /*自订字段-文字                          */
cotud06     varchar2(40),            /*自订字段-文字                          */
cotud07     number(15,3),            /*自订字段-数值                          */
cotud08     number(15,3),            /*自订字段-数值                          */
cotud09     number(15,3),            /*自订字段-数值                          */
cotud10     number(10),              /*自订字段-整数                          */
cotud11     number(10),              /*自订字段-整数                          */
cotud12     number(10),              /*自订字段-整数                          */
cotud13     date,                    /*自订字段-日期                          */
cotud14     date,                    /*自订字段-日期                          */
cotud15     date,                    /*自订字段-日期                          */
cotplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cotlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cot_file add  constraint cot_pk primary key  (cot01,cot02) enable validate;
grant select on cot_file to tiptopgp;
grant update on cot_file to tiptopgp;
grant delete on cot_file to tiptopgp;
grant insert on cot_file to tiptopgp;
grant index on cot_file to public;
grant select on cot_file to ods;
