/*
================================================================================
檔案代號:rar_file
檔案名稱:换赠第一单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rar_file
(
rar01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rar02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rar03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型 2:组合促销 3:满额促 */
rar04       number(5) DEFAULT '0' NOT NULL, /*项次*/
rar05       number(5) DEFAULT '0' NOT NULL, /*组别*/
rar06       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
rar07       number(20,6) DEFAULT '0' NOT NULL, /*加价金额*/
rar08       number(20,6) DEFAULT '0' NOT NULL, /*会员加价金额*/
raracti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rarlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rarplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rar_file add  constraint rar_pk primary key  (rar01,rar02,rar03,rar04,rar05,rarplant) enable validate;
grant select on rar_file to tiptopgp;
grant update on rar_file to tiptopgp;
grant delete on rar_file to tiptopgp;
grant insert on rar_file to tiptopgp;
grant index on rar_file to public;
grant select on rar_file to ods;
