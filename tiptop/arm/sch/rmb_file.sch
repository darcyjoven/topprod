/*
================================================================================
檔案代號:rmb_file
檔案名稱:RMA 档案单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmb_file
(
rmb01       varchar2(20) NOT NULL,   /*RMA 单号                               */
                                     /*RMA 單號                               */
rmb02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmb03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
rmb04       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmb05       varchar2(120),           /*品名                                   */
rmb06       varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmb11       number(15,3) NOT NULL,   /*INVO数量                               */
                                     /*INVO數量                               */
rmb111      number(15,3) NOT NULL,   /*INVO已出数量                           */
                                     /*INVO已出數量                           */
rmb12       number(15,3) NOT NULL,   /*实际收料数量                           */
                                     /*實際收料數量                           */
rmb121      number(15,3) NOT NULL,   /*实际已出数量                           */
                                     /*實際已出數量                           */
rmb13       number(20,6) NOT NULL,   /*单价                                   */
                                     /*單價                                   */
rmb14       number(20,6) NOT NULL,   /*金额                                   */
                                     /*金額                                   */
rmb15       varchar2(2),             /*栈板编号                               */
                                     /*棧板編號(P/NO) 980424                  */
rmb16       varchar2(8),             /*箱号                                   */
                                     /*箱號(C/NO)     980424                  */
rmb17       varchar2(20),            /*原发票编号                             */
                                     /*原發票編號                             */
rmb909      varchar2(1),             /*保税撷取否                             */
                                     /*保稅擷取否                             */
rmbud01     varchar2(255),           /*自订字段-Textedit                      */
rmbud02     varchar2(40),            /*自订字段-文字                          */
rmbud03     varchar2(40),            /*自订字段-文字                          */
rmbud04     varchar2(40),            /*自订字段-文字                          */
rmbud05     varchar2(40),            /*自订字段-文字                          */
rmbud06     varchar2(40),            /*自订字段-文字                          */
rmbud07     number(15,3),            /*自订字段-数值                          */
rmbud08     number(15,3),            /*自订字段-数值                          */
rmbud09     number(15,3),            /*自订字段-数值                          */
rmbud10     number(10),              /*自订字段-整数                          */
rmbud11     number(10),              /*自订字段-整数                          */
rmbud12     number(10),              /*自订字段-整数                          */
rmbud13     date,                    /*自订字段-日期                          */
rmbud14     date,                    /*自订字段-日期                          */
rmbud15     date,                    /*自订字段-日期                          */
rmbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table rmb_file add  constraint rmb_pk primary key  (rmb01,rmb02) enable validate;
grant select on rmb_file to tiptopgp;
grant update on rmb_file to tiptopgp;
grant delete on rmb_file to tiptopgp;
grant insert on rmb_file to tiptopgp;
grant index on rmb_file to public;
grant select on rmb_file to ods;
