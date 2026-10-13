/*
================================================================================
檔案代號:ahi_file
檔案名稱:利润中心内部定价档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ahi_file
(
ahi01       number(5) NOT NULL,      /*年度                                   */
ahi02       number(5) NOT NULL,      /*期别                                   */
ahi03       varchar2(40) NOT NULL,   /*料号                                   */
ahi04       number(20,6) DEFAULT '0',/*成本单价  by ima25                     */
ahi05       number(20,6) DEFAULT '0',/*内部单价 by ima25                      */
ahi06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ahi07       varchar2(40) DEFAULT ' ' NOT NULL /*类别代号(批次号/专案号/利润 */
);

alter table ahi_file add  constraint ahi_pk primary key  (ahi01,ahi02,ahi03,ahi06,ahi07) enable validate;
grant select on ahi_file to tiptopgp;
grant update on ahi_file to tiptopgp;
grant delete on ahi_file to tiptopgp;
grant insert on ahi_file to tiptopgp;
grant index on ahi_file to public;
grant select on ahi_file to ods;
