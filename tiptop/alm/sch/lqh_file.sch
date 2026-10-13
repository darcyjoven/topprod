/*
================================================================================
檔案代號:lqh_file
檔案名稱:默認費用分攤資料檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqh_file
(
lqh01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单编号*/
lqh02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
lqh03       varchar2(5) DEFAULT ' ' NOT NULL, /*序号*/
lqh04       number(20,2),            /*金额起                                 */
lqh05       number(20,2),            /*金额止                                 */
lqh06       number(6,2)              /*分离比例（%）                          */
);

alter table lqh_file add  constraint lqh_pk primary key  (lqh01,lqh03) enable validate;
grant select on lqh_file to tiptopgp;
grant update on lqh_file to tiptopgp;
grant delete on lqh_file to tiptopgp;
grant insert on lqh_file to tiptopgp;
grant index on lqh_file to public;
grant select on lqh_file to ods;
