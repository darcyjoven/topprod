/*
================================================================================
檔案代號:lid_file
檔案名稱:摊位申请单单身二档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lid_file
(
lid01       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位申请单*/
lid02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lid03       varchar2(10) DEFAULT ' ' NOT NULL, /*产品分类*/
lidacti     varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
lidlegal    varchar2(10),            /*所属法人                               */
lidplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lid_file add  constraint lid_pk primary key  (lid01,lid03) enable validate;
grant select on lid_file to tiptopgp;
grant update on lid_file to tiptopgp;
grant delete on lid_file to tiptopgp;
grant insert on lid_file to tiptopgp;
grant index on lid_file to public;
grant select on lid_file to ods;
