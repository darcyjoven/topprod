/*
================================================================================
檔案代號:msg_file
檔案名稱:不纳入MRP计算采购单别资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table msg_file
(
msg01       varchar2(5) NOT NULL,    /*采购单别                               */
msg02       varchar2(1),             /*No Use                                 */
msg03       varchar2(1),             /*No Use                                 */
msgacti     varchar2(1),             /*资料有效码                             */
msguser     varchar2(10),            /*资料所有者                             */
msggrup     varchar2(10),            /*资料所有部门                           */
msgmodu     varchar2(10),            /*资料更改者                             */
msgdate     date,                    /*最近更改日                             */
msgoriu     varchar2(10),            /*资料建立者                             */
msgorig     varchar2(10)             /*资料建立部门                           */
);

alter table msg_file add  constraint msg_pk primary key  (msg01) enable validate;
grant select on msg_file to tiptopgp;
grant update on msg_file to tiptopgp;
grant delete on msg_file to tiptopgp;
grant insert on msg_file to tiptopgp;
grant index on msg_file to public;
grant select on msg_file to ods;
