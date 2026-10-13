/*
================================================================================
檔案代號:coh_file
檔案名稱:出口加签异动单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coh_file
(
coh01       varchar2(20) NOT NULL,   /*申请编号                               */
coh02       number(5) NOT NULL,      /*序号                                   */
coh03       varchar2(40),            /*商品编号                               */
coh04       varchar2(10),            /*海关编号                               */
coh041      varchar2(20),            /*BOM版本编号                            */
coh05       number(15,3),            /*加签数量                               */
coh06       varchar2(4),             /*单位                                   */
coh07       number(20,6),            /*单价                                   */
coh08       number(20,6),            /*金额                                   */
coh09       varchar2(1),             /*No Use                                 */
coh10       varchar2(1),             /*No Use                                 */
coh11       varchar2(1),             /*No Use                                 */
coh12       varchar2(1),             /*No Use                                 */
cohud01     varchar2(255),           /*自订字段-Textedit                      */
cohud02     varchar2(40),            /*自订字段-文字                          */
cohud03     varchar2(40),            /*自订字段-文字                          */
cohud04     varchar2(40),            /*自订字段-文字                          */
cohud05     varchar2(40),            /*自订字段-文字                          */
cohud06     varchar2(40),            /*自订字段-文字                          */
cohud07     number(15,3),            /*自订字段-数值                          */
cohud08     number(15,3),            /*自订字段-数值                          */
cohud09     number(15,3),            /*自订字段-数值                          */
cohud10     number(10),              /*自订字段-整数                          */
cohud11     number(10),              /*自订字段-整数                          */
cohud12     number(10),              /*自订字段-整数                          */
cohud13     date,                    /*自订字段-日期                          */
cohud14     date,                    /*自订字段-日期                          */
cohud15     date,                    /*自订字段-日期                          */
cohplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cohlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table coh_file add  constraint coh_pk primary key  (coh01,coh02) enable validate;
grant select on coh_file to tiptopgp;
grant update on coh_file to tiptopgp;
grant delete on coh_file to tiptopgp;
grant insert on coh_file to tiptopgp;
grant index on coh_file to public;
grant select on coh_file to ods;
