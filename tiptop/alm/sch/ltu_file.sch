/*
================================================================================
檔案代號:ltu_file
檔案名稱:收券规则变更单身档二
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltu_file
(
ltu01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
ltu02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltu021      number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltu03       varchar2(40) DEFAULT ' ' NOT NULL, /*编号*/
ltuacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ltulegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltuplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltu_file add  constraint ltu_pk primary key  (ltu01,ltu02,ltu021,ltu03,ltuplant) enable validate;
grant select on ltu_file to tiptopgp;
grant update on ltu_file to tiptopgp;
grant delete on ltu_file to tiptopgp;
grant insert on ltu_file to tiptopgp;
grant index on ltu_file to public;
grant select on ltu_file to ods;
