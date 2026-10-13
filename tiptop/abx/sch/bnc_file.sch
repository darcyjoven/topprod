/*
================================================================================
檔案代號:bnc_file
檔案名稱:放行单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bnc_file
(
bnc01       varchar2(20) NOT NULL,   /*放行单号                               */
bnc02       number(5) NOT NULL,      /*项次                                   */
bnc03       varchar2(40),            /*料号                                   */
bnc04       varchar2(120),           /*品名规格                               */
bnc05       varchar2(4),             /*单位                                   */
bnc06       number(15,3),            /*数量                                   */
bnc07       varchar2(4),             /*币种                                   */
bnc08       number(20,6),            /*单价                                   */
bnc09       number(20,10),           /*汇率                                   */
bnc10       number(20,6),            /*台币金额                               */
bnc11       varchar2(20),            /*工单/订单号码                          */
bnc011      varchar2(20),            /*异动单据单号                           */
bnc012      number(5),               /*异动单据项次                           */
bncud01     varchar2(255),           /*自订字段-Textedit                      */
bncud02     varchar2(40),            /*自订字段-文字                          */
bncud03     varchar2(40),            /*自订字段-文字                          */
bncud04     varchar2(40),            /*自订字段-文字                          */
bncud05     varchar2(40),            /*自订字段-文字                          */
bncud06     varchar2(40),            /*自订字段-文字                          */
bncud07     number(15,3),            /*自订字段-数值                          */
bncud08     number(15,3),            /*自订字段-数值                          */
bncud09     number(15,3),            /*自订字段-数值                          */
bncud10     number(10),              /*自订字段-整数                          */
bncud11     number(10),              /*自订字段-整数                          */
bncud12     number(10),              /*自订字段-整数                          */
bncud13     date,                    /*自订字段-日期                          */
bncud14     date,                    /*自订字段-日期                          */
bncud15     date,                    /*自订字段-日期                          */
bncplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bnclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bnc_file add  constraint bnc_pk primary key  (bnc01,bnc02) enable validate;
grant select on bnc_file to tiptopgp;
grant update on bnc_file to tiptopgp;
grant delete on bnc_file to tiptopgp;
grant insert on bnc_file to tiptopgp;
grant index on bnc_file to public;
grant select on bnc_file to ods;
