/*
================================================================================
檔案代號:rmf_file
檔案名稱:RMA 覆出单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmf_file
(
rmf01       varchar2(20) NOT NULL,   /*覆出单号                               */
                                     /*覆出單號                               */
rmf02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmf03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rmf04       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmf06       varchar2(120),           /*品名                                   */
rmf061      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmf07       varchar2(20),            /*RMA单号                                */
                                     /*RMA單號                                */
rmf08       number(5),               /*产品资料-项次                          */
                                     /*產品資料-項次(rmb_file)                */
rmf11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號                           */
rmf12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
rmf121      number(15,3) NOT NULL,   /*软盘数量                               */
                                     /*磁片數量                               */
rmf13       number(20,6) NOT NULL,   /*单价-原RMA文件单价                     */
                                     /*單價-原RMA文件單價                     */
rmf14       number(20,6) NOT NULL,   /*金额                                   */
                                     /*金額=rmf13*rmf12                       */
rmf16       number(20,6) NOT NULL,   /*成本金额                               */
                                     /*成本金額=sum(rmc12+rmc13)              */
rmf17       number(20,6) NOT NULL,   /*应收金额                               */
                                     /*應收金額=sum(rmc19)                    */
rmf21       varchar2(1),             /*收费否                                 */
                                     /*收費否: Y/N                            */
rmf22       number(15,3) NOT NULL,   /*随机出货数量                           */
                                     /*隨機出貨數量                           */
rmf23       number(20,6) NOT NULL,   /*随机单价                               */
                                     /*隨機單價                               */
rmf24       number(20,6) NOT NULL,   /*随机金额                               */
                                     /*隨機金額                               */
rmf25       varchar2(1),             /*修复否                                 */
                                     /*修復否(5:表修/6:表不修)                */
rmf31       number(5),               /*栈板编号                               */
                                     /*棧板編號                               */
rmf32       varchar2(11),            /*栈板长宽高                             */
                                     /*棧板長寬高                             */
rmf33       number(5),               /*箱号                                   */
                                     /*箱號                                   */
rmf34       varchar2(11),            /*箱号长宽高                             */
                                     /*箱號長寬高                             */
rmf35       number(15,3),            /*箱号重量                               */
                                     /*箱號重量                               */
rmfud01     varchar2(255),           /*自订字段-Textedit                      */
rmfud02     varchar2(40),            /*自订字段-文字                          */
rmfud03     varchar2(40),            /*自订字段-文字                          */
rmfud04     varchar2(40),            /*自订字段-文字                          */
rmfud05     varchar2(40),            /*自订字段-文字                          */
rmfud06     varchar2(40),            /*自订字段-文字                          */
rmfud07     number(15,3),            /*自订字段-数值                          */
rmfud08     number(15,3),            /*自订字段-数值                          */
rmfud09     number(15,3),            /*自订字段-数值                          */
rmfud10     number(10),              /*自订字段-整数                          */
rmfud11     number(10),              /*自订字段-整数                          */
rmfud12     number(10),              /*自订字段-整数                          */
rmfud13     date,                    /*自订字段-日期                          */
rmfud14     date,                    /*自订字段-日期                          */
rmfud15     date,                    /*自订字段-日期                          */
rmfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmf_file add  constraint rmf_pk primary key  (rmf01,rmf02) enable validate;
grant select on rmf_file to tiptopgp;
grant update on rmf_file to tiptopgp;
grant delete on rmf_file to tiptopgp;
grant insert on rmf_file to tiptopgp;
grant index on rmf_file to public;
grant select on rmf_file to ods;
