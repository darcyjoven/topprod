/*
================================================================================
檔案代號:cdi_file
檔案名稱:科目维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:M
多語系檔案:N
============.========================.==========================================
*/
create table cdi_file
(
cdi01       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
cdi02       number(5) DEFAULT '0' NOT NULL, /*年度*/
cdi03       number(5) DEFAULT '0' NOT NULL, /*月份*/
cdi04       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cdi05       varchar2(24),            /*人工科目                               */
cdi06       varchar2(24),            /*制費一科目                             */
cdi07       varchar2(24),            /*加工科目                               */
cdi08       varchar2(24),            /*制費二科目                             */
cdi09       varchar2(24),            /*制費三科目                             */
cdi10       varchar2(24),            /*制費四科目                             */
cdi11       varchar2(24),            /*制費五科目                             */
cdi12b      number(20,6) DEFAULT '0' NOT NULL, /*人工金额*/
cdi12c      number(20,6) DEFAULT '0' NOT NULL, /*制費一金額*/
cdi12d      number(20,6) DEFAULT '0' NOT NULL, /*加工金额*/
cdi12e      number(20,6) DEFAULT '0' NOT NULL, /*制費二金額*/
cdi12f      number(20,6) DEFAULT '0' NOT NULL, /*制費三金額*/
cdi12g      number(20,6) DEFAULT '0' NOT NULL, /*制費四金額*/
cdi12h      number(20,6) DEFAULT '0' NOT NULL, /*制費五金額*/
cdilegal    varchar2(10),            /*所属法人                               */
cdi00       varchar2(1) DEFAULT '1' NOT NULL /*来源类型*/
);

create        index cdi_01 on cdi_file (cdi01,cdi02,cdi03,cdi04);
alter table cdi_file add  constraint cdi_pk primary key  (cdi00,cdi01,cdi02,cdi03,cdi04) enable validate;
grant select on cdi_file to tiptopgp;
grant update on cdi_file to tiptopgp;
grant delete on cdi_file to tiptopgp;
grant insert on cdi_file to tiptopgp;
grant index on cdi_file to public;
grant select on cdi_file to ods;
