/*
================================================================================
檔案代號:tc_shd_file
檔案名稱:委外报工单转委外采购收货入库记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table tc_shd_file
(
tc_shd01    varchar2(40) NOT NULL,   /*流水号                                 */
                                     /*年年月月日日+四位流水码                */
tc_shd02    varchar2(40),            /*单据编号                               */
tc_shd03    varchar2(40),            /*采购单号                               */
tc_shd04    varchar2(40),            /*收货单号                               */
tc_shd05    varchar2(40),            /*入库单号                               */
tc_shd06    date,                    /*转入日期                               */
tc_shd07    varchar2(20),            /*转入人员编号                           */
tc_shdud01  varchar2(40),            /*备用字段1                              */
tc_shdud02  varchar2(40),            /*备用字段2                              */
tc_shdud03  varchar2(40),            /*备用字段3                              */
tc_shdud04  varchar2(40),            /*备用字段4                              */
tc_shdud05  varchar2(40),            /*备用字段5                              */
tc_shdud06  number(15,3),            /*备用字段6                              */
tc_shdud07  date                     /*备用字段7                              */
);

alter table tc_shd_file add  constraint tpc_shd_pk primary key  (tc_shd01) enable validate;
grant select on tc_shd_file to tiptopgp;
grant update on tc_shd_file to tiptopgp;
grant delete on tc_shd_file to tiptopgp;
grant insert on tc_shd_file to tiptopgp;
grant index on tc_shd_file to public;
grant select on tc_shd_file to ods;
