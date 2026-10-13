/*
================================================================================
檔案代號:lrr_file
檔案名稱:排除明細檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrr_file
(
lrr00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
lrr01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lrr02       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
lrracti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrr03       date DEFAULT sysdate NOT NULL, /*生效日期*/
lrr04       date DEFAULT sysdate NOT NULL, /*失效日期*/
lrr05       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lrr06       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lrrlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lrrplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lrr_file add  constraint lrr_pk primary key  (lrr05,lrr06,lrr02,lrrplant) enable validate;
grant select on lrr_file to tiptopgp;
grant update on lrr_file to tiptopgp;
grant delete on lrr_file to tiptopgp;
grant insert on lrr_file to tiptopgp;
grant index on lrr_file to public;
grant select on lrr_file to ods;
