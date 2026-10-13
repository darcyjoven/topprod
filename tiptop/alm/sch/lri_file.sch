/*
================================================================================
檔案代號:lri_file
檔案名稱:赠品发放记录单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lri_file
(
lri00       varchar2(10),            /*no use                                 */
lri01       varchar2(20) DEFAULT ' ' NOT NULL, /*赠品发放单号*/
lri02       varchar2(20) DEFAULT ' ' NOT NULL, /*交款单编号*/
lri03       varchar2(20),            /*交款凭证号                             */
lri04       varchar2(20),            /*销售单单号                             */
lri05       varchar2(20),            /*销售合同号                             */
lri06       number(20,2) DEFAULT '0' NOT NULL, /*合同总金额*/
lri07       number(20,2) DEFAULT '0' NOT NULL, /*交款金额*/
lrilegal    varchar2(10) NOT NULL,   /*所属法人                               */
lriplant    varchar2(10) NOT NULL    /*所属营运中心                           */
);

alter table lri_file add  constraint lri_pk primary key  (lri01,lri02) enable validate;
grant select on lri_file to tiptopgp;
grant update on lri_file to tiptopgp;
grant delete on lri_file to tiptopgp;
grant insert on lri_file to tiptopgp;
grant index on lri_file to public;
grant select on lri_file to ods;
