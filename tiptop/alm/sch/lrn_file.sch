/*
================================================================================
檔案代號:lrn_file
檔案名稱:赠品回收记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lrn_file
(
lrn00       varchar2(10),            /*no use                                 */
lrn01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品回收单号*/
lrn02       varchar2(20),            /*赠送赠品编号                           */
lrn03       number(20,2) DEFAULT '0' NOT NULL, /*赠品价格*/
lrn04       number(20,2) DEFAULT '0' NOT NULL, /*赔偿金额*/
lrn05       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品发放单号*/
lrnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lrnplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lrn_file add  constraint lrn_pk primary key  (lrn01,lrn05) enable validate;
grant select on lrn_file to tiptopgp;
grant update on lrn_file to tiptopgp;
grant delete on lrn_file to tiptopgp;
grant insert on lrn_file to tiptopgp;
grant index on lrn_file to public;
grant select on lrn_file to ods;
