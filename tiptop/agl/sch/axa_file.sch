/*
================================================================================
檔案代號:axa_file
檔案名稱:关联企业层级维护作业(单头)
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axa_file
(
axa01       varchar2(10) NOT NULL,   /*集团代号                               */
axa02       varchar2(10) NOT NULL,   /*母公司编号                             */
axa03       varchar2(5) NOT NULL,    /*帐套编号                               */
axa04       varchar2(1) DEFAULT 'N' NOT NULL, /*是否为最终母公司*/
axa05       varchar2(1),             /*损益科目汇率选择方式                   */
axa06       varchar2(1),             /*No Use                                 */
axa07       varchar2(1),             /*no use                                 */
axa08       varchar2(1),             /*No Use                                 */
axaacti     varchar2(1),             /*资料有效码                             */
axauser     varchar2(10),            /*资料所有者                             */
axagrup     varchar2(10),            /*资料所有部门                           */
axamodu     varchar2(10),            /*资料更改者                             */
axadate     date,                    /*最近更改日                             */
axa09       varchar2(1),             /*独立会科合并                           */
axaoriu     varchar2(10),            /*资料建立者                             */
axaorig     varchar2(10),            /*资料建立部门                           */
axa10       number(5),               /*现行年度                               */
axa11       number(5)                /*现行期别                               */
);

alter table axa_file add  constraint axa_pk primary key  (axa01,axa02,axa03) enable validate;
grant select on axa_file to tiptopgp;
grant update on axa_file to tiptopgp;
grant delete on axa_file to tiptopgp;
grant insert on axa_file to tiptopgp;
grant index on axa_file to public;
grant select on axa_file to ods;
