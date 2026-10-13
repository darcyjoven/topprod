/*
================================================================================
檔案代號:lrq_file
檔案名稱:積分/折扣規則單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrq_file
(
lrq00       varchar2(1) DEFAULT ' ' NOT NULL, /*规则类型*/
lrq01       varchar2(20) DEFAULT ' ' NOT NULL, /*卡种编号*/
lrq02       varchar2(40) DEFAULT ' ' NOT NULL, /*代码*/
lrq03       number(20) DEFAULT '0' NOT NULL, /*积分基准*/
lrq04       number(20) DEFAULT '0' NOT NULL, /*单位积分*/
lrq05       number(6,2) DEFAULT '0' NOT NULL, /*折扣率*/
lrq06       number(20,6) DEFAULT '0' NOT NULL, /*充值基准*/
lrq07       number(20,6) DEFAULT '0' NOT NULL, /*优惠加值*/
lrq08       number(20,6) DEFAULT '0' NOT NULL, /*优惠加值%*/
lrq09       varchar2(1) DEFAULT ' ' NOT NULL, /*整倍否*/
lrq10       date DEFAULT sysdate NOT NULL, /*生效日期*/
lrq11       date DEFAULT sysdate NOT NULL, /*失效日期*/
lrqacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lrq12       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lrq13       varchar2(20) DEFAULT ' ' NOT NULL, /*规则单号*/
lrqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lrqplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

alter table lrq_file add  constraint lrq_pk primary key  (lrq02,lrq06,lrq12,lrq13,lrqplant) enable validate;
grant select on lrq_file to tiptopgp;
grant update on lrq_file to tiptopgp;
grant delete on lrq_file to tiptopgp;
grant insert on lrq_file to tiptopgp;
grant index on lrq_file to public;
grant select on lrq_file to ods;
