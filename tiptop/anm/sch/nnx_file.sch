/*
================================================================================
檔案代號:nnx_file
檔案名稱:资金调拨还本单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table nnx_file
(
nnx01       varchar2(20) NOT NULL,   /*还款单号                               */
nnx02       number(5) NOT NULL,      /*项次                                   */
nnx03       varchar2(20),            /*调拨单号                               */
nnx04       date,                    /*现金变动码                             */
nnx05       varchar2(4),             /*借款币种                               */
nnx06       number(20,10),           /*借款汇率                               */
nnx07       number(20,6),            /*借款原币金额                           */
nnx08       number(20,6),            /*借款本币金额                           */
nnx09       number(20,6),            /*已还原币金额                           */
nnx10       number(20,6),            /*已还本币金额                           */
nnx11       number(20,6),            /*实还原币金额                           */
nnx12       number(20,6),            /*实还本币金额                           */
nnx13       number(20,6),            /*汇差                                   */
nnx14       date,                    /*最后还息日                             */
nnx15       number(9,4),             /*还款利率(%)                            */
nnx16       date,                    /*利息起算日                             */
nnx17       date,                    /*利息止算日                             */
nnx18       number(20,6),            /*实还利息原币                           */
nnx19       number(20,6),            /*实还利息本币                           */
nnx20       varchar2(24),            /*原拨出对方科目                         */
nnx21       varchar2(24),            /*原拨入对方科目                         */
nnx201      varchar2(24),            /*原拨出对方科目二                       */
nnx211      varchar2(24),            /*原发入对方科目二                       */
nnxud01     varchar2(255),           /*自订字段-Textedit                      */
nnxud02     varchar2(40),            /*自订字段-文字                          */
nnxud03     varchar2(40),            /*自订字段-文字                          */
nnxud04     varchar2(40),            /*自订字段-文字                          */
nnxud05     varchar2(40),            /*自订字段-文字                          */
nnxud06     varchar2(40),            /*自订字段-文字                          */
nnxud07     number(15,3),            /*自订字段-数值                          */
nnxud08     number(15,3),            /*自订字段-数值                          */
nnxud09     number(15,3),            /*自订字段-数值                          */
nnxud10     number(10),              /*自订字段-整数                          */
nnxud11     number(10),              /*自订字段-整数                          */
nnxud12     number(10),              /*自订字段-整数                          */
nnxud13     date,                    /*自订字段-日期                          */
nnxud14     date,                    /*自订字段-日期                          */
nnxud15     date,                    /*自订字段-日期                          */
nnxlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table nnx_file add  constraint nnx_pk primary key  (nnx01,nnx02) enable validate;
grant select on nnx_file to tiptopgp;
grant update on nnx_file to tiptopgp;
grant delete on nnx_file to tiptopgp;
grant insert on nnx_file to tiptopgp;
grant index on nnx_file to public;
grant select on nnx_file to ods;
