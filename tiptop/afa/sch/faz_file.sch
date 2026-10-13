/*
================================================================================
檔案代號:faz_file
檔案名稱:固定资产改良单据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table faz_file
(
faz01       varchar2(20) NOT NULL,   /*改良单号                               */
faz02       number(5) NOT NULL,      /*项次                                   */
faz03       varchar2(10),            /*财产编号                               */
faz031      varchar2(4),             /*附号                                   */
faz04       number(20,6),            /*未折减余额                             */
faz05       number(5),               /*未用年限                               */
faz06       number(20,6),            /*预估残值                               */
faz07       number(15,2),            /*No Use                                 */
faz08       number(20,6),            /*改良成本                               */
faz09       number(5),               /*异动后未用年限                         */
faz10       number(20,6),            /*异动后预估残值                         */
faz11       number(15,2),            /*No Use                                 */
faz12       varchar2(10),            /*原因                                   */
faz13       number(20,6),            /*税签未折减余额                         */
faz14       number(5),               /*税签未用年限                           */
faz15       number(20,6),            /*税签预估残值                           */
faz16       number(15,2),            /*No Use                                 */
faz17       number(20,6),            /*税签改良成本                           */
faz18       number(5),               /*税签异动后未用年限                     */
faz19       number(20,6),            /*税签异动后预估残值                     */
faz20       number(15,2),            /*No Use                                 */
fazud01     varchar2(255),           /*自订字段-Textedit                      */
fazud02     varchar2(40),            /*自订字段-文字                          */
fazud03     varchar2(40),            /*自订字段-文字                          */
fazud04     varchar2(40),            /*自订字段-文字                          */
fazud05     varchar2(40),            /*自订字段-文字                          */
fazud06     varchar2(40),            /*自订字段-文字                          */
fazud07     number(15,3),            /*自订字段-数值                          */
fazud08     number(15,3),            /*自订字段-数值                          */
fazud09     number(15,3),            /*自订字段-数值                          */
fazud10     number(10),              /*自订字段-整数                          */
fazud11     number(10),              /*自订字段-整数                          */
fazud12     number(10),              /*自订字段-整数                          */
fazud13     date,                    /*自订字段-日期                          */
fazud14     date,                    /*自订字段-日期                          */
fazud15     date,                    /*自订字段-日期                          */
fazlegal    varchar2(10) NOT NULL,   /*所属法人                               */
faz042      number(20,6) DEFAULT '0' NOT NULL, /*未折减余额(财签二)*/
faz052      number(5),               /*未用年限(财签二)                       */
faz062      number(20,6) DEFAULT '0' NOT NULL, /*预估残值(财签二)*/
faz082      number(20,6) DEFAULT '0' NOT NULL, /*改良成本(财签二)*/
faz092      number(5),               /*异动后未用年限(财签二)                 */
faz102      number(20,6) DEFAULT '0' NOT NULL /*异动后预估残值(财签二)*/
);

create unique index faz_02 on faz_file (faz01,faz03,faz031);
alter table faz_file add  constraint faz_pk primary key  (faz01,faz02) enable validate;
grant select on faz_file to tiptopgp;
grant update on faz_file to tiptopgp;
grant delete on faz_file to tiptopgp;
grant insert on faz_file to tiptopgp;
grant index on faz_file to public;
grant select on faz_file to ods;
