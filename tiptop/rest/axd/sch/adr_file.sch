/*
================================================================================
檔案代號:adr_file
檔案名稱:廠商庫存月統計檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adr_file
(
adr01       varchar2(10),            /*客戶編號                               */
adr02       varchar2(20),            /*商品編號                               */
adr03       varchar2(24),            /*批號                                   */
adr04       number(5),               /*年度                                   */
adr05       number(5),               /*期別                                   */
adr06       number(15,3),            /*本期銷售                               */
adr07       number(15,3),            /*本期銷退                               */
adr08       number(15,3),            /*客戶銷售                               */
adr09       number(15,3)             /*期末數量                               */
);

create unique index adr_01 on adr_file (adr01,adr02,adr03,adr04,adr05);
grant select on adr_file to public;
grant index on adr_file to public;
grant update on adr_file to public;
grant delete on adr_file to public;
grant insert on adr_file to public;
