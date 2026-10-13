/*
================================================================================
檔案代號:ooh_file
檔案名稱:社福团体爱心码档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ooh_file
(
ooh01       varchar2(10) DEFAULT ' ' NOT NULL, /*爱心码*/
ooh02       varchar2(100) DEFAULT ' ' NOT NULL, /*社福团体名称*/
oohacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
oohdate     date,                    /*最近更改日                             */
oohgrup     varchar2(10),            /*资料所有群                             */
oohmodu     varchar2(10),            /*资料更改者                             */
oohorig     varchar2(10),            /*资料建立部门                           */
oohoriu     varchar2(10),            /*资料建立者                             */
oohpos      varchar2(1) DEFAULT '1' NOT NULL /*已传POS否*/
);

alter table ooh_file add  constraint ooh_pk primary key  (ooh01) enable validate;
grant select on ooh_file to tiptopgp;
grant update on ooh_file to tiptopgp;
grant delete on ooh_file to tiptopgp;
grant insert on ooh_file to tiptopgp;
grant index on ooh_file to public;
grant select on ooh_file to ods;
