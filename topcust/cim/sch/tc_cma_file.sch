/*
================================================================================
檔案代號:tc_cma_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_cma_file
(
tc_cma01    varchar2(10),            /*分群码                                 */
tc_cma02    number(5),               /*版本                                   */
tc_cma03    varchar2(1),             /*生效否                                 */
tc_cma04    varchar2(20),            /*建立人员                               */
tc_cma05    date,                    /*建立时间                               */
tc_cma06    varchar2(20),            /*修改人员                               */
tc_cma07    date,                    /*修改时间                               */
tc_cma08    varchar2(20),            /*审核人员                               */
tc_cma09    date,                    /*审核时间                               */
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

grant select on tc_cma_file to tiptopgp;
grant update on tc_cma_file to tiptopgp;
grant delete on tc_cma_file to tiptopgp;
grant insert on tc_cma_file to tiptopgp;
grant index on tc_cma_file to public;
grant select on tc_cma_file to ods;
