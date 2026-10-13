/*
================================================================================
檔案代號:xme_file
檔案名稱:产品价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table xme_file
(
xme01       varchar2(6) NOT NULL,    /*价格条件编号                           */
                                     /*價格條件編號                           */
xme02       varchar2(4) NOT NULL,    /*币种                                   */
                                     /*幣別                                   */
xme03       number(5),               /*No Use                                 */
xme04       date,                    /*No Use                                 */
xme05       varchar2(10),            /*No Use                                 */
xme06       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
xmeuser     varchar2(10),            /*资料所有者                             */
xmegrup     varchar2(10),            /*资料所有部门                           */
xmemodu     varchar2(10),            /*资料更改者                             */
xmedate     date,                    /*最近更改日                             */
xmeoriu     varchar2(10),            /*资料建立者                             */
xmeorig     varchar2(10),            /*资料建立部门                           */
xme00       varchar2(1) DEFAULT ' ' NOT NULL, /*单据性质*/
ta_xme01    varchar2(4) NOT NULL     /*税种码                                 */
);

alter table xme_file add  constraint xme_pk primary key  (xme01,xme02,xme00,ta_xme01) enable validate;
grant select on xme_file to tiptopgp;
grant update on xme_file to tiptopgp;
grant delete on xme_file to tiptopgp;
grant insert on xme_file to tiptopgp;
grant index on xme_file to public;
grant select on xme_file to ods;
