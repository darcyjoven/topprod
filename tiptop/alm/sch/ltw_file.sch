/*
================================================================================
檔案代號:ltw_file
檔案名稱:会员积分结算余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltw_file
(
ltw01       number(5) DEFAULT '0' NOT NULL, /*年份*/
ltw02       number(5) DEFAULT '0' NOT NULL, /*月份*/
ltw03       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
ltw04       varchar2(10) DEFAULT ' ' NOT NULL, /*分配营运中心*/
ltw05       number(20) DEFAULT '0' NOT NULL /*期末积分*/
);

grant select on ltw_file to tiptopgp;
grant update on ltw_file to tiptopgp;
grant delete on ltw_file to tiptopgp;
grant insert on ltw_file to tiptopgp;
grant index on ltw_file to public;
grant select on ltw_file to ods;
