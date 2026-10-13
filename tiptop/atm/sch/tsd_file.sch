/*
================================================================================
檔案代號:tsd_file
檔案名稱:产品组合单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsd_file
(
tsd01       varchar2(20) DEFAULT ' ' NOT NULL, /*组合单号*/
tsd02       number(5) NOT NULL,      /*项次                                   */
tsd03       varchar2(40),            /*料号                                   */
tsd04       varchar2(4),             /*单位(发料单位)                         */
tsd041      number(20,8),            /*单位转换率                             */
tsd05       number(15,3),            /*数量                                   */
tsd06       varchar2(4),             /*单位一                                 */
tsd07       number(20,8),            /*单位一转换率                           */
tsd08       number(15,3),            /*单位一数量                             */
tsd09       varchar2(4),             /*单位二                                 */
tsd10       number(20,8),            /*单位二转换率                           */
tsd11       number(15,3),            /*单位二数量                             */
tsd12       varchar2(10),            /*出库仓库                               */
tsd13       varchar2(10),            /*出库库位                               */
tsd14       varchar2(24),            /*出库批号                               */
tsd15       varchar2(255),           /*备注                                   */
tsdud01     varchar2(255),           /*自订字段-Textedit                      */
tsdud02     varchar2(40),            /*自订字段-文字                          */
tsdud03     varchar2(40),            /*自订字段-文字                          */
tsdud04     varchar2(40),            /*自订字段-文字                          */
tsdud05     varchar2(40),            /*自订字段-文字                          */
tsdud06     varchar2(40),            /*自订字段-文字                          */
tsdud07     number(15,3),            /*自订字段-数值                          */
tsdud08     number(15,3),            /*自订字段-数值                          */
tsdud09     number(15,3),            /*自订字段-数值                          */
tsdud10     number(10),              /*自订字段-整数                          */
tsdud11     number(10),              /*自订字段-整数                          */
tsdud12     number(10),              /*自订字段-整数                          */
tsdud13     date,                    /*自订字段-日期                          */
tsdud14     date,                    /*自订字段-日期                          */
tsdud15     date,                    /*自订字段-日期                          */
tsdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsd_file add  constraint tsd_pk primary key  (tsd01,tsd02) enable validate;
grant select on tsd_file to tiptopgp;
grant update on tsd_file to tiptopgp;
grant delete on tsd_file to tiptopgp;
grant insert on tsd_file to tiptopgp;
grant index on tsd_file to public;
grant select on tsd_file to ods;
