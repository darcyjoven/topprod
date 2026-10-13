/*
================================================================================
檔案代號:lqp_file
檔案名稱:会员销售资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table lqp_file
(
lqp01       varchar2(30) DEFAULT ' ' NOT NULL, /*会员卡号*/
lqp02       date DEFAULT sysdate NOT NULL, /*销售日期*/
lqp03       number(20) DEFAULT '0' NOT NULL, /*消费次数*/
lqp04       number(20) DEFAULT '0' NOT NULL, /*消费积分*/
lqp05       number(20,6) DEFAULT '0' NOT NULL, /*消费金额*/
lqplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lqpplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table lqp_file add  constraint lqp_pk primary key  (lqp01,lqp02,lqpplant) enable validate;
grant select on lqp_file to tiptopgp;
grant update on lqp_file to tiptopgp;
grant delete on lqp_file to tiptopgp;
grant insert on lqp_file to tiptopgp;
grant index on lqp_file to public;
grant select on lqp_file to ods;
