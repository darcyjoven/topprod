/*
================================================================================
檔案代號:gxl_file
檔案名稱:定存到期收款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxl_file
(
gxl01       varchar2(20) NOT NULL,   /*收款单号                               */
gxl02       number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
gxl03       varchar2(20),            /*申请单号                               */
                                     /*申請單號                  #02/12/10 modi*/
gxl04       varchar2(20),            /*定存单号                               */
                                     /*定存單號                               */
gxl11       number(20,6),            /*应收原币                               */
                                     /*應收原幣                               */
gxl12       number(20,6),            /*实收原币                               */
                                     /*實收原幣                               */
gxl13       number(20,6),            /*应收本币                               */
                                     /*應收本幣                               */
gxl14       number(20,6),            /*实收本币                               */
                                     /*實收本幣                               */
gxl15       number(20,6),            /*应收利息原币                           */
                                     /*應收利息原幣                           */
gxl16       number(20,6),            /*汇差损失                               */
                                     /*匯差損失                               */
gxl17       number(20,6),            /*应收利息本币                           */
                                     /*應收利息本幣                           */
gxl18       number(20,6),            /*本币应收利息所得税                     */
                                     /*應收利息所得稅                         */
gxl19       date,                    /*续约到期日                             */
                                     /*續約到期日               #03/01/08 add */
gxl20       number(9,4),             /*续约利率                               */
                                     /*續約利率                 #No:7354      */
gxl21       number(20,6),            /*续约定存金额                           */
                                     /*續約定存金額             #03/01/08 add */
gxl181      number(20,6),            /*原币应收利息所得税                     */
gxlud01     varchar2(255),           /*自订字段-Textedit                      */
gxlud02     varchar2(40),            /*自订字段-文字                          */
gxlud03     varchar2(40),            /*自订字段-文字                          */
gxlud04     varchar2(40),            /*自订字段-文字                          */
gxlud05     varchar2(40),            /*自订字段-文字                          */
gxlud06     varchar2(40),            /*自订字段-文字                          */
gxlud07     number(15,3),            /*自订字段-数值                          */
gxlud08     number(15,3),            /*自订字段-数值                          */
gxlud09     number(15,3),            /*自订字段-数值                          */
gxlud10     number(10),              /*自订字段-整数                          */
gxlud11     number(10),              /*自订字段-整数                          */
gxlud12     number(10),              /*自订字段-整数                          */
gxlud13     date,                    /*自订字段-日期                          */
gxlud14     date,                    /*自订字段-日期                          */
gxlud15     date,                    /*自订字段-日期                          */
gxllegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table gxl_file add  constraint gxl_pk primary key  (gxl01,gxl02) enable validate;
grant select on gxl_file to tiptopgp;
grant update on gxl_file to tiptopgp;
grant delete on gxl_file to tiptopgp;
grant insert on gxl_file to tiptopgp;
grant index on gxl_file to public;
grant select on gxl_file to ods;
