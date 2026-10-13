/*
================================================================================
檔案代號:fbh_file
檔案名稱:固定资产报废/销账单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbh_file
(
fbh01       varchar2(20) NOT NULL,   /*报废/销帐单号                          */
fbh02       number(5) NOT NULL,      /*项次                                   */
fbh03       varchar2(10),            /*财产编号                               */
fbh031      varchar2(4),             /*附号                                   */
fbh04       number(5),               /*数量                                   */
fbh05       varchar2(10),            /*原因                                   */
fbh06       number(20,6),            /*本币成本                               */
fbh07       number(20,6),            /*累计折旧                               */
fbh08       number(20,6),            /*未折减额                               */
fbh09       number(20,6),            /*税签本币成本                           */
fbh10       number(20,6),            /*税签累计折旧                           */
fbh11       number(20,6),            /*税签未折减额                           */
fbh12       number(20,6),            /*已计提减值准备                         */
                                     /*Listed  Devalue Preparative #No:A099   */
fbh13       number(20,6),            /*税签减值准备                           */
                                     /*Depreciation-Tax Devalue Preparative #No:A099*/
fbhud01     varchar2(255),           /*自订字段-Textedit                      */
fbhud02     varchar2(40),            /*自订字段-文字                          */
fbhud03     varchar2(40),            /*自订字段-文字                          */
fbhud04     varchar2(40),            /*自订字段-文字                          */
fbhud05     varchar2(40),            /*自订字段-文字                          */
fbhud06     varchar2(40),            /*自订字段-文字                          */
fbhud07     number(15,3),            /*自订字段-数值                          */
fbhud08     number(15,3),            /*自订字段-数值                          */
fbhud09     number(15,3),            /*自订字段-数值                          */
fbhud10     number(10),              /*自订字段-整数                          */
fbhud11     number(10),              /*自订字段-整数                          */
fbhud12     number(10),              /*自订字段-整数                          */
fbhud13     date,                    /*自订字段-日期                          */
fbhud14     date,                    /*自订字段-日期                          */
fbhud15     date,                    /*自订字段-日期                          */
fbhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbh062      number(20,6) DEFAULT '0' NOT NULL, /*成本(财签二)*/
fbh072      number(20,6) DEFAULT '0' NOT NULL, /*累折(财签二)*/
fbh082      number(20,6) DEFAULT '0' NOT NULL, /*未折减额(财签二)*/
fbh122      number(20,6) DEFAULT '0' NOT NULL /*已计提减值准备(财签二)*/
);

alter table fbh_file add  constraint fbh_pk primary key  (fbh01,fbh02) enable validate;
grant select on fbh_file to tiptopgp;
grant update on fbh_file to tiptopgp;
grant delete on fbh_file to tiptopgp;
grant insert on fbh_file to tiptopgp;
grant index on fbh_file to public;
grant select on fbh_file to ods;
