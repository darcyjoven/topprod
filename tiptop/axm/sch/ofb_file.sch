/*
================================================================================
檔案代號:ofb_file
檔案名稱:INVOICE单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ofb_file
(
ofb01       varchar2(20) NOT NULL,   /*Invoice No.                            */
ofb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
ofb04       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
ofb05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 (與訂單必須一致)(No-Entry)    */
ofb06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
ofb07       varchar2(10),            /*额外品名编号                           */
                                     /*額外品名編號                           */
ofb11       varchar2(40),            /*客户产品编号                           */
                                     /*客戶產品編號                           */
ofb12       number(15,3) NOT NULL,   /*实际出货数量                           */
                                     /*實際出貨數量 (依銷售單位)              */
ofb13       number(20,6) NOT NULL,   /*原币单价                               */
                                     /*原幣單價                               */
ofb14       number(20,6) NOT NULL,   /*原币税前金额                           */
                                     /*原幣未稅金額                           */
ofb14t      number(20,6) NOT NULL,   /*原币含税金额                           */
                                     /*原幣含稅金額                           */
ofb31       varchar2(20),            /*订单单号                               */
                                     /*訂單單號                               */
ofb32       number(5),               /*订单项次                               */
                                     /*訂單項次                               */
ofb33       varchar2(20),            /*CKD工单编号                            */
                                     /*CKD工單編號                         9608*/
ofb34       varchar2(20),            /*出货通知单号                           */
                                     /*出貨通知單號          98/11/01         */
ofb35       number(5),               /*出货通知单号项次                       */
                                     /*出貨通知單號項次      98/11/01         */
ofb910      varchar2(4),             /*单位一                                 */
ofb911      number(20,8),            /*单位一换算率(与销售单位)               */
ofb912      number(15,3),            /*单位一数量                             */
ofb913      varchar2(4),             /*单位二                                 */
ofb914      number(20,8),            /*单位二换算率(与销售单位)               */
ofb915      number(15,3),            /*单位二数量                             */
ofb916      varchar2(4),             /*计价单位                               */
ofb917      number(15,3),            /*计价数量                               */
ofbud01     varchar2(255),           /*自订字段-Textedit                      */
ofbud02     varchar2(40),            /*自订字段-文字                          */
ofbud03     varchar2(40),            /*自订字段-文字                          */
ofbud04     varchar2(40),            /*自订字段-文字                          */
ofbud05     varchar2(40),            /*自订字段-文字                          */
ofbud06     varchar2(40),            /*自订字段-文字                          */
ofbud07     number(15,3),            /*自订字段-数值                          */
ofbud08     number(15,3),            /*自订字段-数值                          */
ofbud09     number(15,3),            /*自订字段-数值                          */
ofbud10     number(10),              /*自订字段-整数                          */
ofbud11     number(10),              /*自订字段-整数                          */
ofbud12     number(10),              /*自订字段-整数                          */
ofbud13     date,                    /*自订字段-日期                          */
ofbud14     date,                    /*自订字段-日期                          */
ofbud15     date,                    /*自订字段-日期                          */
ofbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ofblegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index ofb_02 on ofb_file (ofb04);
create        index ofb_03 on ofb_file (ofb31);
alter table ofb_file add  constraint ofb_pk primary key  (ofb01,ofb03) enable validate;
grant select on ofb_file to tiptopgp;
grant update on ofb_file to tiptopgp;
grant delete on ofb_file to tiptopgp;
grant insert on ofb_file to tiptopgp;
grant index on ofb_file to public;
grant select on ofb_file to ods;
