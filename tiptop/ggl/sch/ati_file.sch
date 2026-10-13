/*
================================================================================
檔案代號:ati_file
檔案名稱:合并直接法调整
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ati_file
(
ati01       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
ati02       number(5) DEFAULT '0' NOT NULL, /*年度*/
ati03       number(5) DEFAULT '0' NOT NULL, /*期别*/
ati04       varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
ati05       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
ati06       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项*/
ati07       number(20,6) DEFAULT '0' NOT NULL, /*金额*/
ati08       varchar2(30) DEFAULT ' ' NOT NULL, /*关系人异动码*/
ati09       varchar2(80),            /*摘要                                   */
atilegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table ati_file add  constraint ati_pk primary key  (ati01,ati02,ati03,ati04,ati05,ati06,ati08) enable validate;
grant select on ati_file to tiptopgp;
grant update on ati_file to tiptopgp;
grant delete on ati_file to tiptopgp;
grant insert on ati_file to tiptopgp;
grant index on ati_file to public;
grant select on ati_file to ods;
