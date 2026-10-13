/*
================================================================================
檔案代號:gse_file
檔案名稱:票券外汇平仓资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gse_file
(
gse01       varchar2(20) NOT NULL,   /*平仓编号                               */
gse02       date,                    /*平仓日期                               */
gse03       varchar2(20),            /*投资单号                               */
gse04       number(20,6),            /*平仓单价(本币)                         */
gse05       number(15,3),            /*平仓数量                               */
gse06       number(20,6),            /*平仓金额(本币)                         */
gse07       varchar2(30),            /*存款帐号                               */
gse08       varchar2(4),             /*币种                                   */
gse09       number(20,10),           /*汇率                                   */
gse10       varchar2(2),             /*存提异动码                             */
gse11       varchar2(4),             /*现金变动码                             */
gse12       number(20,6),            /*平仓金额(原币)                         */
gse13       varchar2(6),             /*费用编号                               */
gse14       varchar2(30),            /*费用出帐帐号                           */
gse15       varchar2(4),             /*币种                                   */
gse16       number(20,10),           /*汇率                                   */
gse17       varchar2(2),             /*存提异动码                             */
gse18       varchar2(4),             /*现金变动码                             */
gse19       number(20,6),            /*费用金额(原币)                         */
gse20       number(20,6),            /*费用金额(本币)                         */
gse21       varchar2(20),            /*凭证号码                               */
gse22       date,                    /*凭证日期                               */
gse23       number(20,6),            /*平仓售价(本币)                         */
gse24       number(20,6),            /*投资毛利(本币)                         */
gse25       number(20,6),            /*损益金额(本币)                         */
gse26       number(20,6),            /*平仓销售单价(本币)                     */
gseconf     varchar2(1),             /*确认码                                 */
gseacti     varchar2(1),             /*资料有效码                             */
gseuser     varchar2(10),            /*资料所有者                             */
gsegrup     varchar2(10),            /*资料所有部门                           */
gsemodu     varchar2(10),            /*资料更改者                             */
gsedate     date,                    /*最近更改日                             */
gse27       varchar2(10),            /*所属部门                               */
gseud01     varchar2(255),           /*自订字段-Textedit                      */
gseud02     varchar2(40),            /*自订字段-文字                          */
gseud03     varchar2(40),            /*自订字段-文字                          */
gseud04     varchar2(40),            /*自订字段-文字                          */
gseud05     varchar2(40),            /*自订字段-文字                          */
gseud06     varchar2(40),            /*自订字段-文字                          */
gseud07     number(15,3),            /*自订字段-数值                          */
gseud08     number(15,3),            /*自订字段-数值                          */
gseud09     number(15,3),            /*自订字段-数值                          */
gseud10     number(10),              /*自订字段-整数                          */
gseud11     number(10),              /*自订字段-整数                          */
gseud12     number(10),              /*自订字段-整数                          */
gseud13     date,                    /*自订字段-日期                          */
gseud14     date,                    /*自订字段-日期                          */
gseud15     date,                    /*自订字段-日期                          */
gselegal    varchar2(10) NOT NULL,   /*所属法人                               */
gseoriu     varchar2(10),            /*资料建立者                             */
gseorig     varchar2(10)             /*资料建立部门                           */
);

alter table gse_file add  constraint gse_pk primary key  (gse01) enable validate;
grant select on gse_file to tiptopgp;
grant update on gse_file to tiptopgp;
grant delete on gse_file to tiptopgp;
grant insert on gse_file to tiptopgp;
grant index on gse_file to public;
grant select on gse_file to ods;
