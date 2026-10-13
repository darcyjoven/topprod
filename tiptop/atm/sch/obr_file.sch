/*
================================================================================
檔案代號:obr_file
檔案名稱:车辆级别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obr_file
(
obr01       varchar2(1) NOT NULL,    /*车辆级别                               */
obr02       varchar2(80),            /*说明                                   */
obracti     varchar2(1),             /*资料有效码                             */
obruser     varchar2(10),            /*资料所有者                             */
obrgrup     varchar2(10),            /*资料所有部门                           */
obrmodu     varchar2(10),            /*资料更改者                             */
obrdate     date,                    /*最近更改日                             */
obrorig     varchar2(10),            /*资料建立部门                           */
obroriu     varchar2(10)             /*资料建立者                             */
);

alter table obr_file add  constraint obr_pk primary key  (obr01) enable validate;
grant select on obr_file to tiptopgp;
grant update on obr_file to tiptopgp;
grant delete on obr_file to tiptopgp;
grant insert on obr_file to tiptopgp;
grant index on obr_file to public;
grant select on obr_file to ods;
