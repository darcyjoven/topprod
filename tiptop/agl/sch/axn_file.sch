/*
================================================================================
檔案代號:axn_file
檔案名稱:股东权益期初导入余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table axn_file
(
axn01       number(5) NOT NULL,      /*年度                                   */
axn02       number(5) NOT NULL,      /*月份                                   */
axn03       number(20,6),            /*变动分类                               */
axn04       number(20,6),            /*变动分类                               */
axn05       number(20,6),            /*变动分类                               */
axn06       number(20,6),            /*变动分类                               */
axn07       number(20,6),            /*变动分类                               */
                                     /*Variation Classification 5.Accumulated Conversion Adjust Qty  Balance*/
axn08       number(20,6),            /*变动分类                               */
                                     /*Variation Classification 6.Unputative Pension Cost Dead Loss  Balance*/
axn09       number(20,6),            /*合计                                   */
axn10       varchar2(1),             /*No Use                                 */
axn11       varchar2(1),             /*No Use                                 */
axn12       varchar2(1),             /*No Use                                 */
axnuser     varchar2(10),            /*资料所有者                             */
axngrup     varchar2(10),            /*资料所有部门                           */
axnmodu     varchar2(10),            /*资料更改者                             */
axndate     date,                    /*最近更改日                             */
axn13       number(15,3),            /*变动分类 7.少数股权  余额              */
axn14       varchar2(10) NOT NULL,   /*公司编号                               */
axn15       varchar2(5) NOT NULL,    /*帐套                                   */
axn16       varchar2(4) NOT NULL,    /*币种                                   */
axn17       varchar2(10) NOT NULL,   /*分类代码                               */
axn18       number(20,6),            /*余额                                   */
axnlegal    varchar2(10) NOT NULL,   /*所属法人                               */
axnorig     varchar2(10),            /*资料建立部门                           */
axnoriu     varchar2(10),            /*资料建立者                             */
axn19       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
axn20       varchar2(1) DEFAULT 'N' NOT NULL /*合并*/
);

alter table axn_file add  constraint axn_pk primary key  (axn01,axn02,axn14,axn15,axn16,axn17,axn19,axn20) enable validate;
grant select on axn_file to tiptopgp;
grant update on axn_file to tiptopgp;
grant delete on axn_file to tiptopgp;
grant insert on axn_file to tiptopgp;
grant index on axn_file to public;
grant select on axn_file to ods;
