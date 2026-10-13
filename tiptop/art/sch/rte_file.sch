/*
================================================================================
檔案代號:rte_file
檔案名稱:商品策略单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rte_file
(
rte01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品策略编号*/
rte02       number(10) DEFAULT '0' NOT NULL, /*项次*/
rte03       varchar2(40),            /*产品编号                               */
rte04       varchar2(1),             /*是否可采                               */
rte05       varchar2(1),             /*是否可售                               */
rte06       varchar2(1),             /*是否可退                               */
rte07       varchar2(1),             /*是否有效                               */
rtepos      varchar2(1) DEFAULT '1', /*已传POS否                              */
rte08       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
rte09       varchar2(1) DEFAULT '2' NOT NULL /*进/销项*/
);

create        index rte_02 on rte_file (rte01,rte03);
alter table rte_file add  constraint rte_pk primary key  (rte01,rte02) enable validate;
grant select on rte_file to tiptopgp;
grant update on rte_file to tiptopgp;
grant delete on rte_file to tiptopgp;
grant insert on rte_file to tiptopgp;
grant index on rte_file to public;
grant select on rte_file to ods;
