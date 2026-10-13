/*
================================================================================
檔案代號:tc_ppp_file
檔案名稱:仓库对应作业编号
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ppp_file
(
tc_ppp01    varchar2(40),            /*LOT                                    */
tc_ppp02    varchar2(40),            /*料号                                   */
tc_ppp03    varchar2(40),            /*作业编号                               */
tc_ppp04    varchar2(1),
tc_ppp05    varchar2(255),           /*no use                                 */
tc_ppp06    varchar2(40),            /*no use                                 */
tc_ppp07    varchar2(40),            /*no use                                 */
tc_ppp08    varchar2(40),            /*no use                                 */
tc_ppp09    varchar2(40),            /*no use                                 */
tc_ppp10    varchar2(40),            /*no use                                 */
tc_ppp11    varchar2(40),            /*no use                                 */
tc_ppp12    number(15,3),            /*no use                                 */
tc_ppp13    number(15,3),            /*no use                                 */
tc_ppp14    number(15,3),            /*no use                                 */
tc_ppp15    number(10),              /*no use                                 */
tc_ppp16    number(10),              /*no use                                 */
tc_ppp17    number(10),              /*no use                                 */
tc_ppp18    date,                    /*no use                                 */
tc_ppp19    date,                    /*no use                                 */
tc_ppp20    date,                    /*no use                                 */
tc_pppuser  varchar2(10),            /*资料所有者                             */
tc_pppgrep  varchar2(10),            /*资料所有群                             */
tc_pppmodu  varchar2(10),            /*资料更改者                             */
tc_pppdate  date                     /*最近更改日                             */
);

grant select on tc_ppp_file to tiptopgp;
grant update on tc_ppp_file to tiptopgp;
grant delete on tc_ppp_file to tiptopgp;
grant insert on tc_ppp_file to tiptopgp;
grant index on tc_ppp_file to public;
grant select on tc_ppp_file to ods;
