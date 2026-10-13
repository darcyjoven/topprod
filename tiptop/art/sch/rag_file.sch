/*
================================================================================
檔案代號:rag_file
檔案名稱:组合促销第二单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rag_file
(
rag01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rag02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rag03       number(5) DEFAULT '0' NOT NULL, /*组别*/
rag04       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
rag05       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
rag06       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
ragacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
raglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
ragplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table rag_file add  constraint rag_pk primary key  (rag01,rag02,rag03,rag04,rag05,rag06,ragplant) enable validate;
grant select on rag_file to tiptopgp;
grant update on rag_file to tiptopgp;
grant delete on rag_file to tiptopgp;
grant insert on rag_file to tiptopgp;
grant index on rag_file to public;
grant select on rag_file to ods;
