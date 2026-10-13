/*
================================================================================
檔案代號:gxk_file
檔案名稱:定存到期收款单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxk_file
(
gxk01       varchar2(20) NOT NULL,   /*收款单号                               */
                                     /*收款單號                               */
gxk02       date,                    /*收款日期                               */
gxk03       date,                    /*No Use                                 */
gxk04       varchar2(4),             /*贷款币种                               */
                                     /*貸款幣別                               */
gxk05       varchar2(20),            /*原存银行                               */
                                     /*原存銀行                               */
gxk06       varchar2(20),            /*存入银行                               */
                                     /*存入銀行                               */
gxk07       varchar2(1),             /*银行类型                               */
                                     /*銀行類別 (1.支存   2.活存  )           */
gxk08       varchar2(4),             /*帐户币种                               */
                                     /*帳戶幣別                               */
gxk09       number(20,10),           /*出帐汇率                               */
                                     /*出帳匯率 No.7952                       */
gxk10       varchar2(24),            /*支收科目编号                           */
                                     /*Expense/Income Account No.(Bank Account Or Other Striking Balance Account)*/
gxk11       number(20,6),            /*暂估原币应收                           */
                                     /*暫估原幣應收(單身合計)                 */
gxk12       number(20,6),            /*实收原币应收                           */
                                     /*實收原幣應收(單身合計)                 */
gxk13       number(20,6),            /*暂估本币应收                           */
                                     /*暫估本幣應收(單身合計)                 */
gxk14       number(20,6),            /*实收本币应收                           */
                                     /*實收本幣應收(單身合計)                 */
gxk15       number(10),              /*No Use                                 */
gxk16       number(20,6),            /*汇率差异                               */
                                     /*匯率差異    (單身合計)                 */
gxk17       number(15,3),            /*No Use                                 */
gxk18       varchar2(11),            /*No Use                                 */
gxk19       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼                             */
gxk20       varchar2(1),             /*性质                                   */
                                     /*性質                      #02/12/10modi*/
                                     /*1.到期 2.解約 3.到期續存               */
gxk21       varchar2(20),            /*开票单号                               */
gxk22       varchar2(2),             /*银存异动码                             */
                                     /*銀存異動碼                             */
gxk23       number(10),              /*No Use                                 */
gxk24       varchar2(2),             /*银存异动码                             */
                                     /*銀存異動碼                #02/12/10modi*/
gxk25       varchar2(1),             /*No Use                                 */
gxk26       varchar2(1),             /*No Use                                 */
gxk27       varchar2(1),             /*No Use                                 */
gxk28       varchar2(1),             /*No Use                                 */
gxk29       varchar2(1),             /*No Use                                 */
gxk30       date,                    /*凭证日期                               */
                                     /*傳票日期                               */
gxkglno     varchar2(20),            /*收款凭证编号                           */
                                     /*收款傳票編號                           */
gxkconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
gxkinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
gxkacti     varchar2(1),             /*资料有效码                             */
gxkuser     varchar2(10),            /*资料所有者                             */
gxkgrup     varchar2(10),            /*资料所有群                             */
gxkmodu     varchar2(10),            /*资料更改者                             */
gxkdate     date,                    /*最近更改日                             */
gxk101      varchar2(24),            /*支收科目编号二                         */
gxkud01     varchar2(255),           /*自订字段-Textedit                      */
gxkud02     varchar2(40),            /*自订字段-文字                          */
gxkud03     varchar2(40),            /*自订字段-文字                          */
gxkud04     varchar2(40),            /*自订字段-文字                          */
gxkud05     varchar2(40),            /*自订字段-文字                          */
gxkud06     varchar2(40),            /*自订字段-文字                          */
gxkud07     number(15,3),            /*自订字段-数值                          */
gxkud08     number(15,3),            /*自订字段-数值                          */
gxkud09     number(15,3),            /*自订字段-数值                          */
gxkud10     number(10),              /*自订字段-整数                          */
gxkud11     number(10),              /*自订字段-整数                          */
gxkud12     number(10),              /*自订字段-整数                          */
gxkud13     date,                    /*自订字段-日期                          */
gxkud14     date,                    /*自订字段-日期                          */
gxkud15     date,                    /*自订字段-日期                          */
gxklegal    varchar2(10) NOT NULL,   /*所属法人                               */
gxkoriu     varchar2(10),            /*资料建立者                             */
gxkorig     varchar2(10)             /*资料建立部门                           */
);

create        index gxk_02 on gxk_file (gxk02);
create        index gxk_03 on gxk_file (gxkglno);
alter table gxk_file add  constraint gxk_pk primary key  (gxk01) enable validate;
grant select on gxk_file to tiptopgp;
grant update on gxk_file to tiptopgp;
grant delete on gxk_file to tiptopgp;
grant insert on gxk_file to tiptopgp;
grant index on gxk_file to public;
grant select on gxk_file to ods;
