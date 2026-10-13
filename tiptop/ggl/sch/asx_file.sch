/*
================================================================================
檔案代號:asx_file
檔案名稱:合并报表关系人递延项摊销资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table asx_file
(
asx01       number(5) DEFAULT '0' NOT NULL, /*年度*/
asx02       number(5) DEFAULT '0' NOT NULL, /*期别*/
asx03       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asx031      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司*/
asx04       number(5) DEFAULT '0' NOT NULL, /*项次*/
asx05       varchar2(1) DEFAULT ' ' NOT NULL, /*交易性质*/
asx06       varchar2(1) DEFAULT ' ' NOT NULL, /*交易类型*/
asx07       varchar2(10),            /*来源公司                               */
asx08       varchar2(10),            /*交易公司                               */
asx09       varchar2(24),            /*no use                                 */
asx10       varchar2(24),            /*no use                                 */
asx11       varchar2(4) DEFAULT ' ' NOT NULL, /*来源币种*/
asx12       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
asx13       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
asx14       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
asx15       number(15,3) DEFAULT '0' NOT NULL, /*no use*/
asx16       number(20,6) DEFAULT '0' NOT NULL, /*分配未实现利益*/
asx17       number(5) DEFAULT '0' NOT NULL, /*摊销总期数*/
asx18       number(5) DEFAULT '0' NOT NULL, /*已摊销期数*/
asx19       number(20,6) DEFAULT '0' NOT NULL, /*已摊销金额*/
asx20       varchar2(1) DEFAULT ' ' NOT NULL, /*结案否*/
asx21       varchar2(24),            /*费用科目                               */
asxlegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

create unique index asx_01 on asx_file (asx01,asx02,asx03,asx031,asx04,asx11);
alter table asx_file add  constraint asx_pk primary key  (asx01,asx02,asx03,asx031,asx04,asx11) enable validate;
grant select on asx_file to tiptopgp;
grant update on asx_file to tiptopgp;
grant delete on asx_file to tiptopgp;
grant insert on asx_file to tiptopgp;
grant index on asx_file to public;
grant select on asx_file to ods;
