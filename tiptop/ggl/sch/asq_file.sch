/*
================================================================================
檔案代號:asq_file
檔案名稱:会计科目对冲关系档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table asq_file
(
asq00       varchar2(5) DEFAULT ' ' NOT NULL, /*来源帐套*/
asq01       varchar2(24) DEFAULT ' ' NOT NULL, /*来源会计科目编号*/
asq02       varchar2(24) DEFAULT ' ' NOT NULL, /*对冲会计科目编号*/
asq03       varchar2(1) DEFAULT 'N' NOT NULL, /*比率否*/
asq04       varchar2(24),            /*差额对应科目编号                       */
asq05       varchar2(1),             /*no use                                 */
asq06       varchar2(1),             /*no use                                 */
asq07       varchar2(1),             /*no use                                 */
asq08       varchar2(1),             /*no use                                 */
asq09       varchar2(10) DEFAULT ' ' NOT NULL, /*来源公司编号*/
asq10       varchar2(10) DEFAULT ' ' NOT NULL, /*对冲公司编号*/
asq12       varchar2(5) DEFAULT ' ' NOT NULL, /*对冲帐套*/
asq13       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
asq14       varchar2(1) DEFAULT ' ' NOT NULL, /*股本冲销*/
asq15       varchar2(1) DEFAULT '1' NOT NULL, /*科目余额来源*/
asq16       varchar2(10) DEFAULT ' ' NOT NULL, /*合并主题*/
asq17       varchar2(1) DEFAULT '1' NOT NULL, /*对冲目的公司科目余额来源档 */
asqacti     varchar2(1) DEFAULT 'Y' NOT NULL, /*资料有效码*/
asqdate     date,                    /*最近更改日                             */
asqgrup     varchar2(10),            /*资料所有群                             */
asqmodu     varchar2(10),            /*资料更改者                             */
asqorig     varchar2(10),            /*资料建立部门                           */
asqoriu     varchar2(10),            /*资料建立者                             */
asquser     varchar2(10),            /*资料所有者                             */
asq18       varchar2(1) DEFAULT ' ' NOT NULL /*差额处理方式*/
);

alter table asq_file add  constraint asq_pk primary key  (asq00,asq01,asq02,asq09,asq10,asq12,asq13,asq16) enable validate;
grant select on asq_file to tiptopgp;
grant update on asq_file to tiptopgp;
grant delete on asq_file to tiptopgp;
grant insert on asq_file to tiptopgp;
grant index on asq_file to public;
grant select on asq_file to ods;
