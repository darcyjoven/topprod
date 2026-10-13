/*
================================================================================
檔案代號:ljo_file
檔案名稱:合同变更其他品牌单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ljo_file
(
ljo01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
ljo02       number(5),               /*合同版本                               */
ljo03       number(5) DEFAULT '0' NOT NULL, /*项次*/
ljo04       varchar2(10),            /*品牌编号                               */
ljolegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljoplant    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table ljo_file add  constraint ljo_pk primary key  (ljo01,ljo03) enable validate;
grant select on ljo_file to tiptopgp;
grant update on ljo_file to tiptopgp;
grant delete on ljo_file to tiptopgp;
grant insert on ljo_file to tiptopgp;
grant index on ljo_file to public;
grant select on ljo_file to ods;
