/*
================================================================================
檔案代號:omb_file
檔案名稱:应收账款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table omb_file
(
omb00       varchar2(2),             /*帐款类型                               */
                                     /*帳款類別 (1*:應收帳款  2*:待抵帳款)oma00*/
omb01       varchar2(20) NOT NULL,   /*应收单号/待抵单号                      */
                                     /*應收單號/待抵單號 oma01                */
omb03       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
omb04       varchar2(40),            /*产品编号                               */
                                     /*產品編號 ima01/ogb04/ohb04             */
omb05       varchar2(4),             /*销售单位                               */
                                     /*銷售單位 gfe01/ogb05/ohb05             */
omb06       varchar2(120),           /*品名规格                               */
                                     /*品名規格                               */
omb12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
omb13       number(20,6) NOT NULL,   /*原币单价                               */
                                     /*原幣單價                               */
omb14       number(20,6) NOT NULL,   /*原币税前金额                           */
                                     /*原幣未稅金額                           */
omb14t      number(20,6) NOT NULL,   /*原币含税金额                           */
                                     /*原幣含稅金額                           */
omb15       number(20,6) NOT NULL,   /*本币单价                               */
                                     /*本幣單價                               */
omb16       number(20,6) NOT NULL,   /*本币税前金额                           */
                                     /*本幣未稅金額                           */
omb16t      number(20,6) NOT NULL,   /*本币含税金额                           */
                                     /*本幣含稅金額                           */
omb17       number(20,6),            /*发票单价                               */
                                     /*發票單價                               */
omb18       number(20,6),            /*发票税前金额                           */
                                     /*發票未稅金額                           */
omb18t      number(20,6),            /*发票含税金额                           */
                                     /*發票含稅金額                           */
omb31       varchar2(20),            /*出货单号/销退单号                      */
                                     /*出貨單號/銷退單號 ogb01/ohb01          */
omb32       number(5),               /*出货项次/销退项次                      */
                                     /*出貨項次/銷退項次 ogb03/ohb03          */
omb33       varchar2(24),            /*科目编号                               */
                                     /*科目編號 aag01                         */
omb34       number(20,6),            /*原币已冲金额                           */
                                     /*原幣已沖金額(for cec)                  */
omb35       number(20,6),            /*本币已冲金额                           */
                                     /*本幣已沖金額(for cec)                  */
omb36       number(20,10),           /*重估汇率                               */
omb37       number(20,6),            /*本币未冲金额                           */
                                     /*本幣未沖金額                           */
omb930      varchar2(10),            /*成本中心                               */
omb331      varchar2(24),            /*第二科目编码                           */
omb40       varchar2(10),            /*理由码                                 */
omb38       varchar2(2),             /*来源类型                               */
                                     /*01-Order,02-Delivery,03-Sales/Return,04-Return Benefit of Delivery,05-Return Benefit of Sales/Return,99-Other*/
omb39       varchar2(1),             /*搭赠                                   */
omb41       varchar2(10),            /*项目编号                               */
omb42       varchar2(30),            /*WBS编码                                */
omb43       varchar2(4),             /*活动编号                               */
ombud01     varchar2(255),           /*自订字段-Textedit                      */
ombud02     varchar2(40),            /*自订字段-文字                          */
ombud03     varchar2(40),            /*自订字段-文字                          */
ombud04     varchar2(40),            /*自订字段-文字                          */
ombud05     varchar2(40),            /*自订字段-文字                          */
ombud06     varchar2(40),            /*自订字段-文字                          */
ombud07     number(15,3),            /*自订字段-数值                          */
ombud08     number(15,3),            /*自订字段-数值                          */
ombud09     number(15,3),            /*自订字段-数值                          */
ombud10     number(10),              /*自订字段-整数                          */
ombud11     number(10),              /*自订字段-整数                          */
ombud12     number(10),              /*自订字段-整数                          */
ombud13     date,                    /*自订字段-日期                          */
ombud14     date,                    /*自订字段-日期                          */
ombud15     date,                    /*自订字段-日期                          */
omblegal    varchar2(10) NOT NULL,   /*所属法人                               */
omb44       varchar2(10),            /*资料来源工厂                           */
omb45       varchar2(10),            /*商户编号                               */
omb46       varchar2(1) DEFAULT ' ', /*开票性质                               */
omb47       varchar2(20),            /*帐款编号                               */
omb48       number(15,3) DEFAULT '0' NOT NULL
);

create        index omb_02 on omb_file (omb31,omb32);
create        index omb_03 on omb_file (omb04);
alter table omb_file add  constraint omb_pk primary key  (omb01,omb03) enable validate;
grant select on omb_file to tiptopgp;
grant update on omb_file to tiptopgp;
grant delete on omb_file to tiptopgp;
grant insert on omb_file to tiptopgp;
grant index on omb_file to public;
grant select on omb_file to ods;
