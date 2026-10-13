/*
================================================================================
檔案代號:ltr_file
檔案名稱:设置收券规则单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltr_file
(
ltr01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
ltr02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltr03       varchar2(40) DEFAULT ' ' NOT NULL, /*编号*/
ltracti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效码*/
ltrlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ltrplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltr_file add  constraint ltr_pk primary key  (ltr01,ltr02,ltr03,ltrplant) enable validate;
grant select on ltr_file to tiptopgp;
grant update on ltr_file to tiptopgp;
grant delete on ltr_file to tiptopgp;
grant insert on ltr_file to tiptopgp;
grant index on ltr_file to public;
grant select on ltr_file to ods;
