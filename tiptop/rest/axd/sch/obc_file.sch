/*
================================================================================
檔案代號:obc_file
檔案名稱:集團間銷售預測單頭檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obc_file
(
obc01       varchar2(40),            /*料件編號                               */
obc02       varchar2(1),             /*計劃期別格式                           */
obc021      number(10),              /*起始期別                               */
obc03       number(5),               /*產生期數                               */
obc04       varchar2(8),             /*計劃員                                 */
obc05       varchar2(6),             /*部門                                   */
obc06       varchar2(1),             /*擷取否                                 */
obc07       varchar2(4),             /*庫存單位                               */
obc08       varchar2(1),             /*No                                     */
obc09       varchar2(1),             /*No                                     */
obcconf     varchar2(1),             /*計劃確認                               */
obcacti     varchar2(1),             /*資料有效碼                             */
obcuser     varchar2(10),            /*資料所有者                             */
obcgrup     varchar2(6),             /*資料所有群                             */
obcmodu     varchar2(10),            /*資料更改者                             */
obcdate     date                     /*最近修改日                             */
);

create unique index obc_01 on obc_file (obc01,obc02,obc021);
grant select on obc_file to public;
grant index on obc_file to public;
grant update on obc_file to public;
grant delete on obc_file to public;
grant insert on obc_file to public;
