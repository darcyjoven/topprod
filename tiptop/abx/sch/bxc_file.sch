/*
================================================================================
檔案代號:bxc_file
檔案名稱:保税委外加工进厂单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table bxc_file
(
bxc01       varchar2(20) NOT NULL,   /*进厂单号                               */
bxc02       number(5) NOT NULL,      /*项次                                   */
bxc03       varchar2(40),            /*材料品号                               */
bxc04       varchar2(10),            /*运回原料入库仓库                       */
bxc05       varchar2(10),            /*库位                                   */
bxc06       varchar2(24),            /*批号                                   */
bxc07       number(16,8),            /*单位用量                               */
bxc08       number(15,3),            /*使用原料总数                           */
bxc09       number(15,3),            /*损耗总数                               */
bxc10       number(15,3),            /*下脚料及废料运回数量                   */
bxc11       number(15,3),            /*未加工运回原料数量                     */
bxc12       varchar2(10),            /*下脚料及废料入库仓库                   */
bxc13       varchar2(10),            /*库位                                   */
bxc14       varchar2(24),            /*批号                                   */
bxc15       varchar2(255),           /*备注                                   */
bxcud01     varchar2(255),           /*自订字段-Textedit                      */
bxcud02     varchar2(40),            /*自订字段-文字                          */
bxcud03     varchar2(40),            /*自订字段-文字                          */
bxcud04     varchar2(40),            /*自订字段-文字                          */
bxcud05     varchar2(40),            /*自订字段-文字                          */
bxcud06     varchar2(40),            /*自订字段-文字                          */
bxcud07     number(15,3),            /*自订字段-数值                          */
bxcud08     number(15,3),            /*自订字段-数值                          */
bxcud09     number(15,3),            /*自订字段-数值                          */
bxcud10     number(10),              /*自订字段-整数                          */
bxcud11     number(10),              /*自订字段-整数                          */
bxcud12     number(10),              /*自订字段-整数                          */
bxcud13     date,                    /*自订字段-日期                          */
bxcud14     date,                    /*自订字段-日期                          */
bxcud15     date,                    /*自订字段-日期                          */
bxcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
bxclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table bxc_file add  constraint bxc_pk primary key  (bxc01,bxc02) enable validate;
grant select on bxc_file to tiptopgp;
grant update on bxc_file to tiptopgp;
grant delete on bxc_file to tiptopgp;
grant insert on bxc_file to tiptopgp;
grant index on bxc_file to public;
grant select on bxc_file to ods;
