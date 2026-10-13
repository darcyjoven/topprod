/*
================================================================================
檔案代號:aqf_file
檔案名稱:集团代收付账款单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aqf_file
(
aqf00       varchar2(1),             /*代收付类型                             */
                                     /*For 內部帳戶                           */
aqf01       varchar2(20) NOT NULL,   /*代收付款单号                           */
                                     /*For 內部帳戶                           */
aqf02       number(5) NOT NULL,      /*项次                                   */
                                     /*For 內部帳戶                           */
aqf03       varchar2(10),            /*帐款营运中心                           */
                                     /*For 內部帳戶                           */
aqf04       varchar2(20),            /*帐款编号                               */
                                     /*For 內部帳戶                           */
aqf05       number(20,6),            /*本币冲帐金额                           */
                                     /*For 內部帳戶                           */
aqf05f      number(20,6),            /*原币冲帐金额                           */
                                     /*For 內部帳戶                           */
aqf06       number(5),               /*多帐期项次                             */
                                     /*For 內部帳戶                           */
aqf11       varchar2(10),            /*帐款类型                               */
                                     /*For 內部帳戶                           */
aqf12       varchar2(6),             /*收付款条件                             */
                                     /*For 內部帳戶                           */
aqf13       varchar2(4),             /*税种                                   */
                                     /*For 內部帳戶                           */
aqf14       varchar2(20),            /*内部帐户                               */
                                     /*For 內部帳戶                           */
aqf15       varchar2(2),             /*内部帐户银行异动码                     */
                                     /*For 內部帳戶                           */
aqfud01     varchar2(255),           /*自订字段-Textedit                      */
aqfud02     varchar2(40),            /*自订字段-文字                          */
aqfud03     varchar2(40),            /*自订字段-文字                          */
aqfud04     varchar2(40),            /*自订字段-文字                          */
aqfud05     varchar2(40),            /*自订字段-文字                          */
aqfud06     varchar2(40),            /*自订字段-文字                          */
aqfud07     number(15,3),            /*自订字段-数值                          */
aqfud08     number(15,3),            /*自订字段-数值                          */
aqfud09     number(15,3),            /*自订字段-数值                          */
aqfud10     number(10),              /*自订字段-整数                          */
aqfud11     number(10),              /*自订字段-整数                          */
aqfud12     number(10),              /*自订字段-整数                          */
aqfud13     date,                    /*自订字段-日期                          */
aqfud14     date,                    /*自订字段-日期                          */
aqfud15     date,                    /*自订字段-日期                          */
aqflegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table aqf_file add  constraint aqf_pk primary key  (aqf01,aqf02) enable validate;
grant select on aqf_file to tiptopgp;
grant update on aqf_file to tiptopgp;
grant delete on aqf_file to tiptopgp;
grant insert on aqf_file to tiptopgp;
grant index on aqf_file to public;
grant select on aqf_file to ods;
