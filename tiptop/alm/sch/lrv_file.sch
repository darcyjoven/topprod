/*
================================================================================
檔案代號:lrv_file
檔案名稱:卡狀態異動維護單身檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrv_file
(
lrv00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型*/
lrv01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
lrv02       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lrv03       date,                    /*原有效期                               */
lrv04       date,                    /*有效期                                 */
lrvlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrvplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lrv_file add  constraint lrv_pk primary key  (lrv00,lrv01,lrv02) enable validate;
grant select on lrv_file to tiptopgp;
grant update on lrv_file to tiptopgp;
grant delete on lrv_file to tiptopgp;
grant insert on lrv_file to tiptopgp;
grant index on lrv_file to public;
grant select on lrv_file to ods;
