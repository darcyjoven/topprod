/*
================================================================================
檔案代號:lii_file
檔案名稱:合同费用项设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lii_file
(
lii01       varchar2(20) DEFAULT ' ' NOT NULL, /*方案编号*/
lii02       date,                    /*单据日期                               */
lii03       varchar2(10),            /*楼栋编号                               */
lii04       varchar2(10),            /*楼层编号                               */
lii05       varchar2(10),            /*攤位用途                               */
lii06       varchar2(255),           /*备注                                   */
liiacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
liicond     date,                    /*审核日期                               */
liiconf     varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
liicont     varchar2(8),             /*审核时间                               */
liiconu     varchar2(10),            /*审核人                                 */
liicrat     date,                    /*资料创建日                             */
liidate     date,                    /*最近更改日                             */
liigrup     varchar2(10),            /*资料所有部门                           */
liilegal    varchar2(10),            /*法人                                   */
liimodu     varchar2(10),            /*资料更改者                             */
liiorig     varchar2(10),            /*资料建立部门                           */
liioriu     varchar2(10),            /*资料建立者                             */
liiplant    varchar2(10),            /*门店编号                               */
liiuser     varchar2(10)             /*资料所有者                             */
);

alter table lii_file add  constraint lii_pk primary key  (lii01) enable validate;
grant select on lii_file to tiptopgp;
grant update on lii_file to tiptopgp;
grant delete on lii_file to tiptopgp;
grant insert on lii_file to tiptopgp;
grant index on lii_file to public;
grant select on lii_file to ods;
