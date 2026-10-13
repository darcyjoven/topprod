/*
================================================================================
檔案代號:giw_file
檔案名稱:现金流量活动科目档(总账)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giw_file
(
giw00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
giw01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
giw02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
giw03       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项  +.加项  -.减项*/
giw04       varchar2(1) DEFAULT ' ' NOT NULL /*1.异动 2.期初 3.期末 4.人工录  */
);

alter table giw_file add  constraint giw_pk primary key  (giw00,giw01,giw02) enable validate;
grant select on giw_file to tiptopgp;
grant update on giw_file to tiptopgp;
grant delete on giw_file to tiptopgp;
grant insert on giw_file to tiptopgp;
grant index on giw_file to public;
grant select on giw_file to ods;
