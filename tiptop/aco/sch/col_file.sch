/*
================================================================================
檔案代號:col_file
檔案名稱:出货单材料核销底稿单身档 (A046)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table col_file
(
col01       varchar2(20) NOT NULL,   /*单据编号                               */
col02       number(5) NOT NULL,      /*单据编号-项次                          */
col03       number(5) NOT NULL,      /*项次                                   */
col04       varchar2(40),            /*商品编号                               */
col05       varchar2(1),             /*No Use                                 */
col06       varchar2(4),             /*单位                                   */
col07       number(16,8),            /*单耗                                   */
col08       number(9,5),             /*损耗率                                 */
col09       number(15,3),            /*成品折算数量                           */
col10       number(15,3),            /*调整后数量                             */
col11       number(16,8),            /*单耗-调整前                            */
col12       number(16,8),            /*损耗率-调整前                          */
col13       varchar2(1),             /*No Use                                 */
col14       varchar2(1),             /*No Use                                 */
col15       varchar2(1),             /*No Use                                 */
colud01     varchar2(255),           /*自订字段-Textedit                      */
colud02     varchar2(40),            /*自订字段-文字                          */
colud03     varchar2(40),            /*自订字段-文字                          */
colud04     varchar2(40),            /*自订字段-文字                          */
colud05     varchar2(40),            /*自订字段-文字                          */
colud06     varchar2(40),            /*自订字段-文字                          */
colud07     number(15,3),            /*自订字段-数值                          */
colud08     number(15,3),            /*自订字段-数值                          */
colud09     number(15,3),            /*自订字段-数值                          */
colud10     number(10),              /*自订字段-整数                          */
colud11     number(10),              /*自订字段-整数                          */
colud12     number(10),              /*自订字段-整数                          */
colud13     date,                    /*自订字段-日期                          */
colud14     date,                    /*自订字段-日期                          */
colud15     date,                    /*自订字段-日期                          */
colplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
collegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table col_file add  constraint col_pk primary key  (col01,col02,col03) enable validate;
grant select on col_file to tiptopgp;
grant update on col_file to tiptopgp;
grant delete on col_file to tiptopgp;
grant insert on col_file to tiptopgp;
grant index on col_file to public;
grant select on col_file to ods;
