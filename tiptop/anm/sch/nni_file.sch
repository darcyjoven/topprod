/*
================================================================================
檔案代號:nni_file
檔案名稱:融资、长贷还息付款单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nni_file
(
nni01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號                               */
nni02       date,                    /*付款日期                               */
nni03       date,                    /*止算日期                               */
nni03_y     number(5),               /*利息年度                               */
nni03_m     number(5),               /*利息月份                               */
nni04       varchar2(4),             /*利息币种                               */
                                     /*利息幣別                               */
nni05       varchar2(20),            /*信贷银行                               */
                                     /*信貸銀行                               */
nni06       varchar2(20),            /*支付银行                               */
                                     /*支付銀行                               */
nni07       varchar2(1),             /*银行类型                               */
                                     /*銀行類別 (1.支存   2.非支存)           */
nni08       varchar2(4),             /*帐户币种                               */
                                     /*帳戶幣別                               */
nni09       number(20,10),           /*出帐汇率                               */
                                     /*出帳匯率                               */
nni10       varchar2(24),            /*付款科目                               */
nni11       number(20,6),            /*暂估原币利息                           */
                                     /*暫估原幣利息(單身合計) 02/11/26 alter  */
nni12       number(20,6),            /*实付原币利息                           */
                                     /*實付原幣利息(單身合計) 02/11/26 alter  */
nni13       number(20,6),            /*暂估本币利息                           */
                                     /*暫估本幣利息(單身合計) 02/11/26 alter  */
nni14       number(20,6),            /*实付本币利息                           */
                                     /*實付本幣利息(單身合計) 02/11/26 alter  */
nni15       number(20,6),            /*利率差异                               */
                                     /*利率差異    (單身合計) 02/11/26 alter  */
nni16       number(20,6),            /*汇率差异                               */
                                     /*匯率差異    (單身合計) 02/11/26 alter  */
nni21       varchar2(20),            /*开票单号                               */
                                     /*開票單號                               */
nni22       varchar2(2),             /*银存出帐异动码                         */
                                     /*銀存出帳異動碼                         */
nni23       number(10),              /*No Use                                 */
nni24       number(10),              /*No Use                                 */
nni25       number(10),              /*No Use                                 */
nniglno     varchar2(20),            /*付款凭证编号                           */
                                     /*付款傳票編號                           */
nniconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
nniinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
nniacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nniuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnigrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
nnimodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
nnidate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nni101      varchar2(24),            /*付款科目二                             */
nniud01     varchar2(255),           /*自订字段-Textedit                      */
nniud02     varchar2(40),            /*自订字段-文字                          */
nniud03     varchar2(40),            /*自订字段-文字                          */
nniud04     varchar2(40),            /*自订字段-文字                          */
nniud05     varchar2(40),            /*自订字段-文字                          */
nniud06     varchar2(40),            /*自订字段-文字                          */
nniud07     number(15,3),            /*自订字段-数值                          */
nniud08     number(15,3),            /*自订字段-数值                          */
nniud09     number(15,3),            /*自订字段-数值                          */
nniud10     number(10),              /*自订字段-整数                          */
nniud11     number(10),              /*自订字段-整数                          */
nniud12     number(10),              /*自订字段-整数                          */
nniud13     date,                    /*自订字段-日期                          */
nniud14     date,                    /*自订字段-日期                          */
nniud15     date,                    /*自订字段-日期                          */
nnilegal    varchar2(10) NOT NULL,   /*所属法人                               */
nnioriu     varchar2(10),            /*资料建立者                             */
nniorig     varchar2(10)             /*资料建立部门                           */
);

create        index nni_02 on nni_file (nni02);
create        index nni_03 on nni_file (nniglno);
alter table nni_file add  constraint nni_pk primary key  (nni01) enable validate;
grant select on nni_file to tiptopgp;
grant update on nni_file to tiptopgp;
grant delete on nni_file to tiptopgp;
grant insert on nni_file to tiptopgp;
grant index on nni_file to public;
grant select on nni_file to ods;
