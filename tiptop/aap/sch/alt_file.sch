/*
================================================================================
檔案代號:alt_file
檔案名稱:提单料件单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alt_file
(
alt01       varchar2(20) NOT NULL,   /*到货单号                               */
                                     /*到貨單號                               */
alt02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
alt05       number(20,6),            /*单价                                   */
                                     /*單價                                   */
alt06       number(15,3),            /*到货数量                               */
                                     /*到貨數量                               */
alt07       number(20,6),            /*金额                                   */
                                     /*金額                                   */
alt11       varchar2(40),            /*料号                                   */
                                     /*料號                                   */
alt14       varchar2(20),            /*采购单号                               */
                                     /*採購單號                               */
alt15       number(5),               /*采购项次                               */
                                     /*採購項次                               */
alt930      varchar2(10),            /*成本中心                               */
alt80       varchar2(4),             /*单位一                                 */
alt81       number(20,8),            /*单位一换算率(与库存单位)               */
alt82       number(15,3),            /*单位一数量                             */
alt83       varchar2(4),             /*单位二                                 */
alt84       number(20,8),            /*单位二换算率(与库存单位)               */
alt85       number(15,3),            /*单位二数量                             */
alt86       varchar2(4),             /*计价单位                               */
alt87       number(15,3),            /*计价单位                               */
altud01     varchar2(255),           /*自订字段-Textedit                      */
altud02     varchar2(40),            /*自订字段-文字                          */
altud03     varchar2(40),            /*自订字段-文字                          */
altud04     varchar2(40),            /*自订字段-文字                          */
altud05     varchar2(40),            /*自订字段-文字                          */
altud06     varchar2(40),            /*自订字段-文字                          */
altud07     number(15,3),            /*自订字段-数值                          */
altud08     number(15,3),            /*自订字段-数值                          */
altud09     number(15,3),            /*自订字段-数值                          */
altud10     number(10),              /*自订字段-整数                          */
altud11     number(10),              /*自订字段-整数                          */
altud12     number(10),              /*自订字段-整数                          */
altud13     date,                    /*自订字段-日期                          */
altud14     date,                    /*自订字段-日期                          */
altud15     date,                    /*自订字段-日期                          */
altlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index alt_02 on alt_file (alt14);
create        index alt_03 on alt_file (alt11);
alter table alt_file add  constraint alt_pk primary key  (alt01,alt02) enable validate;
grant select on alt_file to tiptopgp;
grant update on alt_file to tiptopgp;
grant delete on alt_file to tiptopgp;
grant insert on alt_file to tiptopgp;
grant index on alt_file to public;
grant select on alt_file to ods;
