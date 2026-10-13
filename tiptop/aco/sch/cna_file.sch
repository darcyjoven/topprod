/*
================================================================================
檔案代號:cna_file
檔案名稱:海关基本资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table cna_file
(
cna01       varchar2(10) NOT NULL,   /*海关编号                               */
cna02       varchar2(80),            /*海关名称                               */
cna03       varchar2(40),            /*海关简称                               */
cna04       varchar2(10),            /*报关方式                               */
cna05       varchar2(1),             /*No Use                                 */
cna06       varchar2(1),             /*No Use                                 */
cna07       varchar2(1),             /*No Use                                 */
cnaacti     varchar2(1),             /*资料有效码                             */
cnauser     varchar2(10),            /*资料所有者                             */
cnagrup     varchar2(10),            /*资料所有部门                           */
cnamodu     varchar2(10),            /*资料更改者                             */
cnadate     date,                    /*最近更改日                             */
cnaorig     varchar2(10),            /*资料建立部门                           */
cnaoriu     varchar2(10)             /*资料建立者                             */
);

alter table cna_file add  constraint cna_pk primary key  (cna01) enable validate;
grant select on cna_file to tiptopgp;
grant update on cna_file to tiptopgp;
grant delete on cna_file to tiptopgp;
grant insert on cna_file to tiptopgp;
grant index on cna_file to public;
grant select on cna_file to ods;
