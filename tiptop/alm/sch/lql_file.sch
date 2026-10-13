/*
================================================================================
檔案代號:lql_file
檔案名稱:特殊摊位费用分摊设置单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lql_file
(
lql00       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lql01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
lql02       number(5) DEFAULT '0' NOT NULL, /*组别*/
lql03       number(5) NOT NULL,      /*项次                                   */
lql04       number(20,2),            /*金额起                                 */
lql05       number(20,2),            /*金额止                                 */
lql06       number(6,2)              /*费用分摊比率                           */
);

alter table lql_file add  constraint lql_pk primary key  (lql01,lql02,lql03) enable validate;
grant select on lql_file to tiptopgp;
grant update on lql_file to tiptopgp;
grant delete on lql_file to tiptopgp;
grant insert on lql_file to tiptopgp;
grant index on lql_file to public;
grant select on lql_file to ods;
