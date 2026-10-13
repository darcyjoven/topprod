/*
================================================================================
檔案代號:atk_file
檔案名稱:现金流量活动科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atk_file
(
atk00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
atk01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
atk02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
atk03       varchar2(1) DEFAULT ' ' NOT NULL, /*加减项 +.加项 2.减项*/
atk04       varchar2(1) DEFAULT ' ' NOT NULL, /*1.异动 2.期初 3.期末 4.人工录  */
atk05       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
atk06       varchar2(10) DEFAULT ' ' NOT NULL /*上层公司编号*/
);

alter table atk_file add  constraint atk_pk primary key  (atk00,atk01,atk02) enable validate;
grant select on atk_file to tiptopgp;
grant update on atk_file to tiptopgp;
grant delete on atk_file to tiptopgp;
grant insert on atk_file to tiptopgp;
grant index on atk_file to public;
grant select on atk_file to ods;
