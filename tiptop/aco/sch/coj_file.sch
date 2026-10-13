/*
================================================================================
檔案代號:coj_file
檔案名稱:进口材料加签异动单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coj_file
(
coj01       varchar2(20) NOT NULL,   /*申请编号                               */
coj02       number(5) NOT NULL,      /*序号                                   */
coj03       varchar2(40),            /*商品编号                               */
coj04       varchar2(10),            /*海关编号                               */
coj05       number(15,3),            /*加签数量                               */
coj06       varchar2(4),             /*单位                                   */
coj07       number(20,6),            /*单价                                   */
coj08       number(20,6),            /*金额                                   */
coj09       varchar2(1),             /*No Use                                 */
coj10       varchar2(1),             /*No Use                                 */
coj11       varchar2(1),             /*No Use                                 */
coj12       varchar2(1),             /*No Use                                 */
cojud01     varchar2(255),           /*自订字段-Textedit                      */
cojud02     varchar2(40),            /*自订字段-文字                          */
cojud03     varchar2(40),            /*自订字段-文字                          */
cojud04     varchar2(40),            /*自订字段-文字                          */
cojud05     varchar2(40),            /*自订字段-文字                          */
cojud06     varchar2(40),            /*自订字段-文字                          */
cojud07     number(15,3),            /*自订字段-数值                          */
cojud08     number(15,3),            /*自订字段-数值                          */
cojud09     number(15,3),            /*自订字段-数值                          */
cojud10     number(10),              /*自订字段-整数                          */
cojud11     number(10),              /*自订字段-整数                          */
cojud12     number(10),              /*自订字段-整数                          */
cojud13     date,                    /*自订字段-日期                          */
cojud14     date,                    /*自订字段-日期                          */
cojud15     date,                    /*自订字段-日期                          */
cojplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cojlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table coj_file add  constraint coj_pk primary key  (coj01,coj02) enable validate;
grant select on coj_file to tiptopgp;
grant update on coj_file to tiptopgp;
grant delete on coj_file to tiptopgp;
grant insert on coj_file to tiptopgp;
grant index on coj_file to public;
grant select on coj_file to ods;
