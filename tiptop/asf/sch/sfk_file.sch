/*
================================================================================
檔案代號:sfk_file
檔案名稱:报废单头档(工单)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfk_file
(
sfk01       varchar2(20) NOT NULL,   /*报废单号(SCR)                          */
                                     /*報廢單號(SCR)                          */
sfk02       date,                    /*报废日期                               */
                                     /*報廢日期                               */
sfk03       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
sfkpost     varchar2(1),             /*过帐否                                 */
                                     /*過帳否(Y/N/X)                          */
sfkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
sfkgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
sfkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
sfkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
sfkconf     varchar2(1),             /*确认码                                 */
sfkud01     varchar2(255),           /*自订字段-Textedit                      */
sfkud02     varchar2(40),            /*自订字段-文字                          */
sfkud03     varchar2(40),            /*自订字段-文字                          */
sfkud04     varchar2(40),            /*自订字段-文字                          */
sfkud05     varchar2(40),            /*自订字段-文字                          */
sfkud06     varchar2(40),            /*自订字段-文字                          */
sfkud07     number(15,3),            /*自订字段-数值                          */
sfkud08     number(15,3),            /*自订字段-数值                          */
sfkud09     number(15,3),            /*自订字段-数值                          */
sfkud10     number(10),              /*自订字段-整数                          */
sfkud11     number(10),              /*自订字段-整数                          */
sfkud12     number(10),              /*自订字段-整数                          */
sfkud13     date,                    /*自订字段-日期                          */
sfkud14     date,                    /*自订字段-日期                          */
sfkud15     date,                    /*自订字段-日期                          */
sfkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfklegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfkoriu     varchar2(10),            /*资料建立者                             */
sfkorig     varchar2(10)             /*资料建立部门                           */
);

alter table sfk_file add  constraint sfk_pk primary key  (sfk01) enable validate;
grant select on sfk_file to tiptopgp;
grant update on sfk_file to tiptopgp;
grant delete on sfk_file to tiptopgp;
grant insert on sfk_file to tiptopgp;
grant index on sfk_file to public;
grant select on sfk_file to ods;
