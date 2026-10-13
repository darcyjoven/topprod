/*
================================================================================
檔案代號:lsj_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsj_file
(
lsj01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsj02       varchar2(20),            /*No Use                                 */
lsj03       varchar2(10),            /*No Use                                 */
lsj04       varchar2(20),            /*No Use                                 */
lsj05       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsj06       number(16) DEFAULT '0' NOT NULL, /*No Use*/
lsj07       number(16) DEFAULT '0' NOT NULL, /*No Use*/
lsj08       date,                    /*No Use                                 */
lsj09       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsj10       varchar2(10),            /*No Use                                 */
lsj11       date,                    /*No Use                                 */
lsj12       varchar2(10),            /*No Use                                 */
lsjacti     varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsjcrat     date,                    /*No Use                                 */
lsjdate     date,                    /*No Use                                 */
lsjgrup     varchar2(10),            /*No Use                                 */
lsjlegal    varchar2(10) NOT NULL,   /*No Use                                 */
lsjmodu     varchar2(10),            /*No Use                                 */
lsjplant    varchar2(10) NOT NULL,   /*No Use                                 */
lsjuser     varchar2(10),            /*No Use                                 */
lsjoriu     varchar2(10),            /*No Use                                 */
lsjorig     varchar2(10)             /*No Use                                 */
);

alter table lsj_file add  constraint lsj_pk primary key  (lsj01) enable validate;
grant select on lsj_file to tiptopgp;
grant update on lsj_file to tiptopgp;
grant delete on lsj_file to tiptopgp;
grant insert on lsj_file to tiptopgp;
grant index on lsj_file to public;
grant select on lsj_file to ods;
