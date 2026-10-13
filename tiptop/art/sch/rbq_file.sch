/*
================================================================================
檔案代號:rbq_file
檔案名稱:变更生效机构档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbq_file
(
rbq01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbq02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbq03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbq04       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型*/
rbq05       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbq06       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbq07       varchar2(10) DEFAULT ' ' NOT NULL, /*生效营运中心*/
rbq08       varchar2(1) DEFAULT ' ' NOT NULL, /*发布否*/
rbqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效否*/
rbqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbqplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rbq09       varchar2(20) DEFAULT ' ' NOT NULL /*摊位编号*/
);

alter table rbq_file add  constraint rbq_pk primary key  (rbq01,rbq02,rbq03,rbq04,rbq05,rbq06,rbq07,rbq09,rbqplant) enable validate;
grant select on rbq_file to tiptopgp;
grant update on rbq_file to tiptopgp;
grant delete on rbq_file to tiptopgp;
grant insert on rbq_file to tiptopgp;
grant index on rbq_file to public;
grant select on rbq_file to ods;
