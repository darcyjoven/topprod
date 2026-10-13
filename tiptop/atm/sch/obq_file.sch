/*
================================================================================
檔案代號:obq_file
檔案名稱:车辆类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obq_file
(
obq01       varchar2(4) NOT NULL,    /*车辆类型                               */
obq02       varchar2(80),            /*说明                                   */
obqacti     varchar2(1),             /*资料有效码                             */
obquser     varchar2(10),            /*资料所有者                             */
obqgrup     varchar2(10),            /*资料所有部门                           */
obqmodu     varchar2(10),            /*资料更改者                             */
obqdate     date,                    /*最近更改日                             */
obqorig     varchar2(10),            /*资料建立部门                           */
obqoriu     varchar2(10)             /*资料建立者                             */
);

alter table obq_file add  constraint obq_pk primary key  (obq01) enable validate;
grant select on obq_file to tiptopgp;
grant update on obq_file to tiptopgp;
grant delete on obq_file to tiptopgp;
grant insert on obq_file to tiptopgp;
grant index on obq_file to public;
grant select on obq_file to ods;
