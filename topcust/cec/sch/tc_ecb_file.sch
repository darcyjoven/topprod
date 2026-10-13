/*
================================================================================
檔案代號:tc_ecb_file
檔案名稱:治工具维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ecb_file
(
tc_ecb01    varchar2(1) NOT NULL,    /*类型                                   */
tc_ecb02    varchar2(40) NOT NULL,   /*单号                                   */
tc_ecb03    number(5) NOT NULL,      /*项次                                   */
tc_ecb04    varchar2(40),            /*治工具编号                             */
tc_ecb05    number(16,8),            /*数量                                   */
tc_ecbud01  varchar2(255),           /*no use                                 */
tc_ecbud02  varchar2(40),            /*no use                                 */
tc_ecbud03  varchar2(40),            /*no use                                 */
tc_ecbud04  varchar2(40),            /*no use                                 */
tc_ecbud05  varchar2(40),            /*no use                                 */
tc_ecbud06  varchar2(40),            /*no use                                 */
tc_ecbud07  number(15,3),            /*no use                                 */
tc_ecbud08  number(15,3),            /*no use                                 */
tc_ecbud09  number(15,3),            /*no use                                 */
tc_ecbud10  number(10),              /*no use                                 */
tc_ecbud11  number(10),              /*no use                                 */
tc_ecbud12  number(10),              /*no use                                 */
tc_ecbud13  date,                    /*no use                                 */
tc_ecbud14  date,                    /*no use                                 */
tc_ecbud15  date,                    /*no use                                 */
tc_ecb06    number(5) NOT NULL       /*项次                                   */
);

alter table tc_ecb_file add  constraint tpc_ecb_pk primary key  (tc_ecb01,tc_ecb02,tc_ecb03,tc_ecb06) enable validate;
grant select on tc_ecb_file to tiptopgp;
grant update on tc_ecb_file to tiptopgp;
grant delete on tc_ecb_file to tiptopgp;
grant insert on tc_ecb_file to tiptopgp;
grant index on tc_ecb_file to public;
grant select on tc_ecb_file to ods;
