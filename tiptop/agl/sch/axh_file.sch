/*
================================================================================
檔案代號:axh_file
檔案名稱:合并后会计科目各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axh_file
(
axh00       varchar2(5) NOT NULL,    /*账套编号                               */
axh01       varchar2(10) NOT NULL,   /*集团代号                               */
axh02       varchar2(10) NOT NULL,   /*母公司                                 */
axh03       varchar2(5) NOT NULL,    /*母公司账套                             */
axh04       varchar2(10) NOT NULL,   /*子公司编号                             */
axh041      varchar2(5) NOT NULL,    /*子公司账套                             */
axh05       varchar2(24) NOT NULL,   /*科目编号                               */
axh06       number(5) NOT NULL,      /*会计年度                               */
axh07       number(5) NOT NULL,      /*期别                                   */
axh08       number(20,6) NOT NULL,   /*借方金额                               */
axh09       number(20,6) NOT NULL,   /*贷方金额                               */
axh10       number(10),              /*借方笔数                               */
axh11       number(10),              /*贷方笔数                               */
axh12       varchar2(4) NOT NULL,    /*币种                                   */
axh13       varchar2(10) NOT NULL,   /*版本                                   */
axhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
axh14       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axh15       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axh16       varchar2(4),             /*no use                                 */
axh17       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axh18       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
axh19       varchar2(4),             /*no use                                 */
axh20       varchar2(10) DEFAULT ' ' NOT NULL /*no use*/
);

alter table axh_file add  constraint axh_pk primary key  (axh01,axh02,axh03,axh04,axh041,axh05,axh06,axh07,axh00,axh12,axh13) enable validate;
grant select on axh_file to tiptopgp;
grant update on axh_file to tiptopgp;
grant delete on axh_file to tiptopgp;
grant insert on axh_file to tiptopgp;
grant index on axh_file to public;
grant select on axh_file to ods;
