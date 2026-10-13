/*
================================================================================
檔案代號:ecu_file
檔案名稱:工艺资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ecu_file
(
ecu01       varchar2(40) NOT NULL,   /*料件编号                               */
ecu02       varchar2(10) NOT NULL,   /*工艺编号                               */
ecu03       varchar2(255),           /*备注                                   */
ecu04       number(5),               /*起始工艺序号                           */
ecu05       number(5),               /*截止工艺序号                           */
ecu06       varchar2(1),             /*No Use                                 */
ecu07       varchar2(1),             /*No Use                                 */
ecu08       varchar2(1),             /*No Use                                 */
ecu09       varchar2(1),             /*No Use                                 */
ecuacti     varchar2(1),             /*资料有效码                             */
ecuuser     varchar2(10),            /*资料所有者                             */
ecugrup     varchar2(10),            /*资料所有群                             */
ecumodu     varchar2(10),            /*资料更改者                             */
ecudate     date,                    /*最近更改日                             */
ecu10       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
ecu11       number(5),               /*变更序号                               */
ecuud01     varchar2(255),           /*自订字段-Textedit                      */
ecuud02     varchar2(40),            /*自订字段-文字                          */
ecuud03     varchar2(40),            /*自订字段-文字                          */
ecuud04     varchar2(40),            /*自订字段-文字                          */
ecuud05     varchar2(40),            /*自订字段-文字                          */
ecuud06     varchar2(40),            /*自订字段-文字                          */
ecuud07     number(15,3),            /*自订字段-数值                          */
ecuud08     number(15,3),            /*自订字段-数值                          */
ecuud09     number(15,3),            /*自订字段-数值                          */
ecuud10     number(10),              /*自订字段-整数                          */
ecuud11     number(10),              /*自订字段-整数                          */
ecuud12     number(10),              /*自订字段-整数                          */
ecuud13     date,                    /*自订字段-日期                          */
ecuud14     date,                    /*自订字段-日期                          */
ecuud15     date,                    /*自订字段-日期                          */
ecuoriu     varchar2(10),            /*资料建立者                             */
ecuorig     varchar2(10),            /*资料建立部门                           */
ecu012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
ecu014      varchar2(80),            /*工艺段说明                             */
ecu015      varchar2(10),            /*下工艺段号                             */
ecuud16     varchar2(1000),
ecuud17     varchar2(1000)
);

alter table ecu_file add  constraint ecu_pk primary key  (ecu01,ecu02,ecu012) enable validate;
grant select on ecu_file to tiptopgp;
grant update on ecu_file to tiptopgp;
grant delete on ecu_file to tiptopgp;
grant insert on ecu_file to tiptopgp;
grant index on ecu_file to public;
grant select on ecu_file to ods;
