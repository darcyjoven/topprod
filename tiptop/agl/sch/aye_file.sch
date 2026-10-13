/*
================================================================================
檔案代號:aye_file
檔案名稱:合并股东权益各期余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table aye_file
(
aye00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套编号*/
aye01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aye02       varchar2(10) DEFAULT ' ' NOT NULL, /*母公司编号*/
aye03       number(5) DEFAULT '0' NOT NULL, /*年度*/
aye04       number(5) DEFAULT '0' NOT NULL, /*期别*/
aye05       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aye06       varchar2(10) DEFAULT ' ' NOT NULL, /*分类代码*/
aye07       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
aye08       number(20,6) DEFAULT '0' NOT NULL, /*异动金额*/
ayelegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
ayeorig     varchar2(10),            /*资料建立部门                           */
ayeoriu     varchar2(10)             /*资料建立者                             */
);

alter table aye_file add  constraint aye_pk primary key  (aye00,aye01,aye02,aye03,aye04,aye05,aye06,aye07) enable validate;
grant select on aye_file to tiptopgp;
grant update on aye_file to tiptopgp;
grant delete on aye_file to tiptopgp;
grant insert on aye_file to tiptopgp;
grant index on aye_file to public;
grant select on aye_file to ods;
