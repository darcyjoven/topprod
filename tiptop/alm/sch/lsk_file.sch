/*
================================================================================
檔案代號:lsk_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsk_file
(
lsk01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsk02       varchar2(20),            /*No Use                                 */
lsk03       varchar2(10),            /*No Use                                 */
lsk04       varchar2(20),            /*No Use                                 */
lsk05       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsk06       number(16),              /*No Use                                 */
lsk07       number(16),              /*No Use                                 */
lsk08       date,                    /*No Use                                 */
lsk09       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsk10       varchar2(10),            /*No Use                                 */
lsk11       date,                    /*No Use                                 */
lsk12       varchar2(10),            /*No Use                                 */
lskacti     varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lskcrat     date,                    /*No Use                                 */
lskdate     date,                    /*No Use                                 */
lskgrup     varchar2(10),            /*No Use                                 */
lsklegal    varchar2(10) NOT NULL,   /*No Use                                 */
lskmodu     varchar2(10),            /*No Use                                 */
lskplant    varchar2(10) NOT NULL,   /*No Use                                 */
lskuser     varchar2(10),            /*No Use                                 */
lskoriu     varchar2(10),            /*No Use                                 */
lskorig     varchar2(10)             /*No Use                                 */
);

alter table lsk_file add  constraint lsk_pk primary key  (lsk01) enable validate;
grant select on lsk_file to tiptopgp;
grant update on lsk_file to tiptopgp;
grant delete on lsk_file to tiptopgp;
grant insert on lsk_file to tiptopgp;
grant index on lsk_file to public;
grant select on lsk_file to ods;
