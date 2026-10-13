/*
================================================================================
檔案代號:tc_bab_file
檔案名稱:盖垫板基础资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_bab_file
(
tc_bab01    varchar2(30) NOT NULL,   /*产品系列                               */
tc_bab02    number(20,6),            /*类型                                   */
tc_bab03    number(20,6),            /*叠板数                                 */
tc_bab04    number(20,6),            /*盖板用量                               */
tc_bab05    number(20,6),            /*垫板用量                               */
tc_bab06    number(20,6),            /*孔数                                   */
tc_bab07    number(20,6),            /*寿命                                   */
tc_bab08    number(20,6)             /*铝片用量                               */
);

grant select on tc_bab_file to tiptopgp;
grant update on tc_bab_file to tiptopgp;
grant delete on tc_bab_file to tiptopgp;
grant insert on tc_bab_file to tiptopgp;
grant index on tc_bab_file to public;
grant select on tc_bab_file to ods;
