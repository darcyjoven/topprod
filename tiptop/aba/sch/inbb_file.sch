/*
================================================================================
檔案代號:inbb_file
檔案名稱:条码杂收发单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table inbb_file
(
inbb01      varchar2(20) DEFAULT ' ' NOT NULL, /*异动单号*/
inbb02      number(5) DEFAULT '0' NOT NULL, /*项次*/
inbb03      varchar2(10),            /*Nouse                                  */
inbb04      varchar2(80),            /*条码编号                               */
inbb05      varchar2(40),            /*料号                                   */
inbb06      varchar2(10),            /*仓库                                   */
inbb07      varchar2(10),            /*库位                                   */
inbb08      varchar2(24),            /*批号                                   */
inbb09      number(15,3) DEFAULT '0' NOT NULL, /*异动数量*/
inbb10      varchar2(255),           /*备注                                   */
inbblegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
inbbplant   varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
inbbud01    varchar2(255),           /*自订字段-Textedit                      */
inbbud02    varchar2(40),            /*自订字段-文字                          */
inbbud03    varchar2(40),            /*自订字段-文字                          */
inbbud04    varchar2(40),            /*自订字段-文字                          */
inbbud05    varchar2(40),            /*自订字段-文字                          */
inbbud06    varchar2(40),            /*自订字段-文字                          */
inbbud07    number(15,3),            /*自订字段-数值                          */
inbbud08    number(15,3),            /*自订字段-数值                          */
inbbud09    number(15,3),            /*自订字段-数值                          */
inbbud10    number(10),              /*自订字段-整数                          */
inbbud11    number(10),              /*自订字段-整数                          */
inbbud12    number(10),              /*自订字段-整数                          */
inbbud13    date,                    /*自订字段-日期                          */
inbbud14    date,
inbbud15    date                     /*自订字段-日期                          */
);

alter table inbb_file add  constraint inbb_pk primary key  (inbb01,inbb02) enable validate;
grant select on inbb_file to tiptopgp;
grant update on inbb_file to tiptopgp;
grant delete on inbb_file to tiptopgp;
grant insert on inbb_file to tiptopgp;
grant index on inbb_file to public;
grant select on inbb_file to ods;
