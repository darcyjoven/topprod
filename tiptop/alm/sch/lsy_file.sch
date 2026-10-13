/*
================================================================================
檔案代號:lsy_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lsy_file
(
lsy00       varchar2(10),            /*No Use                                 */
lsy01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsy02       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lsy03       number(20,2) DEFAULT '0' NOT NULL, /*No Use*/
lsy04       number(20,2) DEFAULT '0' NOT NULL, /*No Use*/
lsy05       varchar2(20),            /*No Use                                 */
lsy06       varchar2(1) DEFAULT ' ' NOT NULL, /*No Use*/
lsylegal    varchar2(10) NOT NULL,   /*No Use                                 */
lsyplant    varchar2(10) NOT NULL    /*No Use                                 */
);

alter table lsy_file add  constraint lsy_pk primary key  (lsy01,lsy02) enable validate;
grant select on lsy_file to tiptopgp;
grant update on lsy_file to tiptopgp;
grant delete on lsy_file to tiptopgp;
grant insert on lsy_file to tiptopgp;
grant index on lsy_file to public;
grant select on lsy_file to ods;
