/*
================================================================================
檔案代號:lmt_file
檔案名稱:战盟颜色设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmt_file
(
lmt01       varchar2(1) DEFAULT ' ' NOT NULL, /*战盟状态*/
lmt02       varchar2(10),            /*颜色                                   */
lmt03       varchar2(30),            /*说明                                   */
lmtacti     varchar2(1),             /*资料有效码                             */
lmtcrat     date,                    /*资料创建日                             */
lmtdate     date,                    /*资料更改日                             */
lmtgrup     varchar2(10),            /*资料所有群                             */
lmtmodu     varchar2(10),            /*资料更改者                             */
lmtuser     varchar2(10),            /*资料所有者                             */
lmtorig     varchar2(10),            /*资料建立部门                           */
lmtoriu     varchar2(10)             /*资料建立者                             */
);

alter table lmt_file add  constraint lmt_pk primary key  (lmt01) enable validate;
grant select on lmt_file to tiptopgp;
grant update on lmt_file to tiptopgp;
grant delete on lmt_file to tiptopgp;
grant insert on lmt_file to tiptopgp;
grant index on lmt_file to public;
grant select on lmt_file to ods;
