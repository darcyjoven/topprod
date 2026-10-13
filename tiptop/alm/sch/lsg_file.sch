/*
================================================================================
檔案代號:lsg_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lsg_file
(
lsg01       number(20) DEFAULT '0' NOT NULL, /*No Use*/
lsg02       number(20) NOT NULL,     /*No Use                                 */
lsg03       varchar2(10),            /*No Use                                 */
lsg04       varchar2(1),             /*No Use                                 */
lsg05       varchar2(10),            /*No Use                                 */
lsg06       date,                    /*No Use                                 */
lsgacti     varchar2(1),             /*No Use                                 */
lsgcrat     date,                    /*No Use                                 */
lsgdate     date,                    /*No Use                                 */
lsggrup     varchar2(10),            /*No Use                                 */
lsglegal    varchar2(10) NOT NULL,   /*No Use                                 */
lsgmodu     varchar2(10),            /*No Use                                 */
lsguser     varchar2(10),            /*No Use                                 */
lsgoriu     varchar2(10),            /*No Use                                 */
lsgorig     varchar2(10),            /*No Use                                 */
lsgstore    varchar2(10) DEFAULT ' ' NOT NULL /*No Use*/
);

alter table lsg_file add  constraint lsg_pk primary key  (lsg01) enable validate;
grant select on lsg_file to tiptopgp;
grant update on lsg_file to tiptopgp;
grant delete on lsg_file to tiptopgp;
grant insert on lsg_file to tiptopgp;
grant index on lsg_file to public;
grant select on lsg_file to ods;
