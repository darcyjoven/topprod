/*
================================================================================
檔案代號:bgh_file
檔案名稱:预算BOM单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table bgh_file
(
bgh01       varchar2(10) NOT NULL,   /*版本                                   */
bgh02       varchar2(40) NOT NULL,   /*主件料号                               */
bgh03       number(5) NOT NULL,      /*项次                                   */
bgh04       varchar2(40),            /*元件料号                               */
bgh05       varchar2(1),             /*No Use                                 */
bgh06       number(16,8),            /*组成用量                               */
                                     /*組成用量(QPA)                          */
bgh07       number(16,8),            /*底数                                   */
bgh08       number(9,4),             /*损耗率                                 */
bgh09       varchar2(1),             /*No Use                                 */
bgh10       varchar2(1),             /*No Use                                 */
bgh11       varchar2(4),             /*发料单位                               */
                                     /*發料單位   No.8563 031030              */
bgh11_fac   number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率 No.8563 031030 */
bghud01     varchar2(255),           /*自订字段-Textedit                      */
bghud02     varchar2(40),            /*自订字段-文字                          */
bghud03     varchar2(40),            /*自订字段-文字                          */
bghud04     varchar2(40),            /*自订字段-文字                          */
bghud05     varchar2(40),            /*自订字段-文字                          */
bghud06     varchar2(40),            /*自订字段-文字                          */
bghud07     number(15,3),            /*自订字段-数值                          */
bghud08     number(15,3),            /*自订字段-数值                          */
bghud09     number(15,3),            /*自订字段-数值                          */
bghud10     number(10),              /*自订字段-整数                          */
bghud11     number(10),              /*自订字段-整数                          */
bghud12     number(10),              /*自订字段-整数                          */
bghud13     date,                    /*自订字段-日期                          */
bghud14     date,                    /*自订字段-日期                          */
bghud15     date                     /*自订字段-日期                          */
);

alter table bgh_file add  constraint bgh_pk primary key  (bgh01,bgh02,bgh03) enable validate;
grant select on bgh_file to tiptopgp;
grant update on bgh_file to tiptopgp;
grant delete on bgh_file to tiptopgp;
grant insert on bgh_file to tiptopgp;
grant index on bgh_file to public;
grant select on bgh_file to ods;
