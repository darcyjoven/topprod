/*
================================================================================
檔案代號:lno_file
檔案名稱:连锁经营租金优惠信息单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table lno_file
(
lno01       varchar2(10),            /*no use 原门店编号                      */
lno02       varchar2(1) DEFAULT ' ' NOT NULL, /*经营类型*/
lno03       number(10) DEFAULT '0' NOT NULL, /*本店内连锁达*/
lno04       number(6,2),             /*折扣率                                 */
lnolegal    varchar2(10) NOT NULL,   /*所属法人                               */
lnostore    varchar2(10) DEFAULT ' ' NOT NULL /*门店编号*/
);

alter table lno_file add  constraint lno_pk primary key  (lnostore,lno02,lno03) enable validate;
grant select on lno_file to tiptopgp;
grant update on lno_file to tiptopgp;
grant delete on lno_file to tiptopgp;
grant insert on lno_file to tiptopgp;
grant index on lno_file to public;
grant select on lno_file to ods;
