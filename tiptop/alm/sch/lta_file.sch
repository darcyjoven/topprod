/*
================================================================================
檔案代號:lta_file
檔案名稱:卡种/券种生效范围变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lta_file
(
lta01       varchar2(20) DEFAULT ' ' NOT NULL, /*单据号*/
lta02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
lta03       varchar2(1) DEFAULT ' ' NOT NULL, /*审核码*/
lta04       varchar2(10),            /*审核人                                 */
lta05       date,                    /*审核日期                               */
lta06       varchar2(50),            /*备注                                   */
ltaacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ltacrat     date,                    /*资料创建日                             */
ltadate     date,                    /*最近更改日                             */
ltagrup     varchar2(10),            /*资料所有群                             */
ltamodu     varchar2(10),            /*资料更改者                             */
ltaorig     varchar2(10),            /*资料建立部门                           */
ltaoriu     varchar2(10),            /*资料建立者                             */
ltauser     varchar2(10)             /*资料所有者                             */
);

alter table lta_file add  constraint lta_pk primary key  (lta01,lta02) enable validate;
grant select on lta_file to tiptopgp;
grant update on lta_file to tiptopgp;
grant delete on lta_file to tiptopgp;
grant insert on lta_file to tiptopgp;
grant index on lta_file to public;
grant select on lta_file to ods;
