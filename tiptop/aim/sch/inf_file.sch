/*
================================================================================
檔案代號:inf_file
檔案名稱:料件批号特性变更单身
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table inf_file
(
inf01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
inf02       number(5) DEFAULT '0' NOT NULL, /*项次*/
inf03       varchar2(40),            /*料件编号                               */
inf04a      varchar2(30),            /*变更后制造批号                         */
inf04b      varchar2(30),            /*变更前制造批号                         */
inf05a      varchar2(30),            /*变更后序号                             */
inf05b      varchar2(30),            /*变更前序号                             */
inf06a      varchar2(1) DEFAULT ' ', /*变更后归属类别                         */
inf06b      varchar2(1) DEFAULT ' ', /*变更前归属类别                         */
inf07a      varchar2(20),            /*变更后归属单号                         */
inf07b      varchar2(20),            /*变更前归属单号                         */
inf08       varchar2(10),            /*特性代码                               */
inf09a      varchar2(40),            /*变更后特性值                           */
inf09b      varchar2(40),            /*变更前特性值                           */
inflegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
infplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
infud01     varchar2(255),           /*自订字段-Textedit                      */
infud02     varchar2(40),            /*自订字段-文字                          */
infud03     varchar2(40),            /*自订字段-文字                          */
infud04     varchar2(40),            /*自订字段-文字                          */
infud05     varchar2(40),            /*自订字段-文字                          */
infud06     varchar2(40),            /*自订字段-文字                          */
infud07     number(15,3),            /*自订字段-数值                          */
infud08     number(15,3),            /*自订字段-数值                          */
infud09     number(15,3),            /*自订字段-数值                          */
infud10     number(10),              /*自订字段-整数                          */
infud11     number(10),              /*自订字段-整数                          */
infud12     number(10),              /*自订字段-整数                          */
infud13     date,                    /*自订字段-日期                          */
infud14     date,                    /*自订字段-日期                          */
infud15     date,                    /*自订字段-日期                          */
inf10       number(15,3) DEFAULT '0' NOT NULL /*变更数量*/
);

alter table inf_file add  constraint inf_pk primary key  (inf01,inf02) enable validate;
grant select on inf_file to tiptopgp;
grant update on inf_file to tiptopgp;
grant delete on inf_file to tiptopgp;
grant insert on inf_file to tiptopgp;
grant index on inf_file to public;
grant select on inf_file to ods;
