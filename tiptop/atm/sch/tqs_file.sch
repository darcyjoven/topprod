/*
================================================================================
檔案代號:tqs_file
檔案名稱:合同单身费用明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqs_file
(
tqs01       varchar2(20) NOT NULL,   /*合约单号                               */
tqs02       number(5),               /*项次                                   */
tqs03       varchar2(24) NOT NULL,   /*费用科目                               */
tqs04       varchar2(10),            /*理由码                                 */
tqs05       varchar2(100),           /*补充说明                               */
tqs06       varchar2(1),             /*是否预提                               */
tqs07       varchar2(1),             /*固定折扣否                             */
tqs08       number(20,6),            /*固定折扣率                             */
tqs09       varchar2(1),             /*是否参与现金折扣                       */
tqsud01     varchar2(255),           /*自订字段-Textedit                      */
tqsud02     varchar2(40),            /*自订字段-文字                          */
tqsud03     varchar2(40),            /*自订字段-文字                          */
tqsud04     varchar2(40),            /*自订字段-文字                          */
tqsud05     varchar2(40),            /*自订字段-文字                          */
tqsud06     varchar2(40),            /*自订字段-文字                          */
tqsud07     number(15,3),            /*自订字段-数值                          */
tqsud08     number(15,3),            /*自订字段-数值                          */
tqsud09     number(15,3),            /*自订字段-数值                          */
tqsud10     number(10),              /*自订字段-整数                          */
tqsud11     number(10),              /*自订字段-整数                          */
tqsud12     number(10),              /*自订字段-整数                          */
tqsud13     date,                    /*自订字段-日期                          */
tqsud14     date,                    /*自订字段-日期                          */
tqsud15     date,                    /*自订字段-日期                          */
tqsplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqslegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index tqs_02 on tqs_file (tqs01,tqs02);
alter table tqs_file add  constraint tqs_pk primary key  (tqs01,tqs03) enable validate;
grant select on tqs_file to tiptopgp;
grant update on tqs_file to tiptopgp;
grant delete on tqs_file to tiptopgp;
grant insert on tqs_file to tiptopgp;
grant index on tqs_file to public;
grant select on tqs_file to ods;
