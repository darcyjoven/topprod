/*
================================================================================
檔案代號:tc_sia_file
檔案名稱:供应商发货单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sia_file
(
tc_sia01    varchar2(20) NOT NULL,   /*发货单号                               */
tc_sia02    varchar2(10),            /*供应商编码                             */
tc_sia03    date,                    /*单据日期                               */
tc_sia04    varchar2(255),           /*送货地点                               */
tc_sia05    varchar2(255),           /*备注                                   */
tc_sia06    varchar2(20),            /*ERP收货单号                            */
tc_sia07    varchar2(10),            /*所属法人                               */
tc_sia08    varchar2(1),             /*发货单状态                             */
tc_sia09    varchar2(3),             /*采购性质                               */
tc_sia10    number(5),               /*打印次数                               */
tc_sia11    varchar2(80)             /*发票号                                 */
);

alter table tc_sia_file add  constraint tpc_sia_pk primary key  (tc_sia01) enable validate;
grant select on tc_sia_file to tiptopgp;
grant update on tc_sia_file to tiptopgp;
grant delete on tc_sia_file to tiptopgp;
grant insert on tc_sia_file to tiptopgp;
grant index on tc_sia_file to public;
grant select on tc_sia_file to ods;
