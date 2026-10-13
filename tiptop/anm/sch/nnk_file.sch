/*
================================================================================
檔案代號:nnk_file
檔案名稱:信用状还本付款单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnk_file
(
nnk01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號                               */
nnk02       date,                    /*付款日期                               */
nnk03       date,                    /*No Use                                 */
nnk04       varchar2(4),             /*贷款币种                               */
                                     /*貸款幣別                               */
nnk05       varchar2(20),            /*信贷银行                               */
                                     /*信貸銀行(付款廠商)                     */
nnk06       varchar2(20),            /*支付银行                               */
                                     /*支付銀行                               */
nnk07       varchar2(1),             /*银行类型                               */
                                     /*銀行類別 (1.支存   2.活存  )           */
nnk08       varchar2(4),             /*帐户币种                               */
                                     /*帳戶幣別                               */
nnk09       number(20,10),           /*出帐汇率                               */
                                     /*出帳匯率                               */
nnk10       varchar2(24),            /*支付科目编号                           */
                                     /*支付科目編號 (銀存科目或其他沖帳科目)  */
nnk11       number(20,6),            /*暂估原币应还                           */
                                     /*暫估原幣應還(單身合計)                 */
nnk12       number(20,6),            /*实付原币应还                           */
                                     /*實付原幣應還(單身合計)                 */
nnk13       number(20,6),            /*暂估本币应还                           */
                                     /*暫估本幣應還(單身合計)                 */
nnk14       number(20,6),            /*实付本币应还                           */
                                     /*實付本幣應還(單身合計)                 */
nnk15       number(10),              /*No Use                                 */
nnk16       number(20,6),            /*汇率差异                               */
                                     /*匯率差異    (單身合計)                 */
nnk17       number(20,6),            /*手续费                                 */
                                     /*手續費    add 99/05/07                 */
nnk18       varchar2(20),            /*扣除手续费银行                         */
                                     /*扣除手續費銀行   add 99/05/07          */
nnk19       varchar2(4),             /*现金变动码                             */
                                     /*現金變動碼  add 99/05/07               */
nnk20       varchar2(1),             /*No Use                                 */
nnk21       varchar2(20),            /*开票单号                               */
                                     /*開票單號                               */
nnk22       varchar2(2),             /*银存异动码                             */
                                     /*銀存異動碼                             */
nnk23       number(20,10),           /*换汇标准                               */
nnk24       varchar2(1),             /*No Use                                 */
nnk25       varchar2(1),             /*No Use                                 */
nnk26       varchar2(1),             /*No Use                                 */
nnk27       varchar2(1),             /*No Use                                 */
nnk28       varchar2(1),             /*No Use                                 */
nnk29       varchar2(1),             /*No Use                                 */
nnk30       varchar2(1),             /*No Use                                 */
nnkglno     varchar2(20),            /*付款凭证编号                           */
                                     /*付款傳票編號                           */
nnkconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
nnkinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
nnkacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nnkuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nnkgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
nnkmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
nnkdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nnk101      varchar2(24),            /*支付科目二                             */
nnkud01     varchar2(255),           /*自订字段-Textedit                      */
nnkud02     varchar2(40),            /*自订字段-文字                          */
nnkud03     varchar2(40),            /*自订字段-文字                          */
nnkud04     varchar2(40),            /*自订字段-文字                          */
nnkud05     varchar2(40),            /*自订字段-文字                          */
nnkud06     varchar2(40),            /*自订字段-文字                          */
nnkud07     number(15,3),            /*自订字段-数值                          */
nnkud08     number(15,3),            /*自订字段-数值                          */
nnkud09     number(15,3),            /*自订字段-数值                          */
nnkud10     number(10),              /*自订字段-整数                          */
nnkud11     number(10),              /*自订字段-整数                          */
nnkud12     number(10),              /*自订字段-整数                          */
nnkud13     date,                    /*自订字段-日期                          */
nnkud14     date,                    /*自订字段-日期                          */
nnkud15     date,                    /*自订字段-日期                          */
nnklegal    varchar2(10) NOT NULL,   /*所属法人                               */
nnkoriu     varchar2(10),            /*资料建立者                             */
nnkorig     varchar2(10)             /*资料建立部门                           */
);

create        index nnk_02 on nnk_file (nnk02);
create        index nnk_03 on nnk_file (nnkglno);
alter table nnk_file add  constraint nnk_pk primary key  (nnk01) enable validate;
grant select on nnk_file to tiptopgp;
grant update on nnk_file to tiptopgp;
grant delete on nnk_file to tiptopgp;
grant insert on nnk_file to tiptopgp;
grant index on nnk_file to public;
grant select on nnk_file to ods;
