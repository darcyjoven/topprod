/*
================================================================================
檔案代號:gxc_file
檔案名稱:外汇交易资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gxc_file
(
gxc01       varchar2(20) NOT NULL,   /*交易单号                               */
                                     /*交易單號                               */
gxc02       varchar2(1),             /*交易性质                               */
                                     /*交易性質                               */
gxc03       date,                    /*承作日期                               */
gxc04       date,                    /*交割日期                               */
gxc041      date,                    /*交割日期                               */
gxc05       varchar2(4),             /*买入币种                               */
                                     /*買入幣別                               */
gxc06       varchar2(4),             /*卖出币种                               */
                                     /*賣出幣別                               */
gxc07       varchar2(20),            /*承作银行                               */
                                     /*承作銀行                               */
gxc08       number(20,6),            /*承作金额                               */
                                     /*承作金額                               */
gxc09       number(20,10),           /*即期汇率                               */
                                     /*即期匯率                               */
gxc10       number(20,10),           /*交割汇率                               */
                                     /*交割匯率                               */
gxc11       number(20,10),           /*换汇标准                               */
                                     /*換匯標準                               */
gxc12       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
gxc13       varchar2(1),             /*确认码                                 */
                                     /*確認碼(Y/N/X) X.作廢                   */
gxc14       varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼                               */
gxc141      date,                    /*凭证日期                               */
                                     /*傳票日期                               */
gxcud01     varchar2(255),           /*自订字段-Textedit                      */
gxcud02     varchar2(40),            /*自订字段-文字                          */
gxcud03     varchar2(40),            /*自订字段-文字                          */
gxcud04     varchar2(40),            /*自订字段-文字                          */
gxcud05     varchar2(40),            /*自订字段-文字                          */
gxcud06     varchar2(40),            /*自订字段-文字                          */
gxcud07     number(15,3),            /*自订字段-数值                          */
gxcud08     number(15,3),            /*自订字段-数值                          */
gxcud09     number(15,3),            /*自订字段-数值                          */
gxcud10     number(10),              /*自订字段-整数                          */
gxcud11     number(10),              /*自订字段-整数                          */
gxcud12     number(10),              /*自订字段-整数                          */
gxcud13     date,                    /*自订字段-日期                          */
gxcud14     date,                    /*自订字段-日期                          */
gxcud15     date,                    /*自订字段-日期                          */
gxclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index gxc_02 on gxc_file (gxc14);
alter table gxc_file add  constraint gxc_pk primary key  (gxc01) enable validate;
grant select on gxc_file to tiptopgp;
grant update on gxc_file to tiptopgp;
grant delete on gxc_file to tiptopgp;
grant insert on gxc_file to tiptopgp;
grant index on gxc_file to public;
grant select on gxc_file to ods;
