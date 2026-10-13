/*
================================================================================
檔案代號:afc_file
檔案名稱:会计科目预算单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afc_file
(
afc00       varchar2(5) NOT NULL,    /*帐套编号                               */
afc01       varchar2(10) NOT NULL,   /*预算项目                               */
afc02       varchar2(24) NOT NULL,   /*科目编号                               */
afc03       number(5) NOT NULL,      /*会计年度                               */
afc04       varchar2(30) NOT NULL,   /*WBS编码                                */
afc05       number(5) NOT NULL,      /*期别                                   */
afc06       number(20,6),            /*各期预算                               */
afc07       number(20,6),            /*巳消耗预算                             */
afc041      varchar2(10) DEFAULT ' ' NOT NULL, /*部门编码*/
afc042      varchar2(10) DEFAULT ' ' NOT NULL, /*项目编号*/
afc08       number(20,6),            /*挪用金额                               */
afc09       number(20,6)             /*追加金额                               */
);

alter table afc_file add  constraint afc_pk primary key  (afc00,afc01,afc02,afc03,afc04,afc041,afc042,afc05) enable validate;
grant select on afc_file to tiptopgp;
grant update on afc_file to tiptopgp;
grant delete on afc_file to tiptopgp;
grant insert on afc_file to tiptopgp;
grant index on afc_file to public;
grant select on afc_file to ods;
