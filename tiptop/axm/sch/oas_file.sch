/*
================================================================================
檔案代號:oas_file
檔案名稱:多账期收款条件关联设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table oas_file
(
oas01       varchar2(6) NOT NULL,    /*母收款条件                             */
oas02       varchar2(1),             /*类型                                   */
oas03       number(5) NOT NULL,      /*项次                                   */
oas04       varchar2(6),             /*子收款条件                             */
oas05       number(9,4),             /*收款比率%                              */
oas06       varchar2(15),            /*No Use                                 */
oas07       varchar2(8),             /*No Use                                 */
oasacti     varchar2(1),             /*资料有效码                             */
oasuser     varchar2(10),            /*资料所有者                             */
oasgrup     varchar2(10),            /*资料所有部门                           */
oasmodu     varchar2(10),            /*资料更改者                             */
oasdate     date,                    /*最后更改日期                           */
oasorig     varchar2(10),            /*资料建立部门                           */
oasoriu     varchar2(10)             /*资料建立者                             */
);

alter table oas_file add  constraint oas_pk primary key  (oas01,oas03) enable validate;
grant select on oas_file to tiptopgp;
grant update on oas_file to tiptopgp;
grant delete on oas_file to tiptopgp;
grant insert on oas_file to tiptopgp;
grant index on oas_file to public;
grant select on oas_file to ods;
