/*
================================================================================
檔案代號:xsa_file
檔案名稱:B2B系統別設定
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table xsa_file
(
xsa00       varchar2(1) DEFAULT '0' NOT NULL, /*KEY VALUE*/
xsa01       varchar2(5),             /*订购单别                               */
xsa02       varchar2(5),             /*收货单别                               */
xsa03       varchar2(5),             /*入库单别                               */
xsa04       varchar2(5),             /*退货单别                               */
xsa05       varchar2(5),             /*订单底稿单别                           */
xsa06       varchar2(5),             /*订单单别                               */
xsa07       varchar2(5),             /*出货单别                               */
xsa08       varchar2(5),             /*销退单别                               */
xsa09       varchar2(5),             /*库存开账单别                           */
xsa10       varchar2(5),             /*库存调整单别                           */
xsa11       varchar2(4),             /*交易币种                               */
xsa12       varchar2(4),             /*交易税种                               */
xsa13       varchar2(1) DEFAULT 'N' NOT NULL /*订货检查库存*/
);

alter table xsa_file add  constraint xsa_pk primary key  (xsa00) enable validate;
grant select on xsa_file to tiptopgp;
grant update on xsa_file to tiptopgp;
grant delete on xsa_file to tiptopgp;
grant insert on xsa_file to tiptopgp;
grant index on xsa_file to public;
grant select on xsa_file to ods;
