/*
================================================================================
檔案代號:pmb_file
檔案名稱:多账期付款条件关联设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmb_file
(
pmb01       varchar2(10) NOT NULL,   /*母付款条件                             */
pmb02       varchar2(1),             /*类型                                   */
pmb03       number(5) NOT NULL,      /*项次                                   */
pmb04       varchar2(10),            /*子付款条件                             */
pmb05       number(9,4),             /*比率%                                  */
pmb06       varchar2(15),            /*no use                                 */
pmb07       varchar2(8),             /*no use                                 */
pmbacti     varchar2(1),             /*资料有效码                             */
pmbuser     varchar2(10),            /*资料所有者                             */
pmbgrup     varchar2(10),            /*资料所有部门                           */
pmbmodu     varchar2(10),            /*资料更改者                             */
pmbdate     date,                    /*最后更改日期                           */
pmborig     varchar2(10),            /*资料建立部门                           */
pmboriu     varchar2(10)             /*资料建立者                             */
);

alter table pmb_file add  constraint pmb_pk primary key  (pmb01,pmb03) enable validate;
grant select on pmb_file to tiptopgp;
grant update on pmb_file to tiptopgp;
grant delete on pmb_file to tiptopgp;
grant insert on pmb_file to tiptopgp;
grant index on pmb_file to public;
grant select on pmb_file to ods;
