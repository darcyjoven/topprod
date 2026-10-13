/*
================================================================================
檔案代號:alc_file
檔案名稱:信用状更改资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table alc_file
(
alc01       varchar2(20) NOT NULL,   /*L/C No.                                */
alc02       varchar2(1) DEFAULT '0' NOT NULL, /*更改次数*/
                                     /*修改次數                               */
alc08       date,                    /*更改日期                               */
                                     /*修改日期                               */
alc24       number(20,6),            /*更改金额                               */
                                     /*修改金額                               */
alc34       number(20,6),            /*预付金额                               */
                                     /*預付金額                               */
alc32       varchar2(255),           /*更改说明                               */
                                     /*修改說明 #genero 改成TEXTEDIT          */
alc43       varchar2(24),            /*付款科目                               */
                                     /*付款科目(銀行存款)                     */
alc51       number(20,10),           /*更改汇率                               */
                                     /*修改匯率                               */
alc52       number(20,6),            /*保证金                                 */
                                     /*保證金                                 */
alc53       number(20,6),            /*手续费                                 */
                                     /*手續費                                 */
alc54       number(20,6),            /*邮电费                                 */
                                     /*郵電費                                 */
alc55       number(20,6),            /*签证费                                 */
                                     /*簽証費                                 */
alc56       number(20,6),            /*保 险 费                               */
                                     /*保 險 費                               */
alc57       number(20,6),            /*其它费用                               */
                                     /*其它費用                               */
alc60       number(20,6),            /*更改应摊                               */
                                     /*修改應攤                               */
alc72       varchar2(20),            /*会计凭证单号                           */
                                     /*會計傳票單號                           */
alc73       varchar2(20),            /*付款凭证单号                           */
                                     /*付款傳票單號(會計付款)                 */
alc74       varchar2(20),            /*付款凭证单号                           */
                                     /*付款傳票單號                           */
alc78       varchar2(1),             /*付款审核码                             */
                                     /*付款確認碼 (Y/N)                       */
alc80       varchar2(1),             /*付款方式                               */
                                     /*付款方式 (0.本幣 1.原幣)               */
alc81       varchar2(20),            /*外币支付银行编号                       */
                                     /*外幣支付銀行編號                       */
alc82       varchar2(1),             /*银行类型                               */
                                     /*    銀行類別 (1.支存 2.活存 0.其它)    */
alc83       number(10),              /*电脑编号                               */
                                     /*    電腦編號 (銀行存款異動流水號)      */
alc84       number(20,10),           /*出帐汇率                               */
                                     /*    出帳匯率                           */
alc85       number(20,6),            /*本币保证金                             */
                                     /*    本幣保證金                         */
alc91       varchar2(20),            /*本币支付银行编号                       */
                                     /*本幣支付銀行編號                       */
alc92       varchar2(1),             /*银行类型                               */
                                     /*    銀行類別 (1.支存 2.活存 0.其它)    */
alc93       number(10),              /*电脑编号                               */
                                     /*    電腦編號 (銀行存款異動流水號)      */
alc931      varchar2(20),            /*开票单号                               */
                                     /*    開票單號                           */
alc932      varchar2(20),            /*支票号                                 */
                                     /*      支票號                           */
alc94       number(20,10),           /*支付汇率                               */
                                     /*    支付匯率                           */
alc951      number(20,6),            /*本币保证金                             */
                                     /*    本幣保證金                         */
alc952      number(20,6),            /*本币手续费                             */
                                     /*    本幣手續費                         */
alc953      number(20,6),            /*本币邮电费                             */
                                     /*    本幣郵電費                         */
alc95       number(20,6),            /*本币支付合计                           */
                                     /*    本幣支付合計(951+952+953)          */
alc96       varchar2(2),             /*银行异动码                             */
                                     /*銀行異動碼 #modify 00/07/27            */
alc76       number(5),               /*支票簿号                               */
                                     /*支票簿號   modi 00/05/22               */
alcfirm     varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
alcinpd     date,                    /*录入日期                               */
                                     /*輸入日期                               */
alcmksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
alcsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
alcdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
alcprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
alcsmax     number(5),               /*应签等级                               */
                                     /*應簽等級                               */
alcsseq     number(5),               /*已签等级                               */
                                     /*已簽等級                               */
alcacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
alcuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
alcgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
alcmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
alcdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
alc79       date,                    /*付款日期                               */
alc86       date,                    /*会计日期                               */
alc431      varchar2(24),            /*付款科目二                             */
alcud01     varchar2(255),           /*自订字段-Textedit                      */
alcud02     varchar2(40),            /*自订字段-文字                          */
alcud03     varchar2(40),            /*自订字段-文字                          */
alcud04     varchar2(40),            /*自订字段-文字                          */
alcud05     varchar2(40),            /*自订字段-文字                          */
alcud06     varchar2(40),            /*自订字段-文字                          */
alcud07     number(15,3),            /*自订字段-数值                          */
alcud08     number(15,3),            /*自订字段-数值                          */
alcud09     number(15,3),            /*自订字段-数值                          */
alcud10     number(10),              /*自订字段-整数                          */
alcud11     number(10),              /*自订字段-整数                          */
alcud12     number(10),              /*自订字段-整数                          */
alcud13     date,                    /*自订字段-日期                          */
alcud14     date,                    /*自订字段-日期                          */
alcud15     date,                    /*自订字段-日期                          */
alclegal    varchar2(10) NOT NULL,   /*所属法人                               */
alcoriu     varchar2(10),            /*资料建立者                             */
alcorig     varchar2(10)             /*资料建立部门                           */
);

create        index alc_02 on alc_file (alc72);
create        index alc_03 on alc_file (alc74);
alter table alc_file add  constraint alc_pk primary key  (alc01,alc02) enable validate;
grant select on alc_file to tiptopgp;
grant update on alc_file to tiptopgp;
grant delete on alc_file to tiptopgp;
grant insert on alc_file to tiptopgp;
grant index on alc_file to public;
grant select on alc_file to ods;
