/*
================================================================================
檔案代號:mmm_file
檔案名稱:零件加工额外领料单头底稿档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmm_file
(
mmm01       varchar2(20) NOT NULL,   /*需求单号                               */
                                     /*需求單號 mmb01                         */
mmm02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次     mmb02                         */
mmm03       varchar2(10),            /*领料部门                               */
                                     /*領料部門                               */
mmm04       date,                    /*日期                                   */
mmm05       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
mmm06       varchar2(1),             /*资料转出否                             */
                                     /*資料轉出否(Y/N)                        */
mmm07       varchar2(10),            /*加工码                                 */
                                     /*加工碼                                 */
mmm08       number(5),               /*工时                                   */
                                     /*工時(分)                               */
mmmacti     varchar2(1),             /*资料有效码                             */
mmmuser     varchar2(10),            /*资料所有者                             */
mmmgrup     varchar2(10),            /*资料所有群                             */
mmmmodu     varchar2(10),            /*资料更改者                             */
mmmdate     date,                    /*最近更改日                             */
mmmud01     varchar2(255),           /*自订字段-Textedit                      */
mmmud02     varchar2(40),            /*自订字段-文字                          */
mmmud03     varchar2(40),            /*自订字段-文字                          */
mmmud04     varchar2(40),            /*自订字段-文字                          */
mmmud05     varchar2(40),            /*自订字段-文字                          */
mmmud06     varchar2(40),            /*自订字段-文字                          */
mmmud07     number(15,3),            /*自订字段-数值                          */
mmmud08     number(15,3),            /*自订字段-数值                          */
mmmud09     number(15,3),            /*自订字段-数值                          */
mmmud10     number(10),              /*自订字段-整数                          */
mmmud11     number(10),              /*自订字段-整数                          */
mmmud12     number(10),              /*自订字段-整数                          */
mmmud13     date,                    /*自订字段-日期                          */
mmmud14     date,                    /*自订字段-日期                          */
mmmud15     date,                    /*自订字段-日期                          */
mmmplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmmlegal    varchar2(10) NOT NULL,   /*所属法人                               */
mmmorig     varchar2(10),            /*资料建立部门                           */
mmmoriu     varchar2(10)             /*资料建立者                             */
);

alter table mmm_file add  constraint mmm_pk primary key  (mmm01,mmm02) enable validate;
grant select on mmm_file to tiptopgp;
grant update on mmm_file to tiptopgp;
grant delete on mmm_file to tiptopgp;
grant insert on mmm_file to tiptopgp;
grant index on mmm_file to public;
grant select on mmm_file to ods;
