/*
================================================================================
檔案代號:lqf_file
檔案名稱:促銷主題資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqf_file
(
lqf01       varchar2(10) DEFAULT ' ' NOT NULL, /*促销主题编号*/
lqf02       varchar2(30),            /*促销主题名称                           */
lqf03       varchar2(50),            /*促销主题描述                           */
lqf04       varchar2(1) DEFAULT ' ' NOT NULL /*有效否*/
);

alter table lqf_file add  constraint lqf_pk primary key  (lqf01) enable validate;
grant select on lqf_file to tiptopgp;
grant update on lqf_file to tiptopgp;
grant delete on lqf_file to tiptopgp;
grant insert on lqf_file to tiptopgp;
grant index on lqf_file to public;
grant select on lqf_file to ods;
