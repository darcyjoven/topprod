/*
================================================================================
檔案代號:adj_file
檔案名稱:派车原因档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adj_file
(
adj01       varchar2(10) NOT NULL,   /*派车原因                               */
adj02       varchar2(80),            /*说明                                   */
adjacti     varchar2(1),             /*资料有效码                             */
adjuser     varchar2(10),            /*资料所有者                             */
adjgrup     varchar2(10),            /*资料所有部门                           */
adjmodu     varchar2(10),            /*资料更改者                             */
adjdate     date,                    /*最近更改日                             */
adjorig     varchar2(10),            /*资料建立部门                           */
adjoriu     varchar2(10)             /*资料建立者                             */
);

alter table adj_file add  constraint adj_pk primary key  (adj01) enable validate;
grant select on adj_file to tiptopgp;
grant update on adj_file to tiptopgp;
grant delete on adj_file to tiptopgp;
grant insert on adj_file to tiptopgp;
grant index on adj_file to public;
grant select on adj_file to ods;
