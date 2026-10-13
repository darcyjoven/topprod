/*
================================================================================
檔案代號:obz_file
檔案名稱:车队资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table obz_file
(
obz01       varchar2(6) NOT NULL,    /*车队编号                               */
obz02       varchar2(80),            /*说明                                   */
obz03       varchar2(20),            /*车队队长                               */
obz04       varchar2(40),            /*联络电话一                             */
obz05       varchar2(40),            /*联络电话二                             */
obzacti     varchar2(1),             /*资料有效码                             */
obzuser     varchar2(10),            /*资料所有者                             */
obzgrup     varchar2(10),            /*资料所有部门                           */
obzmodu     varchar2(10),            /*资料更改者                             */
obzdate     date,                    /*最近更改日                             */
obzorig     varchar2(10),            /*资料建立部门                           */
obzoriu     varchar2(10)             /*资料建立者                             */
);

alter table obz_file add  constraint obz_pk primary key  (obz01) enable validate;
grant select on obz_file to tiptopgp;
grant update on obz_file to tiptopgp;
grant delete on obz_file to tiptopgp;
grant insert on obz_file to tiptopgp;
grant index on obz_file to public;
grant select on obz_file to ods;
