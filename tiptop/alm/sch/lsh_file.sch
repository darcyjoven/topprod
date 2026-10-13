/*
================================================================================
檔案代號:lsh_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsh_file
(
lsh00       varchar2(10),            /*No Use                                 */
lsh01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsh02       varchar2(20),            /*No Use                                 */
lsh03       varchar2(10),            /*No Use                                 */
lsh04       varchar2(20),            /*No Use                                 */
lsh05       varchar2(10),            /*No Use                                 */
lsh06       number(20,2),            /*No Use                                 */
lsh07       number(20),              /*No Use                                 */
lsh08       number(20,2),            /*No Use                                 */
lsh09       varchar2(1),             /*No Use                                 */
lsh10       date,                    /*No Use                                 */
lsh11       varchar2(1),             /*No Use                                 */
lsh12       varchar2(10),            /*No Use                                 */
lsh13       date,                    /*No Use                                 */
lsh14       varchar2(255),           /*No Use                                 */
lshacti     varchar2(1),             /*No Use                                 */
lshcrat     date,                    /*No Use                                 */
lshdate     date,                    /*No Use                                 */
lshgrup     varchar2(10),            /*No Use                                 */
lshlegal    varchar2(10) NOT NULL,   /*No Use                                 */
lshmodu     varchar2(10),            /*No Use                                 */
lshplant    varchar2(10) NOT NULL,   /*No Use                                 */
lshuser     varchar2(10),            /*No Use                                 */
lshoriu     varchar2(10),            /*No Use                                 */
lshorig     varchar2(10)             /*No Use                                 */
);

alter table lsh_file add  constraint lsh_pk primary key  (lsh01) enable validate;
grant select on lsh_file to tiptopgp;
grant update on lsh_file to tiptopgp;
grant delete on lsh_file to tiptopgp;
grant insert on lsh_file to tiptopgp;
grant index on lsh_file to public;
grant select on lsh_file to ods;
