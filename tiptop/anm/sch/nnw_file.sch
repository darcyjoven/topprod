/*
================================================================================
檔案代號:nnw_file
檔案名稱:资金调拨还本单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnw_file
(
nnw00       varchar2(1),             /*1.还本 2.还息                          */
nnw01       varchar2(20) NOT NULL,   /*还款单号                               */
nnw02       date,                    /*调拨日期                               */
nnw03       varchar2(10),            /*部门编号                               */
nnw04       varchar2(4),             /*现金变动码                             */
nnw05       varchar2(10),            /*还款营运中心                           */
nnw06       varchar2(20),            /*拨出银行                               */
nnw07       varchar2(2),             /*拨出异动码                             */
nnw08       varchar2(4),             /*拨出币种                               */
nnw09       number(20,10),           /*拨出汇率                               */
nnw10       number(20,6),            /*拨出原币                               */
nnw11       number(20,6),            /*拨出本币                               */
nnw12       varchar2(24),            /*拨出科目/还息科目                      */
nnw13       varchar2(20),            /*手续费银行                             */
nnw14       varchar2(2),             /*手续费异动码                           */
nnw15       varchar2(4),             /*手续费币种                             */
nnw16       number(20,10),           /*手续费汇率                             */
nnw17       number(20,6),            /*手续费原币                             */
nnw18       number(20,6),            /*手续费本币                             */
nnw19       varchar2(24),            /*手续费科目                             */
nnw20       varchar2(10),            /*拨入营运中心                           */
nnw21       varchar2(20),            /*拨入银行                               */
nnw22       varchar2(2),             /*拨入异动码                             */
nnw23       varchar2(4),             /*拨入币种                               */
nnw24       number(20,10),           /*拨入汇率                               */
nnw25       number(20,6),            /*拨入原币                               */
nnw26       number(20,6),            /*拨入本币                               */
nnw27       varchar2(24),            /*拨入科目                               */
nnw28       varchar2(20),            /*拨出凭证号码                           */
nnw29       varchar2(20),            /*拨入凭证号码                           */
nnw30       varchar2(1),             /*No Use                                 */
nnwconf     varchar2(1),             /*确认码                                 */
nnwacti     varchar2(1),             /*资料有效码                             */
nnwuser     varchar2(10),            /*资料所有者                             */
nnwgrup     varchar2(10),            /*资料所有群                             */
nnwmodu     varchar2(10),            /*资料更改者                             */
nnwdate     date,                    /*最近更改日                             */
nnw121      varchar2(24),            /*拨出科目二/还息科目二                  */
nnw191      varchar2(24),            /*手续费科目二                           */
nnw271      varchar2(24),            /*拨入科目二                             */
nnw31       varchar2(20),            /*拨出方内部帐户                         */
                                     /*For 內部帳戶                           */
nnw32       varchar2(20),            /*拨入方内部帐户                         */
                                     /*For 內部帳戶                           */
nnwud01     varchar2(255),           /*自订字段-Textedit                      */
nnwud02     varchar2(40),            /*自订字段-文字                          */
nnwud03     varchar2(40),            /*自订字段-文字                          */
nnwud04     varchar2(40),            /*自订字段-文字                          */
nnwud05     varchar2(40),            /*自订字段-文字                          */
nnwud06     varchar2(40),            /*自订字段-文字                          */
nnwud07     number(15,3),            /*自订字段-数值                          */
nnwud08     number(15,3),            /*自订字段-数值                          */
nnwud09     number(15,3),            /*自订字段-数值                          */
nnwud10     number(10),              /*自订字段-整数                          */
nnwud11     number(10),              /*自订字段-整数                          */
nnwud12     number(10),              /*自订字段-整数                          */
nnwud13     date,                    /*自订字段-日期                          */
nnwud14     date,                    /*自订字段-日期                          */
nnwud15     date,                    /*自订字段-日期                          */
nnwlegal    varchar2(10) NOT NULL,   /*所属法人                               */
nnworiu     varchar2(10),            /*资料建立者                             */
nnworig     varchar2(10)             /*资料建立部门                           */
);

alter table nnw_file add  constraint nnw_pk primary key  (nnw01) enable validate;
grant select on nnw_file to tiptopgp;
grant update on nnw_file to tiptopgp;
grant delete on nnw_file to tiptopgp;
grant insert on nnw_file to tiptopgp;
grant index on nnw_file to public;
grant select on nnw_file to ods;
