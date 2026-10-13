/*
================================================================================
檔案代號:lre_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lre_file
(
lre00       varchar2(10),            /*No Use                                 */
lre01       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lre02       varchar2(20) DEFAULT ' ' NOT NULL, /*No Use*/
lre03       number(20,2) DEFAULT '0' NOT NULL, /*No Use*/
lrelegal    varchar2(10) NOT NULL,   /*No Use                                 */
lreplant    varchar2(10) NOT NULL    /*No Use                                 */
);

alter table lre_file add  constraint lre_pk primary key  (lre01,lre02) enable validate;
grant select on lre_file to tiptopgp;
grant update on lre_file to tiptopgp;
grant delete on lre_file to tiptopgp;
grant insert on lre_file to tiptopgp;
grant index on lre_file to public;
grant select on lre_file to ods;
