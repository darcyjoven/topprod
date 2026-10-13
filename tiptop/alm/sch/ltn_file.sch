/*
================================================================================
檔案代號:ltn_file
檔案名稱:积分/折扣/储值加值规则生效营运中心变更档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltn_file
(
ltn01       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
ltn02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltn03       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类别*/
ltn04       varchar2(10) DEFAULT ' ' NOT NULL, /*生效门店编号*/
ltn05       varchar2(10),            /*更改人员                               */
ltn06       date,                    /*更改日期                               */
ltn07       varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
ltn08       number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltnlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltnplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table ltn_file add  constraint ltn_pk primary key  (ltn01,ltn02,ltn03,ltn04,ltn08,ltnplant) enable validate;
grant select on ltn_file to tiptopgp;
grant update on ltn_file to tiptopgp;
grant delete on ltn_file to tiptopgp;
grant insert on ltn_file to tiptopgp;
grant index on ltn_file to public;
grant select on ltn_file to ods;
