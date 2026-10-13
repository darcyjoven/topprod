/*
================================================================================
檔案代號:ryw_file
檔案名稱:POS授权码资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ryw_file
(
ryw01       varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心编码*/
ryw02       varchar2(20) DEFAULT ' ' NOT NULL, /*授权码*/
rywacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rywcrat     date,                    /*资料创建日                             */
rywdate     date,                    /*资料更改日                             */
rywgrup     varchar2(10),            /*资料所有部门                           */
rywmodu     varchar2(10),            /*资料更改者                             */
ryworig     varchar2(10),            /*资料建立部门                           */
ryworiu     varchar2(10),            /*资料建立者                             */
rywpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否Y-已传N-未传*/
rywuser     varchar2(10)             /*资料所有者                             */
);

alter table ryw_file add  constraint ryw_pk primary key  (ryw01) enable validate;
grant select on ryw_file to tiptopgp;
grant update on ryw_file to tiptopgp;
grant delete on ryw_file to tiptopgp;
grant insert on ryw_file to tiptopgp;
grant index on ryw_file to public;
grant select on ryw_file to ods;
