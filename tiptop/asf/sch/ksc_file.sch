/*
================================================================================
檔案代號:ksc_file
檔案名稱:拆件式工单完工入库单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ksc_file
(
ksc00       varchar2(1),             /*类型                                   */
                                     /*Type 0.Process Transfer  1.Store-in  2.Store-In/Return*/
ksc01       varchar2(20) NOT NULL,   /*入库单号                               */
                                     /*入庫單號                               */
ksc02       date,                    /*入库日期                               */
                                     /*入庫日期                               */
ksc03       varchar2(20),            /*NO USE                                 */
                                     /*FQC 單號                               */
ksc04       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
ksc05       varchar2(10),            /*理由                                   */
ksc06       varchar2(10),            /*项目编号                               */
                                     /*專案編號                               */
ksc07       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
ksc08       varchar2(20),            /*PBI No.                                */
                                     /*PBI#                                   */
ksc09       varchar2(20),            /*耗材单号                               */
                                     /*耗材單號                               */
ksc10       varchar2(1),             /*No Use                                 */
ksc11       varchar2(1),             /*No Use                                 */
ksc12       varchar2(1),             /*No Use                                 */
ksc13       varchar2(1),             /*No Use                                 */
kscpost     varchar2(1),             /*过帐否                                 */
                                     /*過帳否 (Y/N/X)                         */
kscuser     varchar2(10),            /*资料所有者                             */
kscgrup     varchar2(10),            /*资料所有部门                           */
kscmodu     varchar2(10),            /*资料更改者                             */
kscdate     date,                    /*最近更改日                             */
kscconf     varchar2(1),             /*确认码                                 */
kscud01     varchar2(255),           /*自订字段-Textedit                      */
kscud02     varchar2(40),            /*自订字段-文字                          */
kscud03     varchar2(40),            /*自订字段-文字                          */
kscud04     varchar2(40),            /*自订字段-文字                          */
kscud05     varchar2(40),            /*自订字段-文字                          */
kscud06     varchar2(40),            /*自订字段-文字                          */
kscud07     number(15,3),            /*自订字段-数值                          */
kscud08     number(15,3),            /*自订字段-数值                          */
kscud09     number(15,3),            /*自订字段-数值                          */
kscud10     number(10),              /*自订字段-整数                          */
kscud11     number(10),              /*自订字段-整数                          */
kscud12     number(10),              /*自订字段-整数                          */
kscud13     date,                    /*自订字段-日期                          */
kscud14     date,                    /*自订字段-日期                          */
kscud15     date,                    /*自订字段-日期                          */
ksc14       date,                    /*录入日期                               */
kscplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ksclegal    varchar2(10) NOT NULL,   /*所属法人                               */
kscoriu     varchar2(10),            /*资料建立者                             */
kscorig     varchar2(10)             /*资料建立部门                           */
);

alter table ksc_file add  constraint ksc_pk primary key  (ksc01) enable validate;
grant select on ksc_file to tiptopgp;
grant update on ksc_file to tiptopgp;
grant delete on ksc_file to tiptopgp;
grant insert on ksc_file to tiptopgp;
grant index on ksc_file to public;
grant select on ksc_file to ods;
