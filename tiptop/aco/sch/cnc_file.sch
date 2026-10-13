/*
================================================================================
檔案代號:cnc_file
檔案名稱:征免性质资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cnc_file
(
cnc01       varchar2(10) NOT NULL,   /*征免性质代码                           */
cnc02       varchar2(80),            /*征免性质名称                           */
cnc03       varchar2(1),             /*No Use                                 */
cncacti     varchar2(1),             /*资料有效码                             */
cncuser     varchar2(10),            /*资料所有者                             */
cncgrup     varchar2(10),            /*资料所有部门                           */
cncmodu     varchar2(10),            /*资料更改者                             */
cncdate     date,                    /*最近更改日                             */
cncoriu     varchar2(10),            /*资料建立者                             */
cncorig     varchar2(10)             /*资料建立部门                           */
);

alter table cnc_file add  constraint cnc_pk primary key  (cnc01) enable validate;
grant select on cnc_file to tiptopgp;
grant update on cnc_file to tiptopgp;
grant delete on cnc_file to tiptopgp;
grant insert on cnc_file to tiptopgp;
grant index on cnc_file to public;
grant select on cnc_file to ods;
