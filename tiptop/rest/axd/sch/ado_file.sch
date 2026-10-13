/*
================================================================================
檔案代號:ado_file
檔案名稱:車輛加油記錄檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table ado_file
(
ado01       varchar2(10),            /*車輛編號                               */
ado02       date,                    /*加油日期                               */
ado03       number(5),               /*序號                                   */
ado04       number(15,6),            /*加油數量                               */
ado05       number(20,6),            /*加油金額                               */
ado06       varchar2(8),             /*駕駛員                                 */
ado07       varchar2(20),            /*加油地點                               */
adoacti     varchar2(1),             /*資料有效碼                             */
adouser     varchar2(10),            /*資料所有者                             */
adogrup     varchar2(6),             /*資料所有部門                           */
adomodu     varchar2(10),            /*資料修改者                             */
adodate     date                     /*最近修改日                             */
);

create unique index ado_01 on ado_file (ado01,ado02,ado03);
grant select on ado_file to public;
grant index on ado_file to public;
grant update on ado_file to public;
grant delete on ado_file to public;
grant insert on ado_file to public;
