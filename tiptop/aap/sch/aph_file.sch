/*
================================================================================
檔案代號:aph_file
檔案名稱:付款单贷方单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aph_file
(
aph01       varchar2(20) NOT NULL,   /*付款单号                               */
                                     /*付款單號 apf01                         */
aph02       number(5) NOT NULL,      /*贷方项次                               */
                                     /*貸方項次                               */
aph03       varchar2(1),             /*性质                                   */
                                     /*性質                                   */
                                     /*0.應收 1.支票 2.轉帳 3.郵資 4.匯盈 5匯損*/
                                     /*6.折讓沖帳                             */
                                     /*7.D.M.沖帳  由aapt220 人為輸入         */
                                     /*8.預付沖帳  由aapt150 系統產生         */
                                     /*9.暫付沖帳  由aapt330 系統產生         */
                                     /*A.手續費(借方科目)由aapt330 系統產生   */
                                     /*B.轉帳手續費(貸方科目)由aapt330系統產生*/
                                     /*C:應付電匯款                           */
                                     /*Z:代付匯票                             */
aph04       varchar2(24),            /*贷方科目                               */
                                     /*貸方科目  aag01                        */
aph05f      number(20,6) NOT NULL,   /*原币付款金额                           */
                                     /*原幣付款金額                           */
aph05       number(20,6) NOT NULL,   /*本币付款金额                           */
                                     /*本幣付款金額                           */
aph06       date,                    /*No Use                                 */
aph07       date,                    /*到期日                                 */
aph08       varchar2(20),            /*开票银行                               */
                                     /*開票銀行                               */
aph09       varchar2(1),             /*是否已抛转票据                         */
                                     /*是否已拋轉票據 Y:已拋轉    N:尚未拋轉  */
aph13       varchar2(4),             /*币种                                   */
                                     /*幣別       azi01                       */
aph14       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
aph15       number(5),               /*簿号                                   */
                                     /*簿號                010508 add         */
aph16       varchar2(2),             /*银存异动码                             */
                                     /*銀存異動碼                             */
aph17       number(5),               /*子帐期项次                             */
aph041      varchar2(24),            /*贷方科目二                             */
aphud01     varchar2(255),           /*自订字段-Textedit                      */
aphud02     varchar2(40),            /*自订字段-文字                          */
aphud03     varchar2(40),            /*自订字段-文字                          */
aphud04     varchar2(40),            /*自订字段-文字                          */
aphud05     varchar2(40),            /*自订字段-文字                          */
aphud06     varchar2(40),            /*自订字段-文字                          */
aphud07     number(15,3),            /*自订字段-数值                          */
aphud08     number(15,3),            /*自订字段-数值                          */
aphud09     number(15,3),            /*自订字段-数值                          */
aphud10     number(10),              /*自订字段-整数                          */
aphud11     number(10),              /*自订字段-整数                          */
aphud12     number(10),              /*自订字段-整数                          */
aphud13     date,                    /*自订字段-日期                          */
aphud14     date,                    /*自订字段-日期                          */
aphud15     date,                    /*自订字段-日期                          */
aphlegal    varchar2(10) NOT NULL,   /*所属法人                               */
aph18       varchar2(10),            /*汇入/汇出性质                          */
aph19       varchar2(1),             /*收费别                                 */
aph20       varchar2(1),             /*全额到否                               */
aph21       varchar2(10),            /*转入厂商                               */
aph22       varchar2(10),            /*帐款类型                               */
aph23       varchar2(20),            /*帐款编号                               */
aph24       date,                    /*帐款日期                               */
aph25       varchar2(40) DEFAULT ' ',/*付款厂商简称                           */
aph26       varchar2(10)             /*员工编号                               */
);

create        index aph_02 on aph_file (aph04);
alter table aph_file add  constraint aph_pk primary key  (aph01,aph02) enable validate;
grant select on aph_file to tiptopgp;
grant update on aph_file to tiptopgp;
grant delete on aph_file to tiptopgp;
grant insert on aph_file to tiptopgp;
grant index on aph_file to public;
grant select on aph_file to ods;
