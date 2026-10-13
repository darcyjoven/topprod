/*
================================================================================
檔案代號:obh_file
檔案名稱:下階營運中心銷售預測單身檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table obh_file
(
obh01       varchar2(40),            /*料件編號                               */
obh02       varchar2(1),             /*計劃期別格式                           */
obh021      number(10),              /*起始期別                               */
obh03       number(5),               /*序號                                   */
obh04       varchar2(10),            /*下階營運中心                           */
obh05       number(15,3),            /*下階需求量                             */
obh06       number(15,3),            /*下階調整量                             */
obh07       number(15,3),            /*小計                                   */
obh08       varchar2(1),             /*No                                     */
obh09       varchar2(1)              /*No                                     */
);

create unique index obh_01 on obh_file (obh01,obh02,obh021,obh03,obh04);
grant select on obh_file to public;
grant index on obh_file to public;
grant update on obh_file to public;
grant delete on obh_file to public;
grant insert on obh_file to public;
