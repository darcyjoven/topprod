/*
================================================================================
檔案代號:vlq_file
檔案名稱:　
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlq_file
(
vlq01       varchar2(10) DEFAULT ' ' NOT NULL, /*APS版本*/
vlq02       date DEFAULT sysdate NOT NULL, /*基本资料最后异动日*/
vlq03       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
vlq04       varchar2(40) DEFAULT ' ' NOT NULL, /*KEY值字段1*/
vlq05       varchar2(40) DEFAULT ' ' NOT NULL, /*KEY值字段2*/
vlqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vlqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vlq_file add  constraint vlq_pk primary key  (vlq01,vlq02,vlq03,vlq04,vlq05) enable validate;
grant select on vlq_file to tiptopgp;
grant update on vlq_file to tiptopgp;
grant delete on vlq_file to tiptopgp;
grant insert on vlq_file to tiptopgp;
grant index on vlq_file to public;
grant select on vlq_file to ods;
