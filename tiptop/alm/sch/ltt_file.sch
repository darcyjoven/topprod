/*
================================================================================
檔案代號:ltt_file
檔案名稱:收券规则变更单身档一
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ltt_file
(
ltt01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
ltt02       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
ltt021      number(5) DEFAULT '0' NOT NULL, /*版本号*/
ltt03       varchar2(40) DEFAULT ' ' NOT NULL, /*编号*/
lttacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lttlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lttplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table ltt_file add  constraint ltt_pk primary key  (ltt01,ltt02,ltt021,ltt03,lttplant) enable validate;
grant select on ltt_file to tiptopgp;
grant update on ltt_file to tiptopgp;
grant delete on ltt_file to tiptopgp;
grant insert on ltt_file to tiptopgp;
grant index on ltt_file to public;
grant select on ltt_file to ods;
