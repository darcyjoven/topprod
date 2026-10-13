/*
================================================================================
檔案代號:lsx_file
檔案名稱:赠品折扣和规则记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsx_file
(
lsx01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单编号*/
lsx02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
lsx03       varchar2(5) DEFAULT ' ' NOT NULL, /*序号*/
lsx04       number(20,2),            /*金额起                                 */
lsx05       number(20,2),            /*金额止                                 */
lsx06       varchar2(20)             /*赠品编号                               */
);

alter table lsx_file add  constraint lsx_pk primary key  (lsx01,lsx03) enable validate;
grant select on lsx_file to tiptopgp;
grant update on lsx_file to tiptopgp;
grant delete on lsx_file to tiptopgp;
grant insert on lsx_file to tiptopgp;
grant index on lsx_file to public;
grant select on lsx_file to ods;
