/*
================================================================================
檔案代號:com_file
檔案名稱:合同标准BOM单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table com_file
(
com01       varchar2(40) NOT NULL,   /*商品编号                               */
com012      varchar2(1),             /*No Use                                 */
com02       varchar2(20) NOT NULL,   /*版本编号                               */
com03       varchar2(10) NOT NULL,   /*海关编号                               */
com04       varchar2(1),             /*No Use                                 */
com05       varchar2(1),             /*No Use                                 */
comacti     varchar2(1),             /*资料有效码                             */
comuser     varchar2(10),            /*资料所有者                             */
comgrup     varchar2(10),            /*资料所有群                             */
commodu     varchar2(10),            /*资料更改者                             */
comdate     date,                    /*最近更改日                             */
comorig     varchar2(10),            /*资料建立部门                           */
comoriu     varchar2(10)             /*资料建立者                             */
);

alter table com_file add  constraint com_pk primary key  (com01,com02,com03) enable validate;
grant select on com_file to tiptopgp;
grant update on com_file to tiptopgp;
grant delete on com_file to tiptopgp;
grant insert on com_file to tiptopgp;
grant index on com_file to public;
grant select on com_file to ods;
