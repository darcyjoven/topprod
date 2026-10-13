/*
================================================================================
檔案代號:bzb_file
檔案名稱:保税机器设备单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bzb_file
(
bzb01       varchar2(20) NOT NULL,   /*机器设备编号                           */
bzb02       number(5) NOT NULL,      /*序号                                   */
bzb03       varchar2(10),            /*保管部门                               */
bzb04       varchar2(10),            /*保管人                                 */
bzb05       number(15,3),            /*数量                                   */
bzb06       varchar2(30),            /*放置地点                               */
bzb07       number(15,3),            /*帐面结余数量                           */
bzb08       varchar2(1),             /*状态码                                 */
                                     /*1.Normal 2.Retire 3.Charge Office      */
bzb09       date,                    /*报废/除帐日期                          */
bzb10       number(15,3),            /*外送数量                               */
bzb11       number(15,3),            /*收回数量                               */
bzb12       number(15,3),            /*报废数量                               */
bzb13       number(15,3),            /*除帐数量                               */
bzb14       varchar2(255),           /*备注                                   */
bzb15       varchar2(1),             /*No Use                                 */
bzbud01     varchar2(255),           /*自订字段-Textedit                      */
bzbud02     varchar2(40),            /*自订字段-文字                          */
bzbud03     varchar2(40),            /*自订字段-文字                          */
bzbud04     varchar2(40),            /*自订字段-文字                          */
bzbud05     varchar2(40),            /*自订字段-文字                          */
bzbud06     varchar2(40),            /*自订字段-文字                          */
bzbud07     number(15,3),            /*自订字段-数值                          */
bzbud08     number(15,3),            /*自订字段-数值                          */
bzbud09     number(15,3),            /*自订字段-数值                          */
bzbud10     number(10),              /*自订字段-整数                          */
bzbud11     number(10),              /*自订字段-整数                          */
bzbud12     number(10),              /*自订字段-整数                          */
bzbud13     date,                    /*自订字段-日期                          */
bzbud14     date,                    /*自订字段-日期                          */
bzbud15     date                     /*自订字段-日期                          */
);

alter table bzb_file add  constraint bzb_pk primary key  (bzb01,bzb02) enable validate;
grant select on bzb_file to tiptopgp;
grant update on bzb_file to tiptopgp;
grant delete on bzb_file to tiptopgp;
grant insert on bzb_file to tiptopgp;
grant index on bzb_file to public;
grant select on bzb_file to ods;
