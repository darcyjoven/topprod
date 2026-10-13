/*
================================================================================
檔案代號:rvo_file
檔案名稱:分货调整单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvo_file
(
rvo01       varchar2(20) DEFAULT ' ' NOT NULL, /*分货调整单号*/
rvo02       varchar2(20),            /*配送分货单号                           */
rvo03       date,                    /*单据日期                               */
rvo04       varchar2(255),           /*备注                                   */
rvoacti     varchar2(1),             /*资料有效码                             */
rvocond     date,                    /*审核日期                               */
rvoconf     varchar2(1),             /*审核码                                 */
rvoconu     varchar2(10),            /*审核人员                               */
rvocrat     date,                    /*资料创建日                             */
rvodate     date,                    /*最近更改日                             */
rvogrup     varchar2(10),            /*资料所有部门                           */
rvolegal    varchar2(10) NOT NULL,   /*所属法人                               */
rvomodu     varchar2(10),            /*资料更改者                             */
rvoplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rvouser     varchar2(10),            /*资料所有者                             */
rvooriu     varchar2(10),            /*资料建立者                             */
rvoorig     varchar2(10)             /*资料建立部门                           */
);

alter table rvo_file add  constraint rvo_pk primary key  (rvo01) enable validate;
grant select on rvo_file to tiptopgp;
grant update on rvo_file to tiptopgp;
grant delete on rvo_file to tiptopgp;
grant insert on rvo_file to tiptopgp;
grant index on rvo_file to public;
grant select on rvo_file to ods;
