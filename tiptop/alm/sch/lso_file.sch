/*
================================================================================
檔案代號:lso_file
檔案名稱:生效营运中心
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lso_file
(
lso01       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lso02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lso03       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类别*/
lso04       varchar2(10) DEFAULT ' ' NOT NULL, /*生效门店编号*/
lso05       varchar2(10),            /*更改人员                               */
lso06       date,                    /*更改日期                               */
lso07       varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
lsolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lsoplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lso_file add  constraint lso_pk primary key  (lso01,lso02,lso04,lsoplant) enable validate;
grant select on lso_file to tiptopgp;
grant update on lso_file to tiptopgp;
grant delete on lso_file to tiptopgp;
grant insert on lso_file to tiptopgp;
grant index on lso_file to public;
grant select on lso_file to ods;
