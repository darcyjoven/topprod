/*
================================================================================
檔案代號:tc_cmc_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_cmc_file
(
tc_cmc01    varchar2(10),            /*分群码                                 */
tc_cmc02    number(5),               /*版本                                   */
tc_cmc03    number(5),               /*项次                                   */
tc_cmc04    number(5),               /*项序                                   */
tc_cmc05    number(5),               /*项序2                                  */
tc_cmc06    varchar2(100),           /*说明                                   */
tc_cmc07    number(5)                /*影响项次                               */
);

grant select on tc_cmc_file to tiptopgp;
grant update on tc_cmc_file to tiptopgp;
grant delete on tc_cmc_file to tiptopgp;
grant insert on tc_cmc_file to tiptopgp;
grant index on tc_cmc_file to public;
grant select on tc_cmc_file to ods;
