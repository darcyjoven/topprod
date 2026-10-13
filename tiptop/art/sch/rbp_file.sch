/*
================================================================================
檔案代號:rbp_file
檔案名稱:变更会员等级资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbp_file
(
rbp01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbp02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbp03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbp04       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型:1.一般促销,2.组合促 */
rbp05       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbp06       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbp07       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbp08       varchar2(10) DEFAULT ' ' NOT NULL, /*会员等级*/
rbp09       number(20,6) DEFAULT '0' NOT NULL, /*特卖价*/
rbp10       number(5,2),             /*折扣率%                                */
rbp11       number(20,6) DEFAULT '0' NOT NULL, /*折让价*/
rbpacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效否*/
rbplegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbpplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编号*/
rbp12       varchar2(1) DEFAULT ' ' NOT NULL
);

alter table rbp_file add  constraint rbp_pk primary key  (rbp01,rbp02,rbp03,rbp04,rbp05,rbp06,rbp07,rbp12,rbp08,rbpplant) enable validate;
grant select on rbp_file to tiptopgp;
grant update on rbp_file to tiptopgp;
grant delete on rbp_file to tiptopgp;
grant insert on rbp_file to tiptopgp;
grant index on rbp_file to public;
grant select on rbp_file to ods;
