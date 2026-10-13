/*
================================================================================
檔案代號:rum_file
檔案名稱:样品入场/退场单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rum_file
(
rum00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据类型1-入场单2-退场单*/
rum01       varchar2(20) DEFAULT ' ' NOT NULL,
rum02       varchar2(20),            /*来源单号                               */
rum03       varchar2(10),            /*供应商                                 */
rum04       date,
rum05       varchar2(10),            /*经办人员                               */
rum06       varchar2(255),           /*備注                                   */
rumacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
rumcond     date,                    /*审核日期                               */
rumconf     varchar2(1) DEFAULT ' ' NOT NULL,
rumconu     varchar2(10),            /*审核人员                               */
rumcrat     date,
rumdate     date,                    /*最近更改日                             */
rumgrup     varchar2(10),            /*资料所有部门                           */
rumlegal    varchar2(10) NOT NULL,   /*所属法人                               */
rummodu     varchar2(10),            /*资料更改者                             */
rumorig     varchar2(10),            /*资料建立部门                           */
rumoriu     varchar2(10),            /*资料建立者                             */
rumplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rumuser     varchar2(10)             /*资料所有者                             */
);

alter table rum_file add  constraint rum_pk primary key  (rum00,rum01,rumplant) enable validate;
grant select on rum_file to tiptopgp;
grant update on rum_file to tiptopgp;
grant delete on rum_file to tiptopgp;
grant insert on rum_file to tiptopgp;
grant index on rum_file to public;
grant select on rum_file to ods;
