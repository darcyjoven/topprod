/*
================================================================================
檔案代號:fat_file
檔案名稱:固定资产资产转移单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fat_file
(
fat01       varchar2(20) NOT NULL,   /*单号                                   */
fat02       number(5) NOT NULL,      /*项次                                   */
fat03       varchar2(10),            /*财产编号                               */
fat031      varchar2(4),             /*附号                                   */
fat04       varchar2(10),            /*保管人                                 */
fat05       varchar2(10),            /*保管部门                               */
fat06       varchar2(10),            /*放置地点                               */
fat07       varchar2(24),            /*资产科目编号                           */
fat08       varchar2(24),            /*累计折旧科目编号                       */
fat09       varchar2(1),             /*分摊方式                               */
fat10       varchar2(10),            /*分摊部门                               */
fat11       varchar2(24),            /*折旧费用科目编号                       */
fat12       varchar2(10),            /*NO USE 原因码                          */
fat071      varchar2(24),            /*资产科目二编号                         */
fat081      varchar2(24),            /*累计折旧科目二编号                     */
fat111      varchar2(24),            /*折旧费用科目二编号                     */
fatud01     varchar2(255),           /*自订字段-Textedit                      */
fatud02     varchar2(40),            /*自订字段-文字                          */
fatud03     varchar2(40),            /*自订字段-文字                          */
fatud04     varchar2(40),            /*自订字段-文字                          */
fatud05     varchar2(40),            /*自订字段-文字                          */
fatud06     varchar2(40),            /*自订字段-文字                          */
fatud07     number(15,3),            /*自订字段-数值                          */
fatud08     number(15,3),            /*自订字段-数值                          */
fatud09     number(15,3),            /*自订字段-数值                          */
fatud10     number(10),              /*自订字段-整数                          */
fatud11     number(10),              /*自订字段-整数                          */
fatud12     number(10),              /*自订字段-整数                          */
fatud13     date,                    /*自订字段-日期                          */
fatud14     date,                    /*自订字段-日期                          */
fatud15     date,                    /*自订字段-日期                          */
fatlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fat092      varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式(财签二)*/
fat102      varchar2(10)             /*分摊部门(财签二)                       */
);

create unique index fat_02 on fat_file (fat01,fat03,fat031);
alter table fat_file add  constraint fat_pk primary key  (fat01,fat02) enable validate;
grant select on fat_file to tiptopgp;
grant update on fat_file to tiptopgp;
grant delete on fat_file to tiptopgp;
grant insert on fat_file to tiptopgp;
grant index on fat_file to public;
grant select on fat_file to ods;
