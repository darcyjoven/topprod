/*
================================================================================
檔案代號:lnq_file
檔案名稱:其他区域资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lnq_file
(
lnq01       varchar2(10),            /*no use 原门店编号                      */
lnq02       varchar2(1) DEFAULT ' ' NOT NULL, /*经营类型*/
lnq03       number(3) DEFAULT '0' NOT NULL, /*连锁总数达*/
lnq04       number(6,2),             /*折扣率                                 */
lnqlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnqstore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lnq_file add  constraint lnq_pk primary key  (lnqstore,lnq02,lnq03) enable validate;
grant select on lnq_file to tiptopgp;
grant update on lnq_file to tiptopgp;
grant delete on lnq_file to tiptopgp;
grant insert on lnq_file to tiptopgp;
grant index on lnq_file to public;
grant select on lnq_file to ods;
