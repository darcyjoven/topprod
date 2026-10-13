/*
================================================================================
檔案代號:sfbi_file
檔案名稱:工单档单头(行业别档)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfbi_file
(
sfbi01      varchar2(20) DEFAULT ' ' NOT NULL, /*工单编号*/
sfbiicd01   varchar2(10),            /*下阶段厂商                             */
sfbiicd02   varchar2(10),            /*Wafer厂商                              */
sfbiicd03   varchar2(10),            /*Wafer厂商厂别                          */
sfbiicd04   number(15,3),            /*预计完工数                             */
sfbiicd05   number(15,3),            /*预计完工数                             */
sfbiicd06   number(15,3),            /*生产数量                               */
sfbiicd07   varchar2(80),            /*Datecode                               */
sfbiicd08   varchar2(40),            /*完工料号                               */
sfbiicd09   varchar2(10),            /*作业编号                               */
sfbiicd10   varchar2(1),             /*Mutli-Die                              */
sfbiicd11   varchar2(80),            /*B/D No                                 */
sfbiicd12   varchar2(6),             /*Pkg Type                               */
sfbiicd13   varchar2(24),            /*回货批号                               */
sfbiicd14   varchar2(40),            /*母体料号                               */
sfbiicd15   number(5),               /*母工单项次                             */
sfbiicd16   varchar2(20),            /*入库单号                               */
sfbiicd17   number(5),               /*入库单项次                             */
sfbiicd18   varchar2(10),            /*Pin Count                              */
sfbiplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
sfbilegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table sfbi_file add  constraint sfbi_pk primary key  (sfbi01) enable validate;
grant select on sfbi_file to tiptopgp;
grant update on sfbi_file to tiptopgp;
grant delete on sfbi_file to tiptopgp;
grant insert on sfbi_file to tiptopgp;
grant index on sfbi_file to public;
grant select on sfbi_file to ods;
