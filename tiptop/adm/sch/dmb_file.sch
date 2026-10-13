/*
================================================================================
檔案代號:dmb_file
檔案名稱:版本代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table dmb_file
(
dmb01       varchar2(6) NOT NULL,    /*版本代码                               */
dmb02       varchar2(80),            /*版本说明                               */
dmbacti     varchar2(1),             /*资料有效码                             */
dmbuser     varchar2(10),            /*资料所有者                             */
dmbgrup     varchar2(10),            /*资料所有群                             */
dmbmodu     varchar2(10),            /*资料更改者                             */
dmbdate     date,                    /*最近更改日                             */
dmborig     varchar2(10),            /*资料建立部门                           */
dmboriu     varchar2(10)             /*资料建立者                             */
);

alter table dmb_file add  constraint dmb_pk primary key  (dmb01) enable validate;
grant select on dmb_file to tiptopgp;
grant update on dmb_file to tiptopgp;
grant delete on dmb_file to tiptopgp;
grant insert on dmb_file to tiptopgp;
grant index on dmb_file to public;
grant select on dmb_file to ods;
