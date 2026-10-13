/*
================================================================================
檔案代號:obs_file
檔案名稱:车辆厂牌档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obs_file
(
obs01       varchar2(16) NOT NULL,   /*车辆厂牌                               */
obs02       varchar2(80),            /*说明                                   */
obsacti     varchar2(1),             /*资料有效码                             */
obsuser     varchar2(10),            /*资料所有者                             */
obsgrup     varchar2(10),            /*资料所有部门                           */
obsmodu     varchar2(10),            /*资料更改者                             */
obsdate     date,                    /*最近更改日                             */
obsorig     varchar2(10),            /*资料建立部门                           */
obsoriu     varchar2(10)             /*资料建立者                             */
);

alter table obs_file add  constraint obs_pk primary key  (obs01) enable validate;
grant select on obs_file to tiptopgp;
grant update on obs_file to tiptopgp;
grant delete on obs_file to tiptopgp;
grant insert on obs_file to tiptopgp;
grant index on obs_file to public;
grant select on obs_file to ods;
