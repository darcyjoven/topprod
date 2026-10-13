/*
================================================================================
檔案代號:abe_file
檔案名稱:打印族群资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table abe_file
(
abe01       varchar2(6) NOT NULL,    /*族群编号                               */
abe02       varchar2(80),            /*族群名称                               */
abe03       varchar2(10),            /*部门编号                               */
abe04       number(5) NOT NULL,      /*项次                                   */
abe05       varchar2(1),             /*No Use                                 */
abe06       varchar2(1),             /*No Use                                 */
abe07       varchar2(1),             /*No Use                                 */
abeacti     varchar2(1),             /*资料有效码                             */
abeuser     varchar2(10),            /*资料所有者                             */
abegrup     varchar2(10),            /*资料所有部门                           */
abemodu     varchar2(10),            /*资料更改者                             */
abedate     date,                    /*最近更改日                             */
abeorig     varchar2(10),            /*资料建立部门                           */
abeoriu     varchar2(10)             /*资料建立者                             */
);

alter table abe_file add  constraint abe_pk primary key  (abe01,abe04) enable validate;
grant select on abe_file to tiptopgp;
grant update on abe_file to tiptopgp;
grant delete on abe_file to tiptopgp;
grant insert on abe_file to tiptopgp;
grant index on abe_file to public;
grant select on abe_file to ods;
