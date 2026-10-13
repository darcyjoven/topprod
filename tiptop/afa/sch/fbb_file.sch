/*
================================================================================
檔案代號:fbb_file
檔案名稱:固定资产重估单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fbb_file
(
fbb01       varchar2(20) NOT NULL,   /*重估单号                               */
fbb02       number(5) NOT NULL,      /*项次                                   */
fbb03       varchar2(10),            /*财产编号                               */
fbb031      varchar2(4),             /*附号                                   */
fbb04       number(20,6),            /*未折减余额                             */
fbb05       number(5),               /*未用年限                               */
fbb06       number(20,6),            /*预估残值                               */
fbb07       number(15,2),            /*No Use                                 */
fbb08       number(20,6),            /*调整成本                               */
fbb09       number(5),               /*异动后未用年限                         */
fbb10       number(20,6),            /*异动后预估残值                         */
fbb11       number(15,2),            /*No Use                                 */
fbb12       varchar2(10),            /*原因                                   */
fbb13       number(20,6),            /*税签未折减余额                         */
fbb14       number(5),               /*税签未用年限                           */
fbb15       number(20,6),            /*税签预估残值                           */
fbb16       number(15,2),            /*No Use                                 */
fbb17       number(20,6),            /*税签调整成本                           */
fbb18       number(5),               /*税签异动后未用年限                     */
fbb19       number(20,6),            /*税签异动后预估残值                     */
fbb20       number(15,2),            /*No Use                                 */
fbbud01     varchar2(255),           /*自订字段-Textedit                      */
fbbud02     varchar2(40),            /*自订字段-文字                          */
fbbud03     varchar2(40),            /*自订字段-文字                          */
fbbud04     varchar2(40),            /*自订字段-文字                          */
fbbud05     varchar2(40),            /*自订字段-文字                          */
fbbud06     varchar2(40),            /*自订字段-文字                          */
fbbud07     number(15,3),            /*自订字段-数值                          */
fbbud08     number(15,3),            /*自订字段-数值                          */
fbbud09     number(15,3),            /*自订字段-数值                          */
fbbud10     number(10),              /*自订字段-整数                          */
fbbud11     number(10),              /*自订字段-整数                          */
fbbud12     number(10),              /*自订字段-整数                          */
fbbud13     date,                    /*自订字段-日期                          */
fbbud14     date,                    /*自订字段-日期                          */
fbbud15     date,                    /*自订字段-日期                          */
fbblegal    varchar2(10) NOT NULL,   /*所属法人                               */
fbb042      number(20,6) DEFAULT '0' NOT NULL, /*未折减余额(财签二)*/
fbb052      number(5),               /*未用年限(财签二)                       */
fbb062      number(20,6) DEFAULT '0' NOT NULL, /*预估残值(财签二)*/
fbb082      number(20,6) DEFAULT '0' NOT NULL, /*改良成本(财签二)*/
fbb092      number(5),               /*异动未用年限(财签二)                   */
fbb102      number(20,6) DEFAULT '0' NOT NULL /*异动后预估残值(财签二)*/
);

create unique index fbb_02 on fbb_file (fbb01,fbb03,fbb031);
alter table fbb_file add  constraint fbb_pk primary key  (fbb01,fbb02) enable validate;
grant select on fbb_file to tiptopgp;
grant update on fbb_file to tiptopgp;
grant delete on fbb_file to tiptopgp;
grant insert on fbb_file to tiptopgp;
grant index on fbb_file to public;
grant select on fbb_file to ods;
