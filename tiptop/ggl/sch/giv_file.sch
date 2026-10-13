/*
================================================================================
檔案代號:giv_file
檔案名稱:现金流量活动科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table giv_file
(
giv00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
giv01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
giv02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
giv03       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项 +.加项 / -.减项*/
giv04       varchar2(1) DEFAULT ' ' NOT NULL /*1.异动2.期初 3.期末 4.人工输入*/
);

create unique index giv_01 on giv_file (giv00,giv01,giv02);
alter table giv_file add  constraint giv_pk primary key  (giv00,giv01,giv02) enable validate;
grant select on giv_file to tiptopgp;
grant update on giv_file to tiptopgp;
grant delete on giv_file to tiptopgp;
grant insert on giv_file to tiptopgp;
grant index on giv_file to public;
grant select on giv_file to ods;
