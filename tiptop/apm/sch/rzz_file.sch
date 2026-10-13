/*
================================================================================
檔案代號:rzz_file
檔案名稱:价格类型选项档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rzz_file
(
rzz00       varchar2(1) DEFAULT ' ' NOT NULL, /*价格类型1.采购价格2.销售价格*/
rzz01       varchar2(10) DEFAULT ' ' NOT NULL, /*价格代码*/
rzz02       varchar2(40),            /*名称                                   */
rzz03       varchar2(1) DEFAULT ' ' NOT NULL /*类型A基础价格B优惠C促销*/
);

alter table rzz_file add  constraint rzz_pk primary key  (rzz00,rzz01) enable validate;
grant select on rzz_file to tiptopgp;
grant update on rzz_file to tiptopgp;
grant delete on rzz_file to tiptopgp;
grant insert on rzz_file to tiptopgp;
grant index on rzz_file to public;
grant select on rzz_file to ods;
