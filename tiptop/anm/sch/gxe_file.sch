/*
================================================================================
檔案代號:gxe_file
檔案名稱:外汇交割资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxe_file
(
gxe01       varchar2(20) NOT NULL,   /*交割单号                               */
                                     /*交易單號                               */
gxe011      number(5) NOT NULL,      /*交易次数                               */
                                     /*交易次數                               */
gxe02       varchar2(1),             /*交易性质                               */
                                     /*交易性質                               */
gxe03       date,                    /*承作日期                               */
gxe04       date,                    /*交割日期                               */
gxe05       varchar2(4),             /*买入币种                               */
                                     /*買入幣別                               */
gxe06       varchar2(4),             /*卖出币种                               */
                                     /*賣出幣別                               */
gxe07       varchar2(20),            /*存入银行                               */
                                     /*存入銀行                               */
gxe071      varchar2(20),            /*存出银行                               */
                                     /*存出銀行                               */
gxe08       number(20,6),            /*承作金额                               */
                                     /*承作金額                               */
gxe09       number(20,10),           /*出帐汇率                               */
                                     /*出帳匯率                               */
gxe10       number(20,10),           /*入帐汇率                               */
                                     /*入帳匯率                               */
gxe11       number(20,10),           /*换汇标准                               */
                                     /*換匯標準                               */
gxe12       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
gxe13       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X) X:作廢                   */
gxe14       varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼                               */
gxe141      date,                    /*凭证日期                               */
                                     /*傳票日期                               */
gxe15       varchar2(2),             /*出帐异动码                             */
                                     /*出帳異動碼                             */
gxe16       varchar2(2),             /*入帐异动码                             */
                                     /*入帳異動碼                             */
gxe17       varchar2(20),            /*手续费出帐银行                         */
                                     /*手續費出帳銀行                         */
gxe18       number(20,6),            /*手续费                                 */
                                     /*手續費                                 */
gxeud01     varchar2(255),           /*自订字段-Textedit                      */
gxeud02     varchar2(40),            /*自订字段-文字                          */
gxeud03     varchar2(40),            /*自订字段-文字                          */
gxeud04     varchar2(40),            /*自订字段-文字                          */
gxeud05     varchar2(40),            /*自订字段-文字                          */
gxeud06     varchar2(40),            /*自订字段-文字                          */
gxeud07     number(15,3),            /*自订字段-数值                          */
gxeud08     number(15,3),            /*自订字段-数值                          */
gxeud09     number(15,3),            /*自订字段-数值                          */
gxeud10     number(10),              /*自订字段-整数                          */
gxeud11     number(10),              /*自订字段-整数                          */
gxeud12     number(10),              /*自订字段-整数                          */
gxeud13     date,                    /*自订字段-日期                          */
gxeud14     date,                    /*自订字段-日期                          */
gxeud15     date,                    /*自订字段-日期                          */
gxe19       varchar2(20) DEFAULT ' ' NOT NULL, /*交易单号*/
gxelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index gxe_02 on gxe_file (gxe14);
alter table gxe_file add  constraint gxe_pk primary key  (gxe01,gxe011,gxe19) enable validate;
grant select on gxe_file to tiptopgp;
grant update on gxe_file to tiptopgp;
grant delete on gxe_file to tiptopgp;
grant insert on gxe_file to tiptopgp;
grant index on gxe_file to public;
grant select on gxe_file to ods;
