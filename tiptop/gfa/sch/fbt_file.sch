/*
================================================================================
檔案代號:fbt_file
檔案名稱:资产减值准备单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbt_file
(
fbt01       varchar2(20) NOT NULL,   /*减值单号                               */
fbt02       number(5) NOT NULL,      /*项次                                   */
fbt03       varchar2(10),            /*财产编号                               */
fbt031      varchar2(4),             /*附号                                   */
fbt04       number(20,6),            /*未折减余额                             */
fbt05       number(20,6),            /*已计提减值准备金额                     */
fbt06       varchar2(1),             /*异动类型                               */
                                     /*1. 調增  2.調減                        */
fbt07       number(20,6),            /*减值准备金额                           */
fbt08       varchar2(10),            /*原因码                                 */
fbt09       varchar2(255),           /*备注                                   */
fbt10       number(5),               /*No Use                                 */
fbt11       number(20,6),            /*(税签) 未折减余额                      */
fbt12       number(20,6),            /*(税签) 已计提减值准备金额              */
fbt13       varchar2(1),             /*(税签) 异动类型                        */
                                     /*1.調增  2.調減                         */
fbt14       number(20,6),            /*(税签) 减值准备金额                    */
fbtud01     varchar2(255),           /*自订字段-Textedit                      */
fbtud02     varchar2(40),            /*自订字段-文字                          */
fbtud03     varchar2(40),            /*自订字段-文字                          */
fbtud04     varchar2(40),            /*自订字段-文字                          */
fbtud05     varchar2(40),            /*自订字段-文字                          */
fbtud06     varchar2(40),            /*自订字段-文字                          */
fbtud07     number(15,3),            /*自订字段-数值                          */
fbtud08     number(15,3),            /*自订字段-数值                          */
fbtud09     number(15,3),            /*自订字段-数值                          */
fbtud10     number(10),              /*自订字段-整数                          */
fbtud11     number(10),              /*自订字段-整数                          */
fbtud12     number(10),              /*自订字段-整数                          */
fbtud13     date,                    /*自订字段-日期                          */
fbtud14     date,                    /*自订字段-日期                          */
fbtud15     date,                    /*自订字段-日期                          */
fbtlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbt042      number(20,6) DEFAULT '0' NOT NULL, /*未折减余额(财签二)*/
fbt052      number(20,6) DEFAULT '0' NOT NULL, /*已计提减值准备金额(财签二)*/
fbt062      varchar2(1) DEFAULT ' ' NOT NULL, /*异动类型(财签二)*/
fbt072      number(20,6) DEFAULT '0' NOT NULL /*减值准备金额(财签二)*/
);

create unique index fbt_02 on fbt_file (fbt01,fbt03,fbt031);
alter table fbt_file add  constraint fbt_pk primary key  (fbt01,fbt02) enable validate;
grant select on fbt_file to tiptopgp;
grant update on fbt_file to tiptopgp;
grant delete on fbt_file to tiptopgp;
grant insert on fbt_file to tiptopgp;
grant index on fbt_file to public;
grant select on fbt_file to ods;
