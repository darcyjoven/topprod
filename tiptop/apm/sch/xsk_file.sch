/*
================================================================================
檔案代號:xsk_file
檔案名稱:库存开账明细
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xsk_file
(
xsk01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
xsk02       number(5) DEFAULT '0' NOT NULL, /*项次*/
xsk03       varchar2(40),            /*产品编号                               */
xsk04       varchar2(4),             /*单位                                   */
xsk05       number(15,3) DEFAULT '0' NOT NULL /*数量*/
);

alter table xsk_file add  constraint xsk_pk primary key  (xsk01,xsk02) enable validate;
grant select on xsk_file to tiptopgp;
grant update on xsk_file to tiptopgp;
grant delete on xsk_file to tiptopgp;
grant insert on xsk_file to tiptopgp;
grant index on xsk_file to public;
grant select on xsk_file to ods;
