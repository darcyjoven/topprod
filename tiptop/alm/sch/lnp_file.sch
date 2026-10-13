/*
================================================================================
檔案代號:lnp_file
檔案名稱:连锁店所属区域资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lnp_file
(
lnp01       varchar2(10),            /*no use 原门店编号                      */
lnp02       varchar2(1) DEFAULT ' ' NOT NULL, /*经营类型*/
lnp03       varchar2(20),            /*所属区域编号                           */
lnp04       number(3) DEFAULT '0' NOT NULL, /*本店所属区域连锁达*/
lnp05       number(6,2),             /*折扣率                                 */
lnplegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnpstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnp_file add  constraint lnp_pk primary key  (lnpstore,lnp02,lnp04) enable validate;
grant select on lnp_file to tiptopgp;
grant update on lnp_file to tiptopgp;
grant delete on lnp_file to tiptopgp;
grant insert on lnp_file to tiptopgp;
grant index on lnp_file to public;
grant select on lnp_file to ods;
