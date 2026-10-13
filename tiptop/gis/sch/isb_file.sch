/*
================================================================================
檔案代號:isb_file
檔案名稱:销项发票底稿单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table isb_file
(
isb01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
isb02       varchar2(20) NOT NULL,   /*帐款号码                               */
                                     /*帳款號碼                               */
isb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
isb04       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
isb05       varchar2(120),           /*品名                                   */
isb06       varchar2(120),           /*规格                                   */
                                     /*規格                                   */
isb07       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
isb08       number(15,3),            /*数量                                   */
                                     /*數量                                   */
isb09       number(20,6),            /*税前金额                               */
                                     /*未稅金額                               */
isb09x      number(20,6),            /*税额                                   */
                                     /*稅額                                   */
isb09t      number(20,6),            /*含税金额                               */
                                     /*含稅金額                               */
isb10       varchar2(5),             /*商品类型                               */
                                     /*商品類別                               */
isbud01     varchar2(255),           /*自订字段-Textedit                      */
isbud02     varchar2(40),            /*自订字段-文字                          */
isbud03     varchar2(40),            /*自订字段-文字                          */
isbud04     varchar2(40),            /*自订字段-文字                          */
isbud05     varchar2(40),            /*自订字段-文字                          */
isbud06     varchar2(40),            /*自订字段-文字                          */
isbud07     number(15,3),            /*自订字段-数值                          */
isbud08     number(15,3),            /*自订字段-数值                          */
isbud09     number(15,3),            /*自订字段-数值                          */
isbud10     number(10),              /*自订字段-整数                          */
isbud11     number(10),              /*自订字段-整数                          */
isbud12     number(10),              /*自订字段-整数                          */
isbud13     date,                    /*自订字段-日期                          */
isbud14     date,                    /*自订字段-日期                          */
isbud15     date,                    /*自订字段-日期                          */
isblegal    varchar2(10) NOT NULL,   /*所属法人                               */
isb11       varchar2(20) DEFAULT ' ' NOT NULL /*发票代码*/
);

alter table isb_file add  constraint isb_pk primary key  (isb01,isb02,isb03,isb11) enable validate;
grant select on isb_file to tiptopgp;
grant update on isb_file to tiptopgp;
grant delete on isb_file to tiptopgp;
grant insert on isb_file to tiptopgp;
grant index on isb_file to public;
grant select on isb_file to ods;
