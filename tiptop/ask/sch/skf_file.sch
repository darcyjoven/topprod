/*
================================================================================
檔案代號:skf_file
檔案名稱:裁床表档
檔案目的:裁床表单头档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skf_file
(
skf01       varchar2(20) DEFAULT ' ' NOT NULL, /*pbi单号*/
skf02       varchar2(80) DEFAULT ' ' NOT NULL, /*款式编号*/
skf03       number(10) DEFAULT '0' NOT NULL, /*床号*/
skf04       date DEFAULT sysdate NOT NULL, /*日期*/
skf05       varchar2(40) DEFAULT ' ' NOT NULL, /*布料料号*/
skf06       varchar2(255),           /*备注                                   */
skf07       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
skfacti     varchar2(1),             /*资料有效码                             */
skfdate     date,                    /*最近更改日                             */
skfgrup     varchar2(10),            /*资料所属群组                           */
skfmodu     varchar2(10),            /*资料更改者                             */
skfuser     varchar2(10),            /*资料所有者                             */
skfud01     varchar2(255),           /*自订字段-Textedit                      */
skfud02     varchar2(40),            /*自订字段-文字                          */
skfud03     varchar2(40),            /*自订字段-文字                          */
skfud04     varchar2(40),            /*自订字段-文字                          */
skfud05     varchar2(40),            /*自订字段-文字                          */
skfud06     varchar2(40),            /*自订字段-文字                          */
skfud07     number(15,3),            /*自订字段-数值                          */
skfud08     number(15,3),            /*自订字段-数值                          */
skfud09     number(15,3),            /*自订字段-数值                          */
skfud10     number(10),              /*自订字段-整数                          */
skfud11     number(10),              /*自订字段-整数                          */
skfud12     number(10),              /*自订字段-整数                          */
skfud13     date,                    /*自订字段-日期                          */
skfud14     date,                    /*自订字段-日期                          */
skfud15     date,                    /*自订字段-日期                          */
skfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skflegal    varchar2(10) NOT NULL,   /*所属法人                               */
skforig     varchar2(10),            /*资料建立部门                           */
skforiu     varchar2(10)             /*资料建立者                             */
);

alter table skf_file add  constraint skf_pk primary key  (skf01,skf02,skf03) enable validate;
grant select on skf_file to tiptopgp;
grant update on skf_file to tiptopgp;
grant delete on skf_file to tiptopgp;
grant insert on skf_file to tiptopgp;
grant index on skf_file to public;
grant select on skf_file to ods;
