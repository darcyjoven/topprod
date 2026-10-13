/*
================================================================================
檔案代號:adq_file
檔案名稱:廠商庫存異動檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adq_file
(
adq01       varchar2(10),            /*客戶編號                               */
adq02       varchar2(20),            /*商品編號                               */
adq03       varchar2(24),            /*批號                                   */
adq04       date,                    /*異動日期                               */
adq05       varchar2(16),            /*原始單據編號                           */
adq06       varchar2(4),             /*原始單位                               */
adq07       number(15,3),            /*原始數量                               */
adq08       number(16,8),            /*換算率                                 */
adq09       number(15,3),            /*異動數量                               */
adq10       varchar2(1)              /*異動區分                               */
);

create unique index adq_01 on adq_file (adq01,adq02,adq03,adq04);
grant select on adq_file to public;
grant index on adq_file to public;
grant update on adq_file to public;
grant delete on adq_file to public;
grant insert on adq_file to public;
