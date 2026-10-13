/*
================================================================================
檔案代號:rmo_file
檔案名稱:客退问题审核单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmo_file
(
rmo01       varchar2(20) NOT NULL,   /*客退问题审核单号                       */
                                     /*客退問題確認單號                       */
rmo02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmo03       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rmo04       number(5),               /*序号资料-项次                          */
                                     /*序號資料-項次(rmc02)(ret#)             */
rmo05       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
rmo06       varchar2(120),           /*品名                                   */
rmo07       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmo08       number(15,3),            /*提出数量                               */
                                     /*提出數量                               */
rmoud01     varchar2(255),           /*自订字段-Textedit                      */
rmoud02     varchar2(40),            /*自订字段-文字                          */
rmoud03     varchar2(40),            /*自订字段-文字                          */
rmoud04     varchar2(40),            /*自订字段-文字                          */
rmoud05     varchar2(40),            /*自订字段-文字                          */
rmoud06     varchar2(40),            /*自订字段-文字                          */
rmoud07     number(15,3),            /*自订字段-数值                          */
rmoud08     number(15,3),            /*自订字段-数值                          */
rmoud09     number(15,3),            /*自订字段-数值                          */
rmoud10     number(10),              /*自订字段-整数                          */
rmoud11     number(10),              /*自订字段-整数                          */
rmoud12     number(10),              /*自订字段-整数                          */
rmoud13     date,                    /*自订字段-日期                          */
rmoud14     date,                    /*自订字段-日期                          */
rmoud15     date,                    /*自订字段-日期                          */
rmoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmolegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmo_file add  constraint rmo_pk primary key  (rmo01,rmo02) enable validate;
grant select on rmo_file to tiptopgp;
grant update on rmo_file to tiptopgp;
grant delete on rmo_file to tiptopgp;
grant insert on rmo_file to tiptopgp;
grant index on rmo_file to public;
grant select on rmo_file to ods;
