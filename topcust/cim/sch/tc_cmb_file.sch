/*
================================================================================
檔案代號:tc_cmb_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_cmb_file
(
tc_cmb01    varchar2(10),            /*分群码                                 */
tc_cmb02    number(5),               /*版本                                   */
tc_cmb03    number(5),               /*项次                                   */
tc_cmb04    number(5),               /*项序                                   */
tc_cmb05    varchar2(100),           /*说明                                   */
tc_cmb06    varchar2(1000),          /*可选值                                 */
tc_cmb07    varchar2(100),           /*影响可录入字段                         */
tc_cmb08    varchar2(100),
tc_cmb09    varchar2(100),
tc_cma10    varchar2(40),            /*类型说明                               */
tc_cma11    varchar2(40),
tc_cma12    varchar2(40),
tc_cma13    date,
tc_cma14    date,
tc_cma15    date,
tc_cma16    number(10),
tc_cma17    number(10),
tc_cma18    number(10)
);

grant select on tc_cmb_file to tiptopgp;
grant update on tc_cmb_file to tiptopgp;
grant delete on tc_cmb_file to tiptopgp;
grant insert on tc_cmb_file to tiptopgp;
grant index on tc_cmb_file to public;
grant select on tc_cmb_file to ods;
