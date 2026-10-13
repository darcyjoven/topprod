/*
================================================================================
檔案代號:axg_file
檔案名稱:合并前会计科目各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axg_file
(
axg00       varchar2(5) NOT NULL,    /*帐套编号                               */
axg01       varchar2(10) NOT NULL,   /*集团代号                               */
axg02       varchar2(10) NOT NULL,   /*母公司                                 */
axg03       varchar2(5) NOT NULL,    /*母公司账套                             */
axg04       varchar2(10) NOT NULL,   /*子公司                                 */
axg041      varchar2(5) NOT NULL,    /*子公司账套                             */
axg05       varchar2(24) NOT NULL,   /*科目编号                               */
axg06       number(5) NOT NULL,      /*会计年度                               */
axg07       number(5) NOT NULL,      /*期别                                   */
axg08       number(20,6) NOT NULL,   /*借方金额                               */
axg09       number(20,6) NOT NULL,   /*贷方金额                               */
axg10       number(10),              /*借方笔数                               */
axg11       number(10),              /*贷方笔数                               */
axg13       number(20,6),            /*子公司记帐币种借方                     */
axg14       number(20,6),            /*子公司记帐币种贷方                     */
axg15       number(20,6),            /*功能币种借方金额                       */
axg16       number(20,6),            /*功能币种贷方金额                       */
axg12       varchar2(4) NOT NULL,    /*币种                                   */
axg17       varchar2(10) NOT NULL,   /*版本                                   */
axg18       number(20,10),           /*功能币种汇率                           */
axg19       number(20,10),           /*合并币种汇率                           */
axglegal    varchar2(10) NOT NULL,   /*所属法人                               */
axg20       varchar2(10) DEFAULT ' ' NOT NULL, /*no use*/
axg21       varchar2(4),             /*no use                                 */
axg22       varchar2(4)              /*no use                                 */
);

alter table axg_file add  constraint axg_pk primary key  (axg01,axg02,axg03,axg04,axg041,axg05,axg06,axg07,axg00,axg12,axg17) enable validate;
grant select on axg_file to tiptopgp;
grant update on axg_file to tiptopgp;
grant delete on axg_file to tiptopgp;
grant insert on axg_file to tiptopgp;
grant index on axg_file to public;
grant select on axg_file to ods;
