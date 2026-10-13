/*
================================================================================
檔案代號:axk_file
檔案名稱:合并前科目核算项冲账余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axk_file
(
axk00       varchar2(5) NOT NULL,    /*帐套                                   */
axk01       varchar2(10) NOT NULL,   /*集团代号                               */
axk02       varchar2(10) NOT NULL,   /*母公司                                 */
axk03       varchar2(5) NOT NULL,    /*母公司账套                             */
axk04       varchar2(10) NOT NULL,   /*子公司                                 */
axk041      varchar2(5) NOT NULL,    /*子公司账套                             */
axk05       varchar2(24) NOT NULL,   /*科目编号                               */
axk06       varchar2(2) NOT NULL,    /*核算项顺序                             */
axk07       varchar2(30) NOT NULL,   /*核算项值                               */
axk08       number(5) NOT NULL,      /*会计年度                               */
axk09       number(5) NOT NULL,      /*期别                                   */
axk10       number(20,6),            /*借方总金额                             */
axk11       number(20,6),            /*贷方总金额                             */
axk12       number(10),              /*借方总笔数                             */
axk13       number(10),              /*贷方总笔数                             */
axk14       varchar2(4) NOT NULL,    /*币种                                   */
axk15       varchar2(10) NOT NULL,   /*版本                                   */
axk16       number(20,10),           /*功能币种汇率                           */
axk17       number(20,10),           /*合并币种汇率                           */
axklegal    varchar2(10) NOT NULL,   /*所属法人                               */
axk18       number(20,6),            /*子公司记帐币种借方                     */
axk19       number(20,6),            /*子公司记账币种贷方                     */
axk20       number(20,6),            /*子公司功能币别借方金额                 */
axk21       number(20,6),            /*子公司功能币别贷方金额                 */
axk22       varchar2(10) DEFAULT ' ' NOT NULL, /*no use*/
axk23       varchar2(4),             /*no use                                 */
axk24       varchar2(4)              /*no use                                 */
);

alter table axk_file add  constraint axk_pk primary key  (axk01,axk02,axk03,axk04,axk041,axk05,axk07,axk08,axk09,axk00,axk06,axk14,axk15) enable validate;
grant select on axk_file to tiptopgp;
grant update on axk_file to tiptopgp;
grant delete on axk_file to tiptopgp;
grant insert on axk_file to tiptopgp;
grant index on axk_file to public;
grant select on axk_file to ods;
