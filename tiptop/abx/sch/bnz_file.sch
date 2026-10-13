/*
================================================================================
檔案代號:bnz_file
檔案名稱:入库参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table bnz_file
(
bnz00       varchar2(1) NOT NULL,    /*KEY VALUE                              */
bnz01       varchar2(5),             /*入库单别不为                           */
bnz02       varchar2(5),             /*入库单别为进货单                       */
bnz03       varchar2(5),             /*出库单别为                             */
bnz04       varchar2(5)              /*抓放行单单别                           */
);

alter table bnz_file add  constraint bnz_pk primary key  (bnz00) enable validate;
grant select on bnz_file to tiptopgp;
grant update on bnz_file to tiptopgp;
grant delete on bnz_file to tiptopgp;
grant insert on bnz_file to tiptopgp;
grant index on bnz_file to public;
grant select on bnz_file to ods;
