/*
================================================================================
檔案代號:cos_file
檔案名稱:进口设备征免证明单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cos_file
(
cos01       varchar2(20) NOT NULL,   /*申请编号                               */
cos02       varchar2(80),            /*申请单位                               */
cos03       date,                    /*申请日期                               */
cos04       varchar2(20),            /*收货人                                 */
cos05       varchar2(40),            /*电话                                   */
cos06       date,                    /*预计进口日期                           */
cos07       date,                    /*到港日期                               */
cos08       varchar2(15),            /*免税证明编号                           */
cos09       date,                    /*有效日期                               */
cos10       varchar2(1),             /*状态                                   */
cos11       varchar2(30),            /*预报关单编号                           */
cos12       varchar2(30),            /*报关单编号                             */
cos13       varchar2(255),           /*备注                                   */
cosacti     varchar2(1),             /*资料有效码                             */
cosuser     varchar2(10),            /*资料所有者                             */
cosgrup     varchar2(10),            /*资料所有部门                           */
cosmodu     varchar2(10),            /*资料更改者                             */
cosdate     date,                    /*最近更改日                             */
cosud01     varchar2(255),           /*自订字段-Textedit                      */
cosud02     varchar2(40),            /*自订字段-文字                          */
cosud03     varchar2(40),            /*自订字段-文字                          */
cosud04     varchar2(40),            /*自订字段-文字                          */
cosud05     varchar2(40),            /*自订字段-文字                          */
cosud06     varchar2(40),            /*自订字段-文字                          */
cosud07     number(15,3),            /*自订字段-数值                          */
cosud08     number(15,3),            /*自订字段-数值                          */
cosud09     number(15,3),            /*自订字段-数值                          */
cosud10     number(10),              /*自订字段-整数                          */
cosud11     number(10),              /*自订字段-整数                          */
cosud12     number(10),              /*自订字段-整数                          */
cosud13     date,                    /*自订字段-日期                          */
cosud14     date,                    /*自订字段-日期                          */
cosud15     date,                    /*自订字段-日期                          */
cosplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coslegal    varchar2(10) NOT NULL,   /*所属法人                               */
cosorig     varchar2(10),            /*资料建立部门                           */
cosoriu     varchar2(10)             /*资料建立者                             */
);

alter table cos_file add  constraint cos_pk primary key  (cos01) enable validate;
grant select on cos_file to tiptopgp;
grant update on cos_file to tiptopgp;
grant delete on cos_file to tiptopgp;
grant insert on cos_file to tiptopgp;
grant index on cos_file to public;
grant select on cos_file to ods;
