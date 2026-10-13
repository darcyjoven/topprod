/*
================================================================================
檔案代號:tsf_file
檔案名稱:产品组合拆解单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsf_file
(
tsf01       varchar2(20) DEFAULT ' ' NOT NULL, /*拆解单号*/
tsf02       number(5) NOT NULL,      /*项次                                   */
tsf03       varchar2(40),            /*料号                                   */
tsf04       varchar2(4),             /*单位(发料单位)                         */
tsf041      number(20,8),            /*单位转换率                             */
tsf05       number(15,3),            /*数量                                   */
tsf06       varchar2(4),             /*单位一                                 */
tsf07       number(20,8),            /*单位一转换率                           */
tsf08       number(15,3),            /*单位一数量                             */
tsf09       varchar2(4),             /*单位二                                 */
tsf10       number(20,8),            /*单位二转换率                           */
tsf11       number(15,3),            /*单位二数量                             */
tsf12       varchar2(10),            /*入库仓库                               */
tsf13       varchar2(10),            /*入库库位                               */
tsf14       varchar2(24),            /*入库批号                               */
tsf15       varchar2(255),           /*备注                                   */
tsfud01     varchar2(255),           /*自订字段-Textedit                      */
tsfud02     varchar2(40),            /*自订字段-文字                          */
tsfud03     varchar2(40),            /*自订字段-文字                          */
tsfud04     varchar2(40),            /*自订字段-文字                          */
tsfud05     varchar2(40),            /*自订字段-文字                          */
tsfud06     varchar2(40),            /*自订字段-文字                          */
tsfud07     number(15,3),            /*自订字段-数值                          */
tsfud08     number(15,3),            /*自订字段-数值                          */
tsfud09     number(15,3),            /*自订字段-数值                          */
tsfud10     number(10),              /*自订字段-整数                          */
tsfud11     number(10),              /*自订字段-整数                          */
tsfud12     number(10),              /*自订字段-整数                          */
tsfud13     date,                    /*自订字段-日期                          */
tsfud14     date,                    /*自订字段-日期                          */
tsfud15     date,                    /*自订字段-日期                          */
tsfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tsf_file add  constraint tsf_pk primary key  (tsf01,tsf02) enable validate;
grant select on tsf_file to tiptopgp;
grant update on tsf_file to tiptopgp;
grant delete on tsf_file to tiptopgp;
grant insert on tsf_file to tiptopgp;
grant index on tsf_file to public;
grant select on tsf_file to ods;
