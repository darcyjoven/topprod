/*
================================================================================
檔案代號:adp_file
檔案名稱:客戶庫存明細檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adp_file
(
adp01       varchar2(10),            /*客戶編號                               */
adp02       varchar2(20),            /*商品編號                               */
adp03       varchar2(24),            /*批號                                   */
adp04       varchar2(4),             /*庫存單位                               */
adp05       number(15,3),            /*庫存數量                               */
adp06       date,                    /*有效日期                               */
adp07       date                     /*第一次入庫日期                         */
);

create unique index adp_01 on adp_file (adp01,adp02,adp03);
grant select on adp_file to public;
grant index on adp_file to public;
grant update on adp_file to public;
grant delete on adp_file to public;
grant insert on adp_file to public;
