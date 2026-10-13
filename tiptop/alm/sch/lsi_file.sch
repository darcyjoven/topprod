/*
================================================================================
檔案代號:lsi_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsi_file
(
lsi01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsi02       number(20),              /*No Use                                 */
lsi03       number(20,2),            /*No Use                                 */
lsi04       date,                    /*No Use                                 */
lsi05       varchar2(10),            /*No Use                                 */
lsi06       varchar2(20),            /*No Use                                 */
lsi07       varchar2(20),            /*No Use                                 */
lsi08       varchar2(10),            /*No Use                                 */
lsi09       varchar2(255),           /*No Use                                 */
lsi10       varchar2(1),             /*No Use                                 */
lsi11       varchar2(10),            /*No Use                                 */
lsi12       date,                    /*No Use                                 */
lsi13       varchar2(10),            /*No Use                                 */
lsiacti     varchar2(1),             /*No Use                                 */
lsicrat     date,                    /*No Use                                 */
lsidate     date,                    /*No Use                                 */
lsigrup     varchar2(10),            /*No Use                                 */
lsilegal    varchar2(10) NOT NULL,   /*No Use                                 */
lsimodu     varchar2(10),            /*No Use                                 */
lsiplant    varchar2(10) NOT NULL,   /*No Use                                 */
lsiuser     varchar2(10),            /*No Use                                 */
lsioriu     varchar2(10),            /*No Use                                 */
lsiorig     varchar2(10)             /*No Use                                 */
);

alter table lsi_file add  constraint lsi_pk primary key  (lsi01) enable validate;
grant select on lsi_file to tiptopgp;
grant update on lsi_file to tiptopgp;
grant delete on lsi_file to tiptopgp;
grant insert on lsi_file to tiptopgp;
grant index on lsi_file to public;
grant select on lsi_file to ods;
