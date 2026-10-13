/*
================================================================================
檔案代號:sfaa_file
檔案名稱:备料多仓/储/批档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfaa_file
(
sfaa01      varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sfaa012     varchar2(10) DEFAULT ' ' NOT NULL,
sfaa013     number(5) DEFAULT '0' NOT NULL,
sfaa03      varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
sfaa05      number(15,3) DEFAULT '0' NOT NULL, /*应发数量*/
sfaa051     number(15,3) DEFAULT '0' NOT NULL, /*die数*/
sfaa08      varchar2(6) DEFAULT ' ' NOT NULL, /*作业编号*/
sfaa12      varchar2(4) DEFAULT ' ' NOT NULL, /*发料单位*/
sfaa27      varchar2(40) DEFAULT ' ' NOT NULL, /*被替代料号*/
sfaa30      varchar2(10) DEFAULT ' ' NOT NULL, /*指定仓库*/
sfaa31      varchar2(10) DEFAULT ' ' NOT NULL, /*指定库位*/
sfaa32      varchar2(24) DEFAULT ' ' NOT NULL, /*发料批号*/
sfaalegal   varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
sfaaplant   varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table sfaa_file add  constraint sfaa_pk primary key  (sfaa01,sfaa03,sfaa08,sfaa12,sfaa27,sfaa012,sfaa013,sfaa30,sfaa31,sfaa32) enable validate;
grant select on sfaa_file to tiptopgp;
grant update on sfaa_file to tiptopgp;
grant delete on sfaa_file to tiptopgp;
grant insert on sfaa_file to tiptopgp;
grant index on sfaa_file to public;
grant select on sfaa_file to ods;
