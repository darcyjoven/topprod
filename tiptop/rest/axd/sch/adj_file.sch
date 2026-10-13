/*
================================================================================
檔案代號:adj_file
檔案名稱:派車原因檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adj_file
(
adj01       varchar2(6),             /*派車原因                               */
adj02       varchar2(20),            /*說明                                   */
adjacti     varchar2(1),             /*資料有效碼                             */
adjuser     varchar2(10),            /*資料所有者                             */
adjgrup     varchar2(6),             /*資料所有部門                           */
adjmodu     varchar2(10),            /*資料更改者                             */
adjdate     date                     /*最近修改日                             */
);

create unique index adj_01 on adj_file (adj01);
grant select on adj_file to public;
grant index on adj_file to public;
grant update on adj_file to public;
grant delete on adj_file to public;
grant insert on adj_file to public;
