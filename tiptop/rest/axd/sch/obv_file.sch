/*
================================================================================
檔案代號:obv_file
檔案名稱:車輛保養群組檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obv_file
(
obv01       varchar2(4),             /*保養群組                               */
obv012      varchar2(20),            /*說明                                   */
obv02       number(5,0),             /*項次                                   */
obv03       varchar2(4),             /*保養項目                               */
obvacti     varchar2(1),             /*資料有效碼                             */
obvuser     varchar2(10),            /*資料所有者                             */
obvgrup     varchar2(6),             /*資料所有部門                           */
obvmodu     varchar2(10),            /*資料修改者                             */
obvdate     date,                    /*最近修改日                             */
obv04       number(10,0),            /*里程公里數                             */
obv05       number(5,0)              /*行駛年數                               */
);

create unique index obv_01 on obv_file (obv01,obv02);
grant select on obv_file to public;
grant index on obv_file to public;
grant update on obv_file to public;
grant delete on obv_file to public;
grant insert on obv_file to public;
