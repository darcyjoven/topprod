/*
================================================================================
檔案代號:npn_file
檔案名稱:应收票据异动单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table npn_file
(
npn01       varchar2(20) NOT NULL,   /*单据编号                               */
                                     /*單據編號                               */
npn02       date,                    /*单据日期                               */
                                     /*單據日期                               */
npn03       varchar2(1),             /*异动别                                 */
                                     /*Transaction Type 1.Drawing Note 2.Collection 3.Pledge 4.Discount 6.Withdraw 7.Note Returned 8.Cash*/
npn04       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
npn05       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
npn06       varchar2(24),            /*借方科目                               */
npn07       varchar2(24),            /*贷方科目                               */
                                     /*貸方科目                               */
npn08       varchar2(80),            /*摘要                                   */
npn09       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
npn10       number(20,6),            /*原币金额                               */
                                     /*原幣金額                               */
npn11       number(20,6),            /*本币收{票金额                          */
npn12       number(20,6),            /*本币异动金额                           */
                                     /*本幣異動金額                           */
npn13       varchar2(20),            /*托收银行                               */
                                     /*託收銀行                               */
npn14       varchar2(10),            /*转付厂商                               */
                                     /*轉付廠商                               */
npnconf     varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X)                          */
npnuser     varchar2(10),            /*资料录入者                             */
                                     /*資料輸入者                             */
npngrup     varchar2(10),            /*资料录入者部门                         */
                                     /*資料輸入者部門                         */
npnmodu     varchar2(10),            /*资料更改者                             */
npndate     date,                    /*资料录入日期                           */
                                     /*資料輸入日期                           */
npn061      varchar2(24),            /*借方科目二                             */
npn071      varchar2(24),            /*贷方科目二                             */
npnud01     varchar2(255),           /*自订字段-Textedit                      */
npnud02     varchar2(40),            /*自订字段-文字                          */
npnud03     varchar2(40),            /*自订字段-文字                          */
npnud04     varchar2(40),            /*自订字段-文字                          */
npnud05     varchar2(40),            /*自订字段-文字                          */
npnud06     varchar2(40),            /*自订字段-文字                          */
npnud07     number(15,3),            /*自订字段-数值                          */
npnud08     number(15,3),            /*自订字段-数值                          */
npnud09     number(15,3),            /*自订字段-数值                          */
npnud10     number(10),              /*自订字段-整数                          */
npnud11     number(10),              /*自订字段-整数                          */
npnud12     number(10),              /*自订字段-整数                          */
npnud13     date,                    /*自订字段-日期                          */
npnud14     date,                    /*自订字段-日期                          */
npnud15     date,                    /*自订字段-日期                          */
npnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
npnoriu     varchar2(10),            /*资料建立者                             */
npnorig     varchar2(10)             /*资料建立部门                           */
);

create        index npn_02 on npn_file (npn02);
create        index npn_03 on npn_file (npn09);
alter table npn_file add  constraint npn_pk primary key  (npn01) enable validate;
grant select on npn_file to tiptopgp;
grant update on npn_file to tiptopgp;
grant delete on npn_file to tiptopgp;
grant insert on npn_file to tiptopgp;
grant index on npn_file to public;
grant select on npn_file to ods;
