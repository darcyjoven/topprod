/*
================================================================================
檔案代號:edb_file
檔案名稱:合拼版资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table edb_file
(
edb01       varchar2(20) DEFAULT ' ' NOT NULL, /*合拼版号*/
edb02       number(5) DEFAULT '0' NOT NULL, /*合拼序*/
edb03       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
edb04       varchar2(10),            /*工艺编号                               */
edb05       number(10),              /*模数                                   */
edb06       number(10),              /*总模数                                 */
edb07       varchar2(10)             /*被取代工艺段号                         */
);

alter table edb_file add  constraint edb_pk primary key  (edb01,edb02) enable validate;
grant select on edb_file to tiptopgp;
grant update on edb_file to tiptopgp;
grant delete on edb_file to tiptopgp;
grant insert on edb_file to tiptopgp;
grant index on edb_file to public;
grant select on edb_file to ods;
