/*
================================================================================
檔案代號:oob_file
檔案名稱:收款单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oob_file
(
oob01       varchar2(20) NOT NULL,   /*收款单号                               */
                                     /*收款單號                               */
oob02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
oob03       varchar2(1),             /*借贷别                                 */
                                     /*借貸別 (1.借 2.貸)                     */
oob04       varchar2(1),             /*类型                                   */
                                     /*类型 (借:1/2/3/4/5/6/7/8/A/E/F/H/Q 贷:1/2/3/4/7/A/B/C/D/E/F/Q)*/
                                     /*  借:1.支票           4.杂项费用(MISC) */
                                     /*     2.T/T            5.坏帐           */
                                     /*     3.待抵帐款       6.收款折扣       */
                                     /*                      7.汇兑损失       */
                                     /*                      8.现金           */
                                     /*                      A.溢退           */
                                     /*                      E.联盟卡         */
                                     /*                      F.转费用         */
                                     /*                      H.转账扣费用(流通)*/
                                     /*                      Q.券             */
                                     /*  贷:1.应收帐款       3.转押金         */
                                     /*     2.转暂收(溢收)   4.其他收入       */
                                     /*                      7.汇兑收益       */
                                     /*                      A.T/T            */
                                     /*                      B.转收入         */
                                     /*                      C.溢收(流通)     */
                                     /*                      D.支票           */
                                     /*                      E.联盟卡         */
                                     /*                      F.转费用         */
                                     /*                      Q.券             */
oob05       varchar2(10),            /*来源营运中心                           */
oob06       varchar2(20),            /*参考单号                               */
                                     /*參考單號 (根據'類別'檢查正確原始單據)  */
                                     /*  借:1.收票單號       4.Null           */
                                     /*     2.銀存入帳單號   5.Null           */
                                     /*     3.待抵單號       6.Null           */
                                     /*  貸:1.帳單編號       3.Null           */
                                     /*     2.待抵單號                        */
oob07       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
oob08       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oob09       number(20,6) NOT NULL,   /*原币金额                               */
                                     /*原幣金額                               */
oob10       number(20,6) NOT NULL,   /*本币金额                               */
                                     /*本幣金額                               */
oob11       varchar2(24),            /*科目                                   */
oob12       varchar2(80),            /*摘要                                   */
oob13       varchar2(10),            /*原始部门                               */
                                     /*原始部門                               */
oob14       varchar2(20),            /*第二参考单号                           */
                                     /*第二參考單號                           */
                                     /*  借:1.支票號                          */
                                     /*  貸:1.發票                            */
oob15       number(5),               /*参考单号之项次                         */
                                     /*參考單號之項次                         */
oob16       varchar2(1),             /*No Use                                 */
oob17       varchar2(20),            /*银行编号                               */
oob18       varchar2(2),             /*银存异动码                             */
oob111      varchar2(24),            /*第二科目编码                           */
oob19       number(5),               /*子帐期项次                             */
oobud01     varchar2(255),           /*自订字段-Textedit                      */
oobud02     varchar2(40),            /*自订字段-文字                          */
oobud03     varchar2(40),            /*自订字段-文字                          */
oobud04     varchar2(40),            /*自订字段-文字                          */
oobud05     varchar2(40),            /*自订字段-文字                          */
oobud06     varchar2(40),            /*自订字段-文字                          */
oobud07     number(15,3),            /*自订字段-数值                          */
oobud08     number(15,3),            /*自订字段-数值                          */
oobud09     number(15,3),            /*自订字段-数值                          */
oobud10     number(10),              /*自订字段-整数                          */
oobud11     number(10),              /*自订字段-整数                          */
oobud12     number(10),              /*自订字段-整数                          */
oobud13     date,                    /*自订字段-日期                          */
oobud14     date,                    /*自订字段-日期                          */
oobud15     date,                    /*自订字段-日期                          */
oob20       varchar2(1),
oob21       varchar2(4),             /*现金变动码                             */
oob22       number(20,6),            /*交款金额                               */
oob23       date,                    /*到期日                                 */
ooblegal    varchar2(10) NOT NULL,   /*所属法人                               */
oob24       varchar2(10),            /*转入客户                               */
oob25       date,                    /*帐款日期                               */
oob26       varchar2(10),            /*科目類型                               */
oob27       varchar2(20)             /*帐款编号                               */
);

create        index oob_02 on oob_file (oob06,oob15);
alter table oob_file add  constraint oob_pk primary key  (oob01,oob02) enable validate;
grant select on oob_file to tiptopgp;
grant update on oob_file to tiptopgp;
grant delete on oob_file to tiptopgp;
grant insert on oob_file to tiptopgp;
grant index on oob_file to public;
grant select on oob_file to ods;
