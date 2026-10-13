/*
================================================================================
檔案代號:lik_file
檔案名稱:费用明细参数设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lik_file
(
lik01       varchar2(10) DEFAULT ' ' NOT NULL, /*费用编号*/
lik02       number(5) DEFAULT '0' NOT NULL, /*项次*/
lik03       varchar2(10),            /*楼栋编号                               */
lik04       varchar2(10),            /*楼层编号                               */
lik05       varchar2(10),            /*区域编号                               */
lik06       varchar2(10),            /*小类编号                               */
lik07       varchar2(10),            /*攤位用途                               */
lik08       varchar2(1) DEFAULT ' ' NOT NULL, /*日期类型*/
lik09       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方式*/
lik10       varchar2(1) DEFAULT ' ' NOT NULL, /*定义方法*/
liklegal    varchar2(10),            /*法人                                   */
likstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lik_file add  constraint lik_pk primary key  (likstore,lik01,lik02) enable validate;
grant select on lik_file to tiptopgp;
grant update on lik_file to tiptopgp;
grant delete on lik_file to tiptopgp;
grant insert on lik_file to tiptopgp;
grant index on lik_file to public;
grant select on lik_file to ods;
