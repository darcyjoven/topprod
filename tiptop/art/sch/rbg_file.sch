/*
================================================================================
檔案代號:rbg_file
檔案名稱:组合促销变更单身档(二)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rbg_file
(
rbg01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定机构*/
rbg02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rbg03       number(5) DEFAULT '0' NOT NULL, /*变动序号*/
rbg04       number(5) DEFAULT '0' NOT NULL, /*序号*/
rbg05       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
rbg06       number(5) DEFAULT '0' NOT NULL, /*组别*/
rbg07       varchar2(2) DEFAULT ' ' NOT NULL, /*数据类型01.产品、02.产品分类 */
rbg08       varchar2(40) DEFAULT ' ' NOT NULL, /*编号*/
rbg09       varchar2(4) DEFAULT ' ' NOT NULL, /*单位*/
rbgacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*有效否*/
rbglegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人别*/
rbgplant    varchar2(10) DEFAULT ' ' NOT NULL /*营运中心编号*/
);

alter table rbg_file add  constraint rbg_pk primary key  (rbg01,rbg02,rbg03,rbg04,rbg05,rbg06,rbg07,rbg08,rbg09,rbgplant) enable validate;
grant select on rbg_file to tiptopgp;
grant update on rbg_file to tiptopgp;
grant delete on rbg_file to tiptopgp;
grant insert on rbg_file to tiptopgp;
grant index on rbg_file to public;
grant select on rbg_file to ods;
