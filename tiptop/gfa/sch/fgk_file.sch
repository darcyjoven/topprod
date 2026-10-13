/*
================================================================================
檔案代號:fgk_file
檔案名稱:每月工作资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fgk_file
(
fgk01       number(5) NOT NULL,      /*工作年度                               */
fgk02       number(5) NOT NULL,      /*工作期别                               */
fgk03       varchar2(10) NOT NULL,   /*财产编号                               */
fgk04       varchar2(4) NOT NULL,    /*附号                                   */
fgk05       varchar2(10) NOT NULL,   /*部门                                   */
fgk06       number(15,3),            /*本月工作量                             */
fgk07       varchar2(255),           /*备注                                   */
fgkud01     varchar2(255),           /*自订字段-Textedit                      */
fgkud02     varchar2(40),            /*自订字段-文字                          */
fgkud03     varchar2(40),            /*自订字段-文字                          */
fgkud04     varchar2(40),            /*自订字段-文字                          */
fgkud05     varchar2(40),            /*自订字段-文字                          */
fgkud06     varchar2(40),            /*自订字段-文字                          */
fgkud07     number(15,3),            /*自订字段-数值                          */
fgkud08     number(15,3),            /*自订字段-数值                          */
fgkud09     number(15,3),            /*自订字段-数值                          */
fgkud10     number(10),              /*自订字段-整数                          */
fgkud11     number(10),              /*自订字段-整数                          */
fgkud12     number(10),              /*自订字段-整数                          */
fgkud13     date,                    /*自订字段-日期                          */
fgkud14     date,                    /*自订字段-日期                          */
fgkud15     date,                    /*自订字段-日期                          */
fgklegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table fgk_file add  constraint fgk_pk primary key  (fgk01,fgk02,fgk03,fgk04,fgk05) enable validate;
grant select on fgk_file to tiptopgp;
grant update on fgk_file to tiptopgp;
grant delete on fgk_file to tiptopgp;
grant insert on fgk_file to tiptopgp;
grant index on fgk_file to public;
grant select on fgk_file to ods;
