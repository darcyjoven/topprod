/*
================================================================================
檔案代號:obs_file
檔案名稱:車輛廠牌檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obs_file
(
obs01       varchar2(16),            /*車輛廠牌                               */
obs02       varchar2(30),            /*說明                                   */
obsacti     varchar2(1),             /*資料有效碼                             */
obsuser     varchar2(10),            /*資料所有者                             */
obsgrup     varchar2(6),             /*資料所有部門                           */
obsmodu     varchar2(10),            /*資料修改者                             */
obsdate     date                     /*最近修改日                             */
);

create unique index obs_01 on obs_file (obs01);
grant select on obs_file to public;
grant index on obs_file to public;
grant update on obs_file to public;
grant delete on obs_file to public;
grant insert on obs_file to public;
