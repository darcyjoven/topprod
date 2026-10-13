/*
================================================================================
檔案代號:tc_codesys_file
檔案名稱:条码参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_codesys_file
(
tc_codesys00 varchar2(20) NOT NULL,
tc_codesys01 varchar2(20),           /*一般收货单                             */
tc_codesys02 varchar2(20),           /*委外收货单                             */
tc_codesys03 varchar2(20),           /*生产发料单                             */
tc_codesys04 varchar2(20),           /*杂收单                                 */
tc_codesys05 varchar2(20),           /*杂发单                                 */
tc_codesys06 varchar2(5),            /*完工入库单                             */
tc_codesys07 varchar2(20),           /*调拨单号                               */
tc_codesys08 varchar2(20),           /*出货单号                               */
tc_codesys09 varchar2(1),            /*先进先出否                             */
tc_codesys10 varchar2(1),            /*总装发料                               */
tc_codesys11 varchar2(1),            /*生产调拨                               */
tc_codesys12 varchar2(1),            /*销售出货                               */
tc_codesys13 varchar2(1)             /*是否允许负库存                         */
);

alter table tc_codesys_file add  constraint tpc_codesys_pk primary key  (tc_codesys00) enable validate;
grant select on tc_codesys_file to tiptopgp;
grant update on tc_codesys_file to tiptopgp;
grant delete on tc_codesys_file to tiptopgp;
grant insert on tc_codesys_file to tiptopgp;
grant index on tc_codesys_file to public;
grant select on tc_codesys_file to ods;
