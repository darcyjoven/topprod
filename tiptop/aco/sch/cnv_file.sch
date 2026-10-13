/*
================================================================================
檔案代號:cnv_file
檔案名稱:内销申请单身档(A087)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnv_file
(
cnv01       varchar2(20) NOT NULL,   /*申请编号                               */
cnv02       number(5) NOT NULL,      /*行序                                   */
cnv03       number(5),               /*公司序号                               */
cnv04       varchar2(40),            /*商品编号                               */
cnv041      varchar2(20),            /*版本                                   */
cnv05       number(15,3),            /*申请数量                               */
cnv051      number(15,3),            /*内销数量                               */
cnv06       varchar2(4),             /*单位                                   */
cnv07       number(20,6),            /*单价                                   */
cnv08       number(20,6),            /*总价                                   */
cnv09       varchar2(10),            /*海关编号                               */
cnv10       varchar2(1),             /*No Use                                 */
cnv11       varchar2(1),             /*No Use                                 */
cnvud01     varchar2(255),           /*自订字段-Textedit                      */
cnvud02     varchar2(40),            /*自订字段-文字                          */
cnvud03     varchar2(40),            /*自订字段-文字                          */
cnvud04     varchar2(40),            /*自订字段-文字                          */
cnvud05     varchar2(40),            /*自订字段-文字                          */
cnvud06     varchar2(40),            /*自订字段-文字                          */
cnvud07     number(15,3),            /*自订字段-数值                          */
cnvud08     number(15,3),            /*自订字段-数值                          */
cnvud09     number(15,3),            /*自订字段-数值                          */
cnvud10     number(10),              /*自订字段-整数                          */
cnvud11     number(10),              /*自订字段-整数                          */
cnvud12     number(10),              /*自订字段-整数                          */
cnvud13     date,                    /*自订字段-日期                          */
cnvud14     date,                    /*自订字段-日期                          */
cnvud15     date,                    /*自订字段-日期                          */
cnvplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnvlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnv_file add  constraint cnv_pk primary key  (cnv01,cnv02) enable validate;
grant select on cnv_file to tiptopgp;
grant update on cnv_file to tiptopgp;
grant delete on cnv_file to tiptopgp;
grant insert on cnv_file to tiptopgp;
grant index on cnv_file to public;
grant select on cnv_file to ods;
