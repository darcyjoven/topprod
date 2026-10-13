/*
================================================================================
檔案代號:obz_file
檔案名稱:車隊資料檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obz_file
(
obz01       varchar2(6),             /*車隊編號                               */
obz02       varchar2(20),            /*說明                                   */
obz03       varchar2(20),            /*車隊隊長                               */
obz04       varchar2(16),            /*聯絡電話一                             */
obz05       varchar2(16),            /*聯絡電話二                             */
obzacti     varchar2(1),             /*資料有效碼                             */
obzuser     varchar2(10),            /*資料所有者                             */
obzgrup     varchar2(6),             /*資料所有部門                           */
obzmodu     varchar2(10),            /*資料修改者                             */
obzdate     date                     /*最近修改日                             */
);

create unique index obz_01 on obz_file (obz01);
grant select on obz_file to public;
grant index on obz_file to public;
grant update on obz_file to public;
grant delete on obz_file to public;
grant insert on obz_file to public;
