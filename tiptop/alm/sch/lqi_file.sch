/*
================================================================================
檔案代號:lqi_file
檔案名稱:维护折扣规则资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqi_file
(
lqi01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单编号*/
lqi02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
lqi03       varchar2(5) DEFAULT ' ' NOT NULL, /*序号*/
lqi04       number(20,2),            /*金额起                                 */
lqi05       number(20,2),            /*金额止                                 */
lqi06       number(6,2)              /*折扣金额或比率（%）                    */
);

alter table lqi_file add  constraint lqi_pk primary key  (lqi01,lqi03) enable validate;
grant select on lqi_file to tiptopgp;
grant update on lqi_file to tiptopgp;
grant delete on lqi_file to tiptopgp;
grant insert on lqi_file to tiptopgp;
grant index on lqi_file to public;
grant select on lqi_file to ods;
