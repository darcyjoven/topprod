/*
================================================================================
檔案代號:cnm_file
檔案名稱:转厂申请单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnm_file
(
cnm01       varchar2(20) NOT NULL,   /*申请编号                               */
cnm02       date,                    /*单据日期                               */
cnm03       varchar2(20),            /*申请表编号                             */
cnm04       varchar2(1),             /*转厂类型                               */
                                     /*轉廠類型      No:BUG-490398            */
                                     /*1:轉入料件   2:轉出成品                */
cnm05       varchar2(20),            /*购销手册编号                           */
                                     /*購銷手冊編號     No:BUG-490398         */
cnm06       varchar2(4),             /*币种                                   */
cnm07       varchar2(20),            /*转出方编号                             */
cnm071      varchar2(20),            /*手册编号                               */
cnm072      date,                    /*手册有效日期                           */
cnm08       varchar2(20),            /*转入方编号                             */
cnm081      varchar2(20),            /*手册编号                               */
cnm082      date,                    /*手册有效日期                           */
cnm09       varchar2(10),            /*海关编号                               */
cnm10       varchar2(1),             /*No Use                                 */
cnm11       varchar2(1),             /*No Use                                 */
cnmconf     varchar2(1),             /*确认码                                 */
cnmacti     varchar2(1),             /*资料有效码                             */
cnmuser     varchar2(10),            /*资料所有者                             */
cnmgrup     varchar2(10),            /*资料所有部门                           */
cnmmodu     varchar2(10),            /*资料更改者                             */
cnmdate     date,                    /*最近更改日                             */
cnmud01     varchar2(255),           /*自订字段-Textedit                      */
cnmud02     varchar2(40),            /*自订字段-文字                          */
cnmud03     varchar2(40),            /*自订字段-文字                          */
cnmud04     varchar2(40),            /*自订字段-文字                          */
cnmud05     varchar2(40),            /*自订字段-文字                          */
cnmud06     varchar2(40),            /*自订字段-文字                          */
cnmud07     number(15,3),            /*自订字段-数值                          */
cnmud08     number(15,3),            /*自订字段-数值                          */
cnmud09     number(15,3),            /*自订字段-数值                          */
cnmud10     number(10),              /*自订字段-整数                          */
cnmud11     number(10),              /*自订字段-整数                          */
cnmud12     number(10),              /*自订字段-整数                          */
cnmud13     date,                    /*自订字段-日期                          */
cnmud14     date,                    /*自订字段-日期                          */
cnmud15     date,                    /*自订字段-日期                          */
cnmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cnmorig     varchar2(10),            /*资料建立部门                           */
cnmoriu     varchar2(10)             /*资料建立者                             */
);

alter table cnm_file add  constraint cnm_pk primary key  (cnm01) enable validate;
grant select on cnm_file to tiptopgp;
grant update on cnm_file to tiptopgp;
grant delete on cnm_file to tiptopgp;
grant insert on cnm_file to tiptopgp;
grant index on cnm_file to public;
grant select on cnm_file to ods;
