/*
================================================================================
檔案代號:pmy_file
檔案名稱:厂商分类代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmy_file
(
pmy01       varchar2(10) NOT NULL,   /*厂商分类代码                           */
                                     /*廠商分類代碼                           */
pmy02       varchar2(80),            /*厂商分类说明                           */
                                     /*廠商分類說明                           */
pmy03       varchar2(1),             /*No Use                                 */
pmy04       varchar2(1),             /*No Use                                 */
pmy05       varchar2(1),             /*No Use                                 */
pmy06       varchar2(1),             /*No Use                                 */
pmy07       varchar2(1),             /*No Use                                 */
pmy08       varchar2(1),             /*No Use                                 */
pmy09       varchar2(1),             /*No Use                                 */
pmy10       varchar2(1),             /*No Use                                 */
pmyacti     varchar2(1),             /*资料有效码                             */
pmyuser     varchar2(10),            /*资料所有者                             */
pmygrup     varchar2(10),            /*资料所有部门                           */
pmymodu     varchar2(10),            /*资料更改者                             */
pmydate     date,                    /*最近更改日                             */
pmyorig     varchar2(10),            /*资料建立部门                           */
pmyoriu     varchar2(10)             /*资料建立者                             */
);

alter table pmy_file add  constraint pmy_pk primary key  (pmy01) enable validate;
grant select on pmy_file to tiptopgp;
grant update on pmy_file to tiptopgp;
grant delete on pmy_file to tiptopgp;
grant insert on pmy_file to tiptopgp;
grant index on pmy_file to public;
grant select on pmy_file to ods;
