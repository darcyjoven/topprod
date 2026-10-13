/*
================================================================================
檔案代號:cnn_file
檔案名稱:转厂申请单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table cnn_file
(
cnn01       varchar2(20) NOT NULL,   /*申请编号                               */
cnn02       number(5) NOT NULL,      /*行序                                   */
cnn03       number(5),               /*公司序号                               */
cnn04       varchar2(40),            /*商品编号                               */
cnn041      varchar2(20),            /*版本                                   */
                                     /*NO.A087 030814商品類別->版本           */
cnn05       number(15,3),            /*申请数量                               */
cnn051      number(15,3),            /*转厂数量                               */
cnn06       varchar2(4),             /*单位                                   */
cnn07       number(20,6),            /*单价                                   */
cnn08       number(20,6),            /*总价                                   */
cnn09       varchar2(10),            /*海关编号                               */
                                     /*No:BUG-490398                          */
cnn10       varchar2(1),             /*No Use                                 */
cnn11       varchar2(1),             /*No Use                                 */
cnnud01     varchar2(255),           /*自订字段-Textedit                      */
cnnud02     varchar2(40),            /*自订字段-文字                          */
cnnud03     varchar2(40),            /*自订字段-文字                          */
cnnud04     varchar2(40),            /*自订字段-文字                          */
cnnud05     varchar2(40),            /*自订字段-文字                          */
cnnud06     varchar2(40),            /*自订字段-文字                          */
cnnud07     number(15,3),            /*自订字段-数值                          */
cnnud08     number(15,3),            /*自订字段-数值                          */
cnnud09     number(15,3),            /*自订字段-数值                          */
cnnud10     number(10),              /*自订字段-整数                          */
cnnud11     number(10),              /*自订字段-整数                          */
cnnud12     number(10),              /*自订字段-整数                          */
cnnud13     date,                    /*自订字段-日期                          */
cnnud14     date,                    /*自订字段-日期                          */
cnnud15     date,                    /*自订字段-日期                          */
cnnplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
cnnlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table cnn_file add  constraint cnn_pk primary key  (cnn01,cnn02) enable validate;
grant select on cnn_file to tiptopgp;
grant update on cnn_file to tiptopgp;
grant delete on cnn_file to tiptopgp;
grant insert on cnn_file to tiptopgp;
grant index on cnn_file to public;
grant select on cnn_file to ods;
