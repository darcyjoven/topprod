/*
================================================================================
檔案代號:aqg_file
檔案名稱:集团代收付冲账单单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqg_file
(
aqg00       varchar2(1),             /*代收付类型                             */
                                     /*For 內部帳戶                           */
aqg01       varchar2(20) NOT NULL,   /*集团代收付单号                         */
                                     /*For 內部帳戶                           */
aqg02       number(5) NOT NULL,      /*项次                                   */
                                     /*For 內部帳戶                           */
aqg03       varchar2(10),            /*代收/付款营运中心                      */
                                     /*For 内部帐户                           */
aqg04       varchar2(1),             /*性质                                   */
                                     /*For 內部帳戶                           */
aqg05       varchar2(24),            /*科目                                   */
                                     /*For 內部帳戶                           */
aqg06       number(20,6),            /*本币付款金额                           */
                                     /*For 內部帳戶                           */
aqg06f      number(20,6),            /*原币付款金额                           */
                                     /*For 內部帳戶                           */
aqg07       date,                    /*到期日                                 */
                                     /*For 內部帳戶                           */
aqg08       varchar2(20),            /*开票银行                               */
                                     /*For 內部帳戶                           */
aqg09       varchar2(4),             /*币种                                   */
                                     /*For 內部帳戶                           */
aqg10       number(20,10),           /*汇率                                   */
                                     /*For 內部帳戶                           */
aqg11       varchar2(2),             /*银存异动码                             */
                                     /*For 內部帳戶                           */
aqg12       varchar2(10),            /*原始部门                               */
                                     /*For 內部帳戶                           */
aqg13       varchar2(255),           /*摘要                                   */
                                     /*For 內部帳戶                           */
aqg14       varchar2(20),            /*应收帐款单号                           */
                                     /*For 內部帳戶                           */
aqg15       number(5),               /*帐款项次                               */
                                     /*For 內部帳戶                           */
aqg16       varchar2(20),            /*参考单号                               */
                                     /*For 內部帳戶                           */
aqg17       number(5),               /*多帐期项次                             */
                                     /*For 內部帳戶                           */
aqg18       varchar2(10),            /*帐款会计类型                           */
                                     /*For 內部帳戶                           */
aqg19       varchar2(6),             /*收付款条件                             */
                                     /*For 內部帳戶                           */
aqg20       varchar2(4),             /*税种                                   */
                                     /*For 內部帳戶                           */
aqg21       varchar2(20),            /*开票银行                               */
                                     /*For 內部帳戶                           */
aqg051      varchar2(24),            /*科目二                                 */
                                     /*For 內部帳戶                           */
aqgud01     varchar2(255),           /*自订字段-Textedit                      */
aqgud02     varchar2(40),            /*自订字段-文字                          */
aqgud03     varchar2(40),            /*自订字段-文字                          */
aqgud04     varchar2(40),            /*自订字段-文字                          */
aqgud05     varchar2(40),            /*自订字段-文字                          */
aqgud06     varchar2(40),            /*自订字段-文字                          */
aqgud07     number(15,3),            /*自订字段-数值                          */
aqgud08     number(15,3),            /*自订字段-数值                          */
aqgud09     number(15,3),            /*自订字段-数值                          */
aqgud10     number(10),              /*自订字段-整数                          */
aqgud11     number(10),              /*自订字段-整数                          */
aqgud12     number(10),              /*自订字段-整数                          */
aqgud13     date,                    /*自订字段-日期                          */
aqgud14     date,                    /*自订字段-日期                          */
aqgud15     date,                    /*自订字段-日期                          */
aqglegal    varchar2(10) NOT NULL,   /*所属法人                               */
aqg22       varchar2(10),            /*汇入/汇出性质                          */
aqg23       varchar2(10)             /*收费别                                 */
);

alter table aqg_file add  constraint aqg_pk primary key  (aqg01,aqg02) enable validate;
grant select on aqg_file to tiptopgp;
grant update on aqg_file to tiptopgp;
grant delete on aqg_file to tiptopgp;
grant insert on aqg_file to tiptopgp;
grant index on aqg_file to public;
grant select on aqg_file to ods;
