/*
================================================================================
檔案代號:tc_zau_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zau_file
(
zau01       varchar2(80) NOT NULL,   /*查询单id                               */
zau02       varchar2(20),            /*资料所有者字段                         */
zau03       varchar2(20),            /*资料群组字段                           */
zau04       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zau_file to tiptopgp;
grant update on tc_zau_file to tiptopgp;
grant delete on tc_zau_file to tiptopgp;
grant insert on tc_zau_file to tiptopgp;
grant index on tc_zau_file to public;
grant select on tc_zau_file to ods;
