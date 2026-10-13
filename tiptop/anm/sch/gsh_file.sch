/*
================================================================================
檔案代號:gsh_file
檔案名稱:投资资料购买资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table gsh_file
(
gsh01       varchar2(20) NOT NULL,   /*购买编号                               */
gsh02       date,                    /*购买日期                               */
gsh03       varchar2(20),            /*投资单号                               */
gsh04       number(20,6),            /*购买单价(本币)                         */
gsh05       number(20,6),            /*购买数量                               */
gsh06       number(20,6),            /*购买金额(本币)                         */
gsh07       varchar2(30),            /*存款帐号                               */
gsh08       varchar2(4),             /*币种                                   */
gsh09       number(20,10),           /*汇率                                   */
gsh10       varchar2(2),             /*存提异动码                             */
gsh11       varchar2(4),             /*现金变动码                             */
gsh12       number(20,6),            /*购买金额(原币)                         */
gsh13       varchar2(6),             /*费用编号                               */
gsh14       varchar2(30),            /*费用出帐帐号                           */
gsh15       varchar2(4),             /*币种                                   */
gsh16       number(20,10),           /*汇率                                   */
gsh17       varchar2(2),             /*存提异动码                             */
gsh18       varchar2(4),             /*现金变动码                             */
gsh19       number(20,6),            /*费用金额(原币)                         */
gsh20       number(20,6),            /*费用金额(本币)                         */
gsh21       varchar2(20),            /*凭证号码                               */
gsh22       date,                    /*凭证日期                               */
gsh23       varchar2(1),             /*No Use                                 */
gsh24       varchar2(1),             /*No Use                                 */
gsh25       varchar2(1),             /*No Use                                 */
gshconf     varchar2(1),             /*确认码                                 */
gshacti     varchar2(1),             /*资料有效码                             */
gshuser     varchar2(10),            /*资料所有者                             */
gshgrup     varchar2(10),            /*资料所有部门                           */
gshmodu     varchar2(10),            /*资料更改者                             */
gshdate     date,                    /*最近更改日                             */
gsh26       varchar2(10),            /*所属部门                               */
gsh27       varchar2(20),            /*开票单号1                              */
gsh28       varchar2(20),            /*开票单号2                              */
gshud01     varchar2(255),           /*自订字段-Textedit                      */
gshud02     varchar2(40),            /*自订字段-文字                          */
gshud03     varchar2(40),            /*自订字段-文字                          */
gshud04     varchar2(40),            /*自订字段-文字                          */
gshud05     varchar2(40),            /*自订字段-文字                          */
gshud06     varchar2(40),            /*自订字段-文字                          */
gshud07     number(15,3),            /*自订字段-数值                          */
gshud08     number(15,3),            /*自订字段-数值                          */
gshud09     number(15,3),            /*自订字段-数值                          */
gshud10     number(10),              /*自订字段-整数                          */
gshud11     number(10),              /*自订字段-整数                          */
gshud12     number(10),              /*自订字段-整数                          */
gshud13     date,                    /*自订字段-日期                          */
gshud14     date,                    /*自订字段-日期                          */
gshud15     date,                    /*自订字段-日期                          */
gshlegal    varchar2(10) NOT NULL,   /*所属法人                               */
gshoriu     varchar2(10),            /*资料建立者                             */
gshorig     varchar2(10)             /*资料建立部门                           */
);

alter table gsh_file add  constraint gsh_pk primary key  (gsh01) enable validate;
grant select on gsh_file to tiptopgp;
grant update on gsh_file to tiptopgp;
grant delete on gsh_file to tiptopgp;
grant insert on gsh_file to tiptopgp;
grant index on gsh_file to public;
grant select on gsh_file to ods;
