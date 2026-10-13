/*
================================================================================
檔案代號:cao_file
檔案名稱:库龄开账资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cao_file
(
cao01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
cao02       date NOT NULL,           /*日期                                   */
cao03       number(15,3),            /*数量                                   */
caoacti     varchar2(1),             /*资料有效码                             */
caodate     date,                    /*最近更改日                             */
caogrup     varchar2(10),            /*资料所有部门                           */
caomodu     varchar2(10),            /*资料更改者                             */
caouser     varchar2(10),            /*资料所有者                             */
caolegal    varchar2(10) NOT NULL,   /*所属法人                               */
caooriu     varchar2(10),            /*资料建立者                             */
caoorig     varchar2(10),            /*资料建立部门                           */
cao07       varchar2(1) DEFAULT '1' NOT NULL, /*成本计算类型*/
cao08       varchar2(40) DEFAULT ' ' NOT NULL /*类别代号(批次号/专案号/利润 */
);

alter table cao_file add  constraint cao_pk primary key  (cao01,cao02,cao07,cao08) enable validate;
grant select on cao_file to tiptopgp;
grant update on cao_file to tiptopgp;
grant delete on cao_file to tiptopgp;
grant insert on cao_file to tiptopgp;
grant index on cao_file to public;
grant select on cao_file to ods;
