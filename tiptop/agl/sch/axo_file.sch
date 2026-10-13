/*
================================================================================
檔案代號:axo_file
檔案名稱:股东权益揭露事项维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axo_file
(
axo01       number(5) NOT NULL,      /*年度                                   */
axo02       number(5) NOT NULL,      /*月份                                   */
axo03       varchar2(8),             /*No Use                                 */
axo04       number(20,6),            /*异动金额                               */
axo05       varchar2(1),             /*No Use                                 */
axo06       number(20,6),            /*No Use                                 */
axo07       varchar2(1),             /*No Use                                 */
axo08       varchar2(1),             /*No Use                                 */
axo09       varchar2(1),             /*No Use                                 */
axo10       varchar2(1),             /*No Use                                 */
axouser     varchar2(10),            /*资料所有者                             */
axogrup     varchar2(10),            /*资料所有部门                           */
axomodu     varchar2(10),            /*资料更改者                             */
axodate     date,                    /*最近更改日                             */
axo11       varchar2(10) NOT NULL,   /*公司编号                               */
axo12       varchar2(5) NOT NULL,    /*帐套                                   */
axo13       varchar2(4) NOT NULL,    /*币种                                   */
axo14       varchar2(10) NOT NULL,   /*分类代码                               */
axo15       varchar2(10) NOT NULL,   /*群组代码                               */
axoorig     varchar2(10),            /*资料建立部门                           */
axooriu     varchar2(10),            /*资料建立者                             */
axo16       varchar2(1) DEFAULT 'N' NOT NULL, /*合并*/
axolegal    varchar2(10) DEFAULT ' ' NOT NULL /*所属法人*/
);

alter table axo_file add  constraint axo_pk primary key  (axo01,axo02,axo11,axo12,axo13,axo14,axo15,axo16) enable validate;
grant select on axo_file to tiptopgp;
grant update on axo_file to tiptopgp;
grant delete on axo_file to tiptopgp;
grant insert on axo_file to tiptopgp;
grant index on axo_file to public;
grant select on axo_file to ods;
