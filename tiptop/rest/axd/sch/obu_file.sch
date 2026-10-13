/*
================================================================================
檔案代號:obu_file
檔案名稱:車輛保養項目檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obu_file
(
obu01       varchar2(4),             /*維護項目                               */
obu02       varchar2(20),            /*說明                                   */
obu03       varchar2(1),             /*類別                                   */
obu04       varchar2(40),            /*保養內容一                             */
obu05       varchar2(40),            /*保養內容二                             */
obu06       varchar2(40),            /*保養內容三                             */
obu07       varchar2(40),            /*保養內容四                             */
obuacti     varchar2(1),             /*資料有效碼                             */
obuuser     varchar2(10),            /*資料所有者                             */
obugrup     varchar2(6),             /*資料所有部門                           */
obumodu     varchar2(10),            /*資料修改者                             */
obudate     date                     /*最近修改日                             */
);

create unique index obu_01 on obu_file (obu01);
grant select on obu_file to public;
grant index on obu_file to public;
grant update on obu_file to public;
grant delete on obu_file to public;
grant insert on obu_file to public;
