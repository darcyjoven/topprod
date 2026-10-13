/*
================================================================================
檔案代號:lte_file
檔案名稱:No Use
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lte_file
(
lte01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
lte02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lte03       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lte04       varchar2(10),            /*审核人                                 */
lte05       date,                    /*审核日期                               */
lte06       varchar2(50),            /*备注                                   */
lteacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ltecrat     date,                    /*资料创建日                             */
ltedate     date,                    /*最近更改日                             */
ltegrup     varchar2(10),            /*资料所有部门                           */
ltelegal    varchar2(10) NOT NULL,   /*所属法人                               */
ltemodu     varchar2(10),            /*资料更改者                             */
lteorig     varchar2(10),            /*资料建立部门                           */
lteoriu     varchar2(10),            /*资料建立者                             */
lteplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
lteuser     varchar2(10)             /*资料所有者                             */
);

alter table lte_file add  constraint lte_pk primary key  (lte01,lte02) enable validate;
grant select on lte_file to tiptopgp;
grant update on lte_file to tiptopgp;
grant delete on lte_file to tiptopgp;
grant insert on lte_file to tiptopgp;
grant index on lte_file to public;
grant select on lte_file to ods;
