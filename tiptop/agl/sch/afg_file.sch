/*
================================================================================
檔案代號:afg_file
檔案名稱:核算项预算资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table afg_file
(
afg00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
afg01       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
afg02       varchar2(10) DEFAULT ' ' NOT NULL, /*预算项目*/
afg03       varchar2(24) DEFAULT ' ' NOT NULL, /*会计科目*/
afg04       varchar2(10) NOT NULL,   /*部门编号                               */
afg05       varchar2(1) DEFAULT ' ' NOT NULL, /*核算项别*/
afg06       varchar2(30) DEFAULT ' ' NOT NULL, /*核算项值*/
afg07       number(5) DEFAULT '0' NOT NULL, /*期别*/
afg08       number(20,6)             /*预算金额                               */
);

alter table afg_file add  constraint afg_pk primary key  (afg00,afg01,afg02,afg03,afg04,afg05,afg06,afg07) enable validate;
grant select on afg_file to tiptopgp;
grant update on afg_file to tiptopgp;
grant delete on afg_file to tiptopgp;
grant insert on afg_file to tiptopgp;
grant index on afg_file to public;
grant select on afg_file to ods;
