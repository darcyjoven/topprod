/*
================================================================================
檔案代號:lmo_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmo_file
(
lmo00       varchar2(10),            /*No Use                                 */
lmo01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lmo02       varchar2(20),            /*No Use                                 */
lmo03       varchar2(10),            /*No Use                                 */
lmo04       varchar2(20),            /*No Use                                 */
lmo05       number(20,2),            /*No Use                                 */
lmo06       number(20,2),            /*No Use                                 */
lmo07       number(20,2),            /*No Use                                 */
lmo08       varchar2(1),             /*No Use                                 */
lmo09       varchar2(10),            /*No Use                                 */
lmo10       date,                    /*No Use                                 */
lmoacti     varchar2(1),             /*No Use                                 */
lmocrat     date,                    /*No Use                                 */
lmodate     date,                    /*No Use                                 */
lmogrup     varchar2(10),            /*No Use                                 */
lmolegal    varchar2(10) NOT NULL,   /*No Use                                 */
lmomodu     varchar2(10),            /*No Use                                 */
lmouser     varchar2(10),            /*No Use                                 */
lmooriu     varchar2(10),            /*No Use                                 */
lmoorig     varchar2(10),            /*No Use                                 */
lmostore    varchar2(10) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table lmo_file add  constraint lmo_pk primary key  (lmo01) enable validate;
grant select on lmo_file to tiptopgp;
grant update on lmo_file to tiptopgp;
grant delete on lmo_file to tiptopgp;
grant insert on lmo_file to tiptopgp;
grant index on lmo_file to public;
grant select on lmo_file to ods;
