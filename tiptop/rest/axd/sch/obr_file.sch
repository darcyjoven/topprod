/*
================================================================================
檔案代號:obr_file
檔案名稱:車輛級別檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obr_file
(
obr01       varchar2(1),             /*車輛級別                               */
obr02       varchar2(30),            /*說明                                   */
obracti     varchar2(1),             /*資料有效碼                             */
obruser     varchar2(10),            /*資料所有者                             */
obrgrup     varchar2(6),             /*資料所有部門                           */
obrmodu     varchar2(10),            /*資料修改者                             */
obrdate     date                     /*最近修改日                             */
);

create unique index obr_01 on obr_file (obr01);
grant select on obr_file to public;
grant index on obr_file to public;
grant update on obr_file to public;
grant delete on obr_file to public;
grant insert on obr_file to public;
