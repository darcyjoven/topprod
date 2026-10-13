/*
================================================================================
檔案代號:tqt_file
檔案名稱:合同适用系列档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tqt_file
(
tqt01       varchar2(20) NOT NULL,   /*合约单号                               */
tqt02       varchar2(10) NOT NULL,   /*系列编号                               */
tqtud01     varchar2(255),           /*自订字段-Textedit                      */
tqtud02     varchar2(40),            /*自订字段-文字                          */
tqtud03     varchar2(40),            /*自订字段-文字                          */
tqtud04     varchar2(40),            /*自订字段-文字                          */
tqtud05     varchar2(40),            /*自订字段-文字                          */
tqtud06     varchar2(40),            /*自订字段-文字                          */
tqtud07     number(15,3),            /*自订字段-数值                          */
tqtud08     number(15,3),            /*自订字段-数值                          */
tqtud09     number(15,3),            /*自订字段-数值                          */
tqtud10     number(10),              /*自订字段-整数                          */
tqtud11     number(10),              /*自订字段-整数                          */
tqtud12     number(10),              /*自订字段-整数                          */
tqtud13     date,                    /*自订字段-日期                          */
tqtud14     date,                    /*自订字段-日期                          */
tqtud15     date,                    /*自订字段-日期                          */
tqtplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tqtlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table tqt_file add  constraint tqt_pk primary key  (tqt01,tqt02) enable validate;
grant select on tqt_file to tiptopgp;
grant update on tqt_file to tiptopgp;
grant delete on tqt_file to tiptopgp;
grant insert on tqt_file to tiptopgp;
grant index on tqt_file to public;
grant select on tqt_file to ods;
