/*
================================================================================
檔案代號:obq_file
檔案名稱:車輛類型檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obq_file
(
obq01       varchar2(4),             /*車輛類型                               */
obq02       varchar2(20),            /*說明                                   */
obqacti     varchar2(1),             /*資料有效碼                             */
obquser     varchar2(10),            /*資料所有者                             */
obqgrup     varchar2(6),             /*資料所有部門                           */
obqmodu     varchar2(10),            /*資料修改者                             */
obqdate     date                     /*最近修改日                             */
);

create unique index obq_01 on obq_file (obq01);
grant select on obq_file to public;
grant index on obq_file to public;
grant update on obq_file to public;
grant delete on obq_file to public;
grant insert on obq_file to public;
