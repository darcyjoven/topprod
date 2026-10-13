/*
================================================================================
檔案代號:lqo_file
檔案名稱:销退扣减项资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lqo_file
(
lqo00       varchar2(10),            /*no use                                 */
lqo01       varchar2(20) DEFAULT ' ' NOT NULL, /*退货单编号*/
lqo02       varchar2(10) DEFAULT ' ' NOT NULL, /*扣减项编号*/
lqo03       number(20,2) DEFAULT '0' NOT NULL, /*金额*/
lqolegal    varchar2(10) NOT NULL,   /*所属法人                               */
lqoplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lqo_file add  constraint lqo_pk primary key  (lqo01,lqo02) enable validate;
grant select on lqo_file to tiptopgp;
grant update on lqo_file to tiptopgp;
grant delete on lqo_file to tiptopgp;
grant insert on lqo_file to tiptopgp;
grant index on lqo_file to public;
grant select on lqo_file to ods;
