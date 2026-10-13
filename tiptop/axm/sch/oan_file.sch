/*
================================================================================
檔案代號:oan_file
檔案名稱:多角贸易抛转单别设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oan_file
(
oan01       varchar2(5) NOT NULL,    /*出货单别                               */
                                     /*出貨單別                               */
oan02       varchar2(5),             /*收货单别                               */
                                     /*收貨單別                               */
oan03       varchar2(5),             /*入库单别                               */
                                     /*入庫單別                               */
oan04       varchar2(5),             /*AR单别                                 */
                                     /*AR單別                     No.8084     */
oan05       varchar2(5)              /*AP单别                                 */
                                     /*AP單別                     No.8084     */
);

alter table oan_file add  constraint oan_pk primary key  (oan01) enable validate;
grant select on oan_file to tiptopgp;
grant update on oan_file to tiptopgp;
grant delete on oan_file to tiptopgp;
grant insert on oan_file to tiptopgp;
grant index on oan_file to public;
grant select on oan_file to ods;
