/*
================================================================================
檔案代號:obp_file
檔案名稱:單位運費數據文件
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obp_file
(
obp01       varchar2(4),             /*運輸方式代碼                           */
obp02       varchar2(10),            /*始起運輸地點                           */
obp03       varchar2(10),            /*目的運輸地點                           */
obp04       number(5,1),             /*耗用天數                               */
obp05       varchar2(4),             /*幣別                                   */
obp06       number(14,4),            /*單位運費                               */
obp07       number(14,4),            /*單位運費(退回)                         */
obpacti     varchar2(1),             /*資料有效碼                             */
obpuser     varchar2(10),            /*資料所有者                             */
obpgrup     varchar2(6),             /*資料所有部門                           */
obpmodu     varchar2(10),            /*資料修改者                             */
obpdate     date                     /*最近修改日                             */
);

create unique index obp_01 on obp_file (obp01,obp02,obp03);
grant select on obp_file to public;
grant index on obp_file to public;
grant update on obp_file to public;
grant delete on obp_file to public;
grant insert on obp_file to public;
