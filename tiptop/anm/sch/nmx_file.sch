/*
================================================================================
檔案代號:nmx_file
檔案名稱:ach payment code单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nmx_file
(
nmx01       varchar2(10) DEFAULT ' ' NOT NULL, /*网络银行接口银行编码*/
nmx02       varchar2(10) DEFAULT ' ' NOT NULL, /*TIPTOP登录帐号*/
nmx03       varchar2(30) DEFAULT ' ' NOT NULL, /*收款编号*/
nmx04       varchar2(80),            /*收款编号说明                           */
nmx05       varchar2(1) DEFAULT 'n' NOT NULL, /*是否已使用*/
nmx06       number(5) DEFAULT '0' NOT NULL /*项次*/
);

alter table nmx_file add  constraint nmx_pk primary key  (nmx01,nmx02,nmx03) enable validate;
grant select on nmx_file to tiptopgp;
grant update on nmx_file to tiptopgp;
grant delete on nmx_file to tiptopgp;
grant insert on nmx_file to tiptopgp;
grant index on nmx_file to public;
grant select on nmx_file to ods;
