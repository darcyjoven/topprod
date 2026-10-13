/*
================================================================================
檔案代號:tc_zar_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_zar_file
(
zar01       varchar2(80) NOT NULL,   /*查询单id                               */
zar02       varchar2(15) NOT NULL,   /*档案代码                               */
zar03       varchar2(20) NOT NULL,   /*字段代码                               */
zar04       number(5) NOT NULL,      /*序号                                   */
zar05       varchar2(1) NOT NULL     /*客制码                                 */
);

grant select on tc_zar_file to tiptopgp;
grant update on tc_zar_file to tiptopgp;
grant delete on tc_zar_file to tiptopgp;
grant insert on tc_zar_file to tiptopgp;
grant index on tc_zar_file to public;
grant select on tc_zar_file to ods;
