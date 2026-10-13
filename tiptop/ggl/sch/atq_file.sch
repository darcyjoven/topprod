/*
================================================================================
檔案代號:atq_file
檔案名稱:股东权益期初导入余额档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table atq_file
(
atq01       number(5) DEFAULT '0' NOT NULL, /*年度*/
atq02       number(5) DEFAULT '0' NOT NULL, /*月份*/
atq03       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq04       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq05       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq06       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq07       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq08       number(20,6) DEFAULT '0' NOT NULL, /*变动分类*/
atq09       number(20,6) DEFAULT '0' NOT NULL, /*合计*/
atq10       varchar2(1),             /*no use                                 */
atq11       varchar2(1),             /*no use                                 */
atq12       varchar2(1),             /*no use                                 */
atq13       number(15,3) DEFAULT '0' NOT NULL, /*变动分类*/
atq14       varchar2(10) DEFAULT ' ' NOT NULL, /*公司编号*/
atq15       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
atq16       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atq17       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
atq18       number(20,6) DEFAULT '0' NOT NULL, /*余额*/
atq19       varchar2(10) DEFAULT ' ' NOT NULL, /*群组代码*/
atq20       varchar2(1) DEFAULT 'N' NOT NULL, /*合并*/
atqdate     date,                    /*最近更改日                             */
atqgrup     varchar2(10),            /*资料所有群                             */
atqlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
atqmodu     varchar2(10),            /*资料更改者                             */
atqorig     varchar2(10),            /*资料建立部门                           */
atqoriu     varchar2(10),            /*资料建立者                             */
atquser     varchar2(10)             /*资料所有者                             */
);

alter table atq_file add  constraint atq_pk primary key  (atq01,atq02,atq14,atq15,atq16,atq17,atq19) enable validate;
grant select on atq_file to tiptopgp;
grant update on atq_file to tiptopgp;
grant delete on atq_file to tiptopgp;
grant insert on atq_file to tiptopgp;
grant index on atq_file to public;
grant select on atq_file to ods;
