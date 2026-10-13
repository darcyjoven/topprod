/*
================================================================================
檔案代號:ceb_file
檔案名稱:征减免税方式档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ceb_file
(
ceb01       varchar2(10) DEFAULT ' ' NOT NULL, /*征减免税方式代号*/
ceb02       varchar2(80),            /*征减免税方式名称                       */
cebacti     varchar2(1),             /*资料有效码                             */
cebdate     date,                    /*最近更改日                             */
cebgrup     varchar2(10),            /*资料所有部门                           */
cebmodu     varchar2(10),            /*资料更改者                             */
cebuser     varchar2(10),            /*资料所有者                             */
ceborig     varchar2(10),            /*资料建立部门                           */
ceboriu     varchar2(10)             /*资料建立者                             */
);

alter table ceb_file add  constraint ceb_pk primary key  (ceb01) enable validate;
grant select on ceb_file to tiptopgp;
grant update on ceb_file to tiptopgp;
grant delete on ceb_file to tiptopgp;
grant insert on ceb_file to tiptopgp;
grant index on ceb_file to public;
grant select on ceb_file to ods;
