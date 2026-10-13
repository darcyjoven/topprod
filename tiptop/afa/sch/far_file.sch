/*
================================================================================
檔案代號:far_file
檔案名稱:固定资产资本化单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table far_file
(
far01       varchar2(20) NOT NULL,   /*单号                                   */
far02       number(5) NOT NULL,      /*项次                                   */
far03       varchar2(10),            /*财产编号                               */
far031      varchar2(4),             /*附号                                   */
far04       date,                    /*入帐日期                               */
far05       varchar2(10),            /*保管部门                               */
far06       varchar2(10),            /*放置位置                               */
far07       varchar2(24),            /*资产科目编号                           */
far08       varchar2(24),            /*累计折旧科目编号                       */
far09       varchar2(1),             /*分摊方式                               */
far10       varchar2(10),            /*分摊部门                               */
far11       varchar2(24),            /*折旧费用科目编号                       */
far12       varchar2(10),            /*正式财产编号                           */
far121      varchar2(4),             /*正式附号                               */
far13       varchar2(10),            /*原因码                                 */
far27       varchar2(6),             /*折旧年月                               */
far071      varchar2(24),            /*资产科目二编号                         */
far081      varchar2(24),            /*累计折旧科目编号二                     */
far111      varchar2(24),            /*折旧费用科目二编号                     */
farud01     varchar2(255),           /*自订字段-Textedit                      */
farud02     varchar2(40),            /*自订字段-文字                          */
farud03     varchar2(40),            /*自订字段-文字                          */
farud04     varchar2(40),            /*自订字段-文字                          */
farud05     varchar2(40),            /*自订字段-文字                          */
farud06     varchar2(40),            /*自订字段-文字                          */
farud07     number(15,3),            /*自订字段-数值                          */
farud08     number(15,3),            /*自订字段-数值                          */
farud09     number(15,3),            /*自订字段-数值                          */
farud10     number(10),              /*自订字段-整数                          */
farud11     number(10),              /*自订字段-整数                          */
farud12     number(10),              /*自订字段-整数                          */
farud13     date,                    /*自订字段-日期                          */
farud14     date,                    /*自订字段-日期                          */
farud15     date,                    /*自订字段-日期                          */
farlegal    varchar2(10) NOT NULL,   /*所属法人                               */
far042      date,                    /*入账日期(财签二)                       */
far092      varchar2(1) DEFAULT ' ' NOT NULL, /*分摊方式(财签二)*/
far102      varchar2(10),            /*分摊部门(财签二)                       */
far272      varchar2(6)              /*折旧年月(财签二)                       */
);

create unique index far_02 on far_file (far01,far03,far031);
alter table far_file add  constraint far_pk primary key  (far01,far02) enable validate;
grant select on far_file to tiptopgp;
grant update on far_file to tiptopgp;
grant delete on far_file to tiptopgp;
grant insert on far_file to tiptopgp;
grant index on far_file to public;
grant select on far_file to ods;
