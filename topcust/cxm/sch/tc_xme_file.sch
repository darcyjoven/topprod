/*
================================================================================
檔案代號:tc_xme_file
檔案名稱:产品价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_xme_file
(
tc_xme01    varchar2(6),             /*价格条件编号                           */
tc_xme02    varchar2(4),             /*币种                                   */
tc_xme03    varchar2(10),            /*客户编号                               */
tc_xme04    varchar2(255),           /*备注                                   */
tc_xme00    varchar2(40) NOT NULL,   /*核价单号                               */
tc_xmeconf  varchar2(1),             /*审核                                   */
tc_xmeuser  varchar2(10),            /*资料所有者                             */
tc_xmegrup  varchar2(10),            /*资料所有部门                           */
tc_xmemodu  varchar2(10),            /*资料更改者                             */
tc_xmedate  date,                    /*最近更改日                             */
tc_xmeoriu  varchar2(10),            /*资料建立者                             */
tc_xmeorig  varchar2(10),            /*资料建立部门                           */
tc_xme05    date,                    /*审核时间                               */
tc_xme06    varchar2(4),             /*税种                                   */
tc_xme07    varchar2(1),
tc_xmeacti  varchar2(1)
);

create unique index tic_xme_01 on tc_xme_file (tc_xme00);
alter table tc_xme_file add  constraint tpc_xme_pk primary key  (tc_xme00) enable validate;
grant select on tc_xme_file to tiptopgp;
grant update on tc_xme_file to tiptopgp;
grant delete on tc_xme_file to tiptopgp;
grant insert on tc_xme_file to tiptopgp;
grant index on tc_xme_file to public;
grant select on tc_xme_file to ods;
