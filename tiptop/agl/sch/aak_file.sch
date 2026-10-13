/*
================================================================================
檔案代號:aak_file
檔案名稱:会计科目额外说明档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aak_file
(
aak01       varchar2(24) NOT NULL,   /*科目编号                               */
aak02       varchar2(4) NOT NULL,    /*类型                                   */
aak03       number(5) NOT NULL,      /*行序                                   */
aak04       varchar2(80),            /*额外说明                               */
aak00       varchar2(5) NOT NULL     /*帐套                                   */
);

alter table aak_file add  constraint aak_pk primary key  (aak00,aak01,aak02,aak03) enable validate;
grant select on aak_file to tiptopgp;
grant update on aak_file to tiptopgp;
grant delete on aak_file to tiptopgp;
grant insert on aak_file to tiptopgp;
grant index on aak_file to public;
grant select on aak_file to ods;
