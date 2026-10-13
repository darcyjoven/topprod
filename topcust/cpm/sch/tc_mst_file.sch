/*
================================================================================
檔案代號:tc_mst_file
檔案名稱:采购需求明细表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_mst_file
(
tc_mst01    varchar2(40) NOT NULL,   /*采购需求版本                           */
tc_mst02    varchar2(40) NOT NULL,   /*料件编号                               */
tc_mst03    varchar2(40) NOT NULL,   /*单号                                   */
tc_mst04    number(15,3),            /*可领数量                               */
tc_mst05    number(15,3),            /*未领数量                               */
tc_mst06    date,                    /*预计开工日                             */
tc_mst07    varchar2(40),            /*状态                                   */
tc_mst08    varchar2(40),            /*工单类型                               */
tc_mst09    varchar2(40) NOT NULL,   /*制品代码                               */
tc_mst10    varchar2(40),            /*NO USE                                 */
tc_mst11    number(15,3),            /*NO USE                                 */
tc_mst12    number(15,3),            /*NO USE                                 */
tc_mst13    date,                    /*NO USE                                 */
tc_mst14    varchar2(40),            /*NO USE                                 */
tc_mst15    varchar2(40)             /*NO USE                                 */
);

alter table tc_mst_file add  constraint tpc_mst_pk primary key  (tc_mst01,tc_mst02,tc_mst03,tc_mst09) enable validate;
grant select on tc_mst_file to tiptopgp;
grant update on tc_mst_file to tiptopgp;
grant delete on tc_mst_file to tiptopgp;
grant insert on tc_mst_file to tiptopgp;
grant index on tc_mst_file to public;
grant select on tc_mst_file to ods;
