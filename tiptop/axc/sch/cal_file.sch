/*
================================================================================
檔案代號:cal_file
檔案名稱:每日投入工时单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cal_file
(
cal01       date NOT NULL,           /*日期                                   */
cal02       varchar2(10) NOT NULL,   /*成本中心                               */
cal03       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
cal04       varchar2(1),             /*No Use                                 */
cal05       number(15,3) NOT NULL,   /*工时合计                               */
                                     /*工時合計                               */
calfirm     varchar2(1),             /*确认码                                 */
calinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
calacti     varchar2(1),             /*资料有效码                             */
caluser     varchar2(10),            /*资料所有者                             */
calgrup     varchar2(10),            /*资料所有群                             */
calmodu     varchar2(10),            /*资料更改者                             */
caldate     date,                    /*最近更改日                             */
calud01     varchar2(255),           /*自订字段-Textedit                      */
calud02     varchar2(40),            /*自订字段-文字                          */
calud03     varchar2(40),            /*自订字段-文字                          */
calud04     varchar2(40),            /*自订字段-文字                          */
calud05     varchar2(40),            /*自订字段-文字                          */
calud06     varchar2(40),            /*自订字段-文字                          */
calud07     number(15,3),            /*自订字段-数值                          */
calud08     number(15,3),            /*自订字段-数值                          */
calud09     number(15,3),            /*自订字段-数值                          */
calud10     number(10),              /*自订字段-整数                          */
calud11     number(10),              /*自订字段-整数                          */
calud12     number(10),              /*自订字段-整数                          */
calud13     date,                    /*自订字段-日期                          */
calud14     date,                    /*自订字段-日期                          */
calud15     date,                    /*自订字段-日期                          */
callegal    varchar2(10) NOT NULL,   /*所属法人                               */
caloriu     varchar2(10),            /*资料建立者                             */
calorig     varchar2(10)             /*资料建立部门                           */
);

alter table cal_file add  constraint cal_pk primary key  (cal01,cal02) enable validate;
grant select on cal_file to tiptopgp;
grant update on cal_file to tiptopgp;
grant delete on cal_file to tiptopgp;
grant insert on cal_file to tiptopgp;
grant index on cal_file to public;
grant select on cal_file to ods;
