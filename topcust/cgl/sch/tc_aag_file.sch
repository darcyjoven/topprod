/*
================================================================================
檔案代號:tc_aag_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_aag_file
(
tc_aag00    varchar2(5) NOT NULL,    /*账套                                   */
tc_aag01    varchar2(24) NOT NULL,   /*科目编码                               */
tc_aag02    varchar2(1),             /*核对类型                               */
tc_aag03    varchar2(255),           /*备注                                   */
tc_aag04    varchar2(1),             /*核对否                                 */
tc_aag11    varchar2(40),            /*no use                                 */
tc_aag12    varchar2(40),            /*no use                                 */
tc_aag13    varchar2(40),            /*no use                                 */
tc_aag14    varchar2(40),            /*no use                                 */
tc_aaguser  varchar2(10),            /*资料所有者                             */
tc_aaggrup  varchar2(10),            /*资料所有部门                           */
tc_aagmodu  varchar2(10),            /*资料修改者                             */
tc_aagdate  date,                    /*最近修改日                             */
tc_aagoriu  varchar2(10),            /*资料建立者                             */
tc_aagorig  varchar2(10)             /*资料建立部门                           */
);

alter table tc_aag_file add  constraint tpc_aag_pk primary key  (tc_aag00,tc_aag01) enable validate;
grant select on tc_aag_file to tiptopgp;
grant update on tc_aag_file to tiptopgp;
grant delete on tc_aag_file to tiptopgp;
grant insert on tc_aag_file to tiptopgp;
grant index on tc_aag_file to public;
grant select on tc_aag_file to ods;
