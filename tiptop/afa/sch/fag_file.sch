/*
================================================================================
檔案代號:fag_file
檔案名稱:异动原因档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fag_file
(
fag01       varchar2(10) NOT NULL,   /*异动原因码                             */
fag02       varchar2(1),             /*性质                                   */
fag03       varchar2(80),            /*原因说明                               */
fagacti     varchar2(1),             /*资料有效码                             */
faguser     varchar2(10),            /*资料所有者                             */
faggrup     varchar2(10),            /*资料所有群                             */
fagmodu     varchar2(10),            /*资料更改者                             */
fagdate     date,                    /*最近更改日                             */
fagorig     varchar2(10),            /*资料建立部门                           */
fagoriu     varchar2(10)             /*资料建立者                             */
);

alter table fag_file add  constraint fag_pk primary key  (fag01) enable validate;
grant select on fag_file to tiptopgp;
grant update on fag_file to tiptopgp;
grant delete on fag_file to tiptopgp;
grant insert on fag_file to tiptopgp;
grant index on fag_file to public;
grant select on fag_file to ods;
