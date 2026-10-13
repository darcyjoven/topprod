/*
================================================================================
檔案代號:mmb_file
檔案名稱:零件加工档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmb_file
(
mmb01       varchar2(20) NOT NULL,   /*需求单编号                             */
                                     /*需求單編號 mma01                       */
mmb02       number(5) NOT NULL,      /*项次                                   */
mmb03       varchar2(15),            /*图号                                   */
                                     /*圖號                                   */
mmb04       varchar2(10),            /*版本                                   */
mmb05       varchar2(10),            /*加工码                                 */
                                     /*加工碼 mmc01                           */
mmb06       varchar2(80),            /*规格说明                               */
                                     /*規格說明                               */
mmb07       varchar2(1),             /*来源码                                 */
                                     /*來源碼 P:採購 M:自製 S:委外            */
mmb08       varchar2(10),            /*厂商或部门                             */
                                     /*廠商或部門                             */
mmb09       number(15,3),            /*应发数量                               */
                                     /*應發數量                               */
mmb10       number(20,6),            /*税前单价                               */
                                     /*未稅單價                               */
mmb11       number(5),               /*工时(分)                               */
mmb12       date,                    /*开始加工日期                           */
                                     /*開始加工日期                           */
mmb121      date,                    /*完成加工日期                           */
mmb13       varchar2(1),             /*打印通知单状态                         */
                                     /*0.不可列印 1.可列印 2.己列印           */
mmb131      varchar2(20),            /*通知单号                               */
mmb132      varchar2(10),            /*通知单号项次                           */
mmb14       varchar2(1),             /*结转否                                 */
                                     /*結轉否 (Y/N)                           */
mmb141      varchar2(20),            /*结转单号                               */
mmb15       varchar2(255),           /*备注                                   */
mmb16       number(20,6),            /*结转单价                               */
                                     /*結轉單價                               */
mmb17       number(5),               /*结转工时                               */
                                     /*結轉工時(分)                           */
mmb18       number(15,3),            /*结转数量                               */
                                     /*結轉數量                               */
mmb19       number(15,6),            /*工资率                                 */
                                     /*工資率                                 */
mmb20       date,                    /*结转日期                               */
                                     /*結轉日期                               */
mmbacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
mmbud01     varchar2(255),           /*自订字段-Textedit                      */
mmbud02     varchar2(40),            /*自订字段-文字                          */
mmbud03     varchar2(40),            /*自订字段-文字                          */
mmbud04     varchar2(40),            /*自订字段-文字                          */
mmbud05     varchar2(40),            /*自订字段-文字                          */
mmbud06     varchar2(40),            /*自订字段-文字                          */
mmbud07     number(15,3),            /*自订字段-数值                          */
mmbud08     number(15,3),            /*自订字段-数值                          */
mmbud09     number(15,3),            /*自订字段-数值                          */
mmbud10     number(10),              /*自订字段-整数                          */
mmbud11     number(10),              /*自订字段-整数                          */
mmbud12     number(10),              /*自订字段-整数                          */
mmbud13     date,                    /*自订字段-日期                          */
mmbud14     date,                    /*自订字段-日期                          */
mmbud15     date,                    /*自订字段-日期                          */
mmbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index mmb_02 on mmb_file (mmb131,mmb132);
alter table mmb_file add  constraint mmb_pk primary key  (mmb01,mmb02) enable validate;
grant select on mmb_file to tiptopgp;
grant update on mmb_file to tiptopgp;
grant delete on mmb_file to tiptopgp;
grant insert on mmb_file to tiptopgp;
grant index on mmb_file to public;
grant select on mmb_file to ods;
