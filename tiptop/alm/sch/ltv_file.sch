/*
================================================================================
檔案代號:ltv_file
檔案名稱:会员积分结算实际分配档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ltv_file
(
ltv01       number(5) DEFAULT '0' NOT NULL, /*年份*/
ltv02       number(5) DEFAULT '0' NOT NULL, /*月份*/
ltv03       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
ltv04       varchar2(1) DEFAULT ' ' NOT NULL, /*异动类型*/
ltv05       number(5) DEFAULT '0' NOT NULL, /*序号*/
ltv06       varchar2(10) DEFAULT ' ' NOT NULL,
ltv07       varchar2(10) DEFAULT ' ' NOT NULL, /*分配营运中心*/
ltv08       number(20) DEFAULT '0' NOT NULL /*分配异动积分*/
);

grant select on ltv_file to tiptopgp;
grant update on ltv_file to tiptopgp;
grant delete on ltv_file to tiptopgp;
grant insert on ltv_file to tiptopgp;
grant index on ltv_file to public;
grant select on ltv_file to ods;
