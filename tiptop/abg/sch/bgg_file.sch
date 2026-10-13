/*
================================================================================
檔案代號:bgg_file
檔案名稱:预算BOM单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgg_file
(
bgg01       varchar2(10) NOT NULL,   /*版本                                   */
bgg02       varchar2(40) NOT NULL,   /*产品别/品号                            */
                                     /*產品別/品號                            */
bgg03       varchar2(1),             /*No Use                                 */
bgg04       varchar2(1),             /*No Use                                 */
bgg05       varchar2(1),             /*No Use                                 */
bgg06       varchar2(40),            /*参考料号                               */
                                     /*參考料號 add in 03/10/15 #8563         */
bgg07       number(15,3),            /*标准工时                               */
                                     /*標準工時 add in 03/10/15 #8563         */
bgguser     varchar2(10),            /*资料所有者                             */
bgggrup     varchar2(10),            /*资料所有群                             */
bggmodu     varchar2(10),            /*资料更改者                             */
bggdate     date,                    /*最近更改日                             */
bggacti     varchar2(1),             /*资料有效码                             */
bggud01     varchar2(255),           /*自订字段-Textedit                      */
bggud02     varchar2(40),            /*自订字段-文字                          */
bggud03     varchar2(40),            /*自订字段-文字                          */
bggud04     varchar2(40),            /*自订字段-文字                          */
bggud05     varchar2(40),            /*自订字段-文字                          */
bggud06     varchar2(40),            /*自订字段-文字                          */
bggud07     number(15,3),            /*自订字段-数值                          */
bggud08     number(15,3),            /*自订字段-数值                          */
bggud09     number(15,3),            /*自订字段-数值                          */
bggud10     number(10),              /*自订字段-整数                          */
bggud11     number(10),              /*自订字段-整数                          */
bggud12     number(10),              /*自订字段-整数                          */
bggud13     date,                    /*自订字段-日期                          */
bggud14     date,                    /*自订字段-日期                          */
bggud15     date,                    /*自订字段-日期                          */
bggoriu     varchar2(10),            /*资料建立者                             */
bggorig     varchar2(10)             /*资料建立部门                           */
);

alter table bgg_file add  constraint bgg_pk primary key  (bgg01,bgg02) enable validate;
grant select on bgg_file to tiptopgp;
grant update on bgg_file to tiptopgp;
grant delete on bgg_file to tiptopgp;
grant insert on bgg_file to tiptopgp;
grant index on bgg_file to public;
grant select on bgg_file to ods;
