/*
================================================================================
檔案代號:tc_imb_file
檔案名稱:在制LOT清单交接第一页签表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_imb_file
(
tc_imb01    varchar2(40) NOT NULL,   /*交接单号                               */
tc_imb02    number(10) NOT NULL,     /*项次                                   */
tc_imb03    varchar2(20),            /*作业编号                               */
tc_imb04    varchar2(40),            /*LOT单号                                */
tc_imb05    varchar2(40),            /*工单单号                               */
tc_imb06    number(15,3),            /*扫入量                                 */
tc_imb07    number(15,3),            /*开工量                                 */
tc_imb08    number(15,3),            /*完工量                                 */
tc_imb09    number(15,3),            /*扫出量                                 */
tc_imb10    number(15,3),            /*WIP量                                  */
tc_imb11    number(15,3),            /*报废量                                 */
tc_imb12    number(15,3),            /*返工量                                 */
tc_imb13    number(15,3)             /*PNL量                                  */
);

alter table tc_imb_file add  constraint tpc_imb_pk primary key  (tc_imb01,tc_imb02) enable validate;
grant select on tc_imb_file to tiptopgp;
grant update on tc_imb_file to tiptopgp;
grant delete on tc_imb_file to tiptopgp;
grant insert on tc_imb_file to tiptopgp;
grant index on tc_imb_file to public;
grant select on tc_imb_file to ods;
