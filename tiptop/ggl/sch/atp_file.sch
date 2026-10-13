/*
================================================================================
檔案代號:atp_file
檔案名稱:股东权益列印报表格式
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atp_file
(
atp00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
atp01       varchar2(6) DEFAULT ' ' NOT NULL, /*报表编号*/
atp02       varchar2(80),            /*报表名称                               */
atp03       number(10) DEFAULT '0' NOT NULL, /*顺序*/
atp04       varchar2(10),            /*群组编号                               */
atp05       varchar2(80),            /*说明                                   */
atp06       varchar2(1),             /*no use                                 */
atp07       varchar2(1),             /*no use                                 */
atp08       varchar2(1),             /*no use                                 */
atp09       varchar2(1) DEFAULT ' ' NOT NULL, /*打印码*/
atp10       varchar2(1) DEFAULT ' ' NOT NULL, /*资料来源*/
atp11       number(5) DEFAULT '0' NOT NULL, /*空格数*/
atp12       varchar2(1) DEFAULT ' ' NOT NULL /*资料来源码*/
);

alter table atp_file add  constraint atp_pk primary key  (atp00,atp01,atp03) enable validate;
grant select on atp_file to tiptopgp;
grant update on atp_file to tiptopgp;
grant delete on atp_file to tiptopgp;
grant insert on atp_file to tiptopgp;
grant index on atp_file to public;
grant select on atp_file to ods;
