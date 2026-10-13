/*
================================================================================
檔案代號:lsz_file
檔案名稱:变更生效范围数据文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsz_file
(
lsz01       varchar2(20) DEFAULT ' ' NOT NULL, /*兑换方案代码*/
lsz02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lsz03       varchar2(10) DEFAULT ' ' NOT NULL, /*生效门店编号*/
lsz04       varchar2(10),            /*产品分类                               */
lsz05       varchar2(20) DEFAULT ' ' NOT NULL, /*摊位编号*/
lsz06       date,                    /*生效日期                               */
lsz07       date,                    /*失效日期                               */
lsz08       varchar2(10),            /*更改人员                               */
lsz09       date,                    /*更改日期                               */
lsz10       varchar2(1) DEFAULT ' ' NOT NULL, /*有效否*/
lsz11       varchar2(10) DEFAULT ' ' NOT NULL, /*制订营运中心*/
lsz12       number(5) DEFAULT '0' NOT NULL, /*兑换方案版本号*/
lszlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
lszplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lsz13       varchar2(20) DEFAULT ' ' NOT NULL /*卡种代号*/
);

alter table lsz_file add  constraint lsz_pk primary key  (lsz01,lsz02,lsz03,lsz05,lsz11,lsz12,lsz13,lszplant) enable validate;
grant select on lsz_file to tiptopgp;
grant update on lsz_file to tiptopgp;
grant delete on lsz_file to tiptopgp;
grant insert on lsz_file to tiptopgp;
grant index on lsz_file to public;
grant select on lsz_file to ods;
