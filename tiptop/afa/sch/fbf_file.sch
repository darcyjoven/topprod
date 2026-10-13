/*
================================================================================
檔案代號:fbf_file
檔案名稱:固定资产出售单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbf_file
(
fbf01       varchar2(20) NOT NULL,   /*出售单号                               */
fbf02       number(5) NOT NULL,      /*项次                                   */
fbf03       varchar2(10),            /*财产编号                               */
fbf031      varchar2(4),             /*附号                                   */
fbf04       number(5),               /*数量                                   */
fbf05       varchar2(10),            /*原因                                   */
fbf06       number(20,6),            /*原币出售金额                           */
fbf07       number(20,6),            /*本币出售金额                           */
fbf08       number(20,6),            /*未折减额                               */
fbf09       number(20,6),            /*处份损益                               */
fbf10       number(20,6),            /*税签未折减额                           */
fbf11       number(20,6),            /*已计提减值准备                         */
                                     /*Listed  Devalue Preparative #No:A099   */
fbf12       number(20,6),            /*税签减值准备                           */
                                     /*Depreciation-Tax Devalue Preparative #No:A099*/
fbfud01     varchar2(255),           /*自订字段-Textedit                      */
fbfud02     varchar2(40),            /*自订字段-文字                          */
fbfud03     varchar2(40),            /*自订字段-文字                          */
fbfud04     varchar2(40),            /*自订字段-文字                          */
fbfud05     varchar2(40),            /*自订字段-文字                          */
fbfud06     varchar2(40),            /*自订字段-文字                          */
fbfud07     number(15,3),            /*自订字段-数值                          */
fbfud08     number(15,3),            /*自订字段-数值                          */
fbfud09     number(15,3),            /*自订字段-数值                          */
fbfud10     number(10),              /*自订字段-整数                          */
fbfud11     number(10),              /*自订字段-整数                          */
fbfud12     number(10),              /*自订字段-整数                          */
fbfud13     date,                    /*自订字段-日期                          */
fbfud14     date,                    /*自订字段-日期                          */
fbfud15     date,                    /*自订字段-日期                          */
fbflegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbf072      number(20,6) DEFAULT '0' NOT NULL, /*本币出售金额(财签二*/
fbf082      number(20,6) DEFAULT '0' NOT NULL, /*未折减额(财签二)*/
fbf092      number(20,6) DEFAULT '0' NOT NULL, /*处份损益(财签二)*/
fbf112      number(20,6) DEFAULT '0' NOT NULL /*已提列减值准备(财签二)*/
);

alter table fbf_file add  constraint fbf_pk primary key  (fbf01,fbf02) enable validate;
grant select on fbf_file to tiptopgp;
grant update on fbf_file to tiptopgp;
grant delete on fbf_file to tiptopgp;
grant insert on fbf_file to tiptopgp;
grant index on fbf_file to public;
grant select on fbf_file to ods;
