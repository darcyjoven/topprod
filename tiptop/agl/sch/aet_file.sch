/*
================================================================================
檔案代號:aet_file
檔案名稱:合并直接法调整
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aet_file
(
aet01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aet02       number(5) DEFAULT '0' NOT NULL, /*年度*/
aet03       number(5) DEFAULT '0' NOT NULL, /*期别*/
aet04       varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
aet05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
aet06       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
aet07       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
aet08       varchar2(30) DEFAULT ' ' NOT NULL, /*关系人核算项*/
aet09       varchar2(80),            /*摘要                                   */
aetlegal    varchar2(10)             /*所属法人                               */
);

alter table aet_file add  constraint aet_pk primary key  (aet01,aet02,aet03,aet04,aet05,aet06,aet08) enable validate;
grant select on aet_file to tiptopgp;
grant update on aet_file to tiptopgp;
grant delete on aet_file to tiptopgp;
grant insert on aet_file to tiptopgp;
grant index on aet_file to public;
grant select on aet_file to ods;
