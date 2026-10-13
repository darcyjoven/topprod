/*
================================================================================
檔案代號:gin_file
檔案名稱:现金流量活动科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gin_file
(
gin00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
gin01       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
gin02       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
gin03       varchar2(1),             /*加减项 +.加项 / -.减项                 */
gin04       varchar2(1),             /*1.异动 2.期初 3.期末 4.人工录          */
gin05       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
gin06       varchar2(10) DEFAULT ' ' NOT NULL /*母公司编号*/
);

alter table gin_file add  constraint gin_pk primary key  (gin00,gin01,gin02) enable validate;
grant select on gin_file to tiptopgp;
grant update on gin_file to tiptopgp;
grant delete on gin_file to tiptopgp;
grant insert on gin_file to tiptopgp;
grant index on gin_file to public;
grant select on gin_file to ods;
