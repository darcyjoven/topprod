/*
================================================================================
檔案代號:gxi_file
檔案名稱:利息收入单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxi_file
(
gxi01       varchar2(20) NOT NULL,   /*利息收入单号                           */
                                     /*利息收入單號                           */
gxi02       date,                    /*利息收入日期                           */
gxi03       date,                    /*止算日期                               */
gxi03_y     number(5),               /*利息年度                               */
gxi03_m     number(5),               /*利息月份                               */
gxi04       varchar2(4),             /*利息币种                               */
                                     /*利息幣別                               */
gxi05       varchar2(20),            /*原存银行                               */
                                     /*信貸銀行                               */
gxi06       varchar2(20),            /*支付银行                               */
                                     /*支付銀行                               */
gxi07       varchar2(1),             /*银行类型                               */
                                     /*銀行類別 (1.支存   2.非支存)           */
gxi08       varchar2(4),             /*帐户币种                               */
                                     /*帳戶幣別                               */
gxi09       number(20,10),           /*出帐汇率                               */
                                     /*出帳匯率                               */
gxi10       varchar2(24),            /*利息收入科目                           */
gxi11       number(20,6),            /*暂估原币利息                           */
                                     /*暫估原幣利息(單身合計) 02/11/26 alter  */
gxi12       number(20,6),            /*实付原币利息                           */
                                     /*實付原幣利息(單身合計) 02/11/26 alter  */
gxi13       number(20,6),            /*暂估本币利息                           */
                                     /*暫估本幣利息(單身合計) 02/11/26 alter  */
gxi14       number(20,6),            /*实付本币利息                           */
                                     /*實付本幣利息(單身合計) 02/11/26 alter  */
gxi15       number(20,6),            /*利率差异                               */
                                     /*利率差異    (單身合計) 02/11/26 alter  */
gxi16       number(20,6),            /*汇率差异                               */
                                     /*匯率差異    (單身合計) 02/11/26 alter  */
gxi17       varchar2(20),            /*存入银行                               */
                                     /*存入銀行 add                           */
gxi18       number(20,6),            /*代扣原币所得税                         */
                                     /*Whithholding Original Currency of Income Tax(Body Total)*/
gxi19       number(20,6),            /*代扣本币所得税                         */
                                     /*Whithholding Home Currency of Income Tax(Body Total)  02/11/26 alter*/
gxi21       varchar2(20),            /*开票单号                               */
gxi22       varchar2(2),             /*银存出帐异动码                         */
                                     /*銀存出帳異動碼                         */
gxi23       number(10),              /*No Use                                 */
gxi24       number(10),              /*No Use                                 */
gxi25       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
gxiglno     varchar2(20),            /*利息收入凭证编号                       */
                                     /*利息收入傳票編號                       */
gxiconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
gxiinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
gxiacti     varchar2(1),             /*资料有效码                             */
gxiuser     varchar2(10),            /*资料所有者                             */
gxigrup     varchar2(10),            /*资料所有群                             */
gximodu     varchar2(10),            /*资料更改者                             */
gxidate     date,                    /*最近更改日                             */
gxi101      varchar2(24),            /*利息收入科目二                         */
gxiud01     varchar2(255),           /*自订字段-Textedit                      */
gxiud02     varchar2(40),            /*自订字段-文字                          */
gxiud03     varchar2(40),            /*自订字段-文字                          */
gxiud04     varchar2(40),            /*自订字段-文字                          */
gxiud05     varchar2(40),            /*自订字段-文字                          */
gxiud06     varchar2(40),            /*自订字段-文字                          */
gxiud07     number(15,3),            /*自订字段-数值                          */
gxiud08     number(15,3),            /*自订字段-数值                          */
gxiud09     number(15,3),            /*自订字段-数值                          */
gxiud10     number(10),              /*自订字段-整数                          */
gxiud11     number(10),              /*自订字段-整数                          */
gxiud12     number(10),              /*自订字段-整数                          */
gxiud13     date,                    /*自订字段-日期                          */
gxiud14     date,                    /*自订字段-日期                          */
gxiud15     date,                    /*自订字段-日期                          */
gxilegal    varchar2(10) NOT NULL,   /*所属法人                               */
gxioriu     varchar2(10),            /*资料建立者                             */
gxiorig     varchar2(10)             /*资料建立部门                           */
);

create        index gxi_02 on gxi_file (gxi02);
create        index gxi_03 on gxi_file (gxiglno);
alter table gxi_file add  constraint gxi_pk primary key  (gxi01) enable validate;
grant select on gxi_file to tiptopgp;
grant update on gxi_file to tiptopgp;
grant delete on gxi_file to tiptopgp;
grant insert on gxi_file to tiptopgp;
grant index on gxi_file to public;
grant select on gxi_file to ods;
