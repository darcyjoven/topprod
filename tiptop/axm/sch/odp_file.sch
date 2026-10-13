/*
================================================================================
檔案代號:odp_file
檔案名稱:客户订货档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table odp_file
(
odp01       varchar2(10) DEFAULT ' ' NOT NULL, /*訂購會編號*/
odp02       varchar2(10) DEFAULT ' ' NOT NULL, /*客户编号*/
odp03       varchar2(10),            /*手册编号                               */
odp04       number(5),               /*页码                                   */
odp05       varchar2(10),            /*行数                                   */
odp06       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
odp07       varchar2(40) DEFAULT ' ' NOT NULL,
odp08       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
odp09       number(15,3) DEFAULT '0' NOT NULL, /*标准单价*/
odp10       number(15,3) DEFAULT '0' NOT NULL,
odp11       varchar2(1) DEFAULT 'N' NOT NULL, /*审核码*/
odp12       varchar2(40) DEFAULT ' ' NOT NULL,
odp00       varchar2(20) DEFAULT ' ' NOT NULL, /*订货编号*/
odp13       varchar2(1) DEFAULT '1' NOT NULL, /*订货性质（1.期货2.现货）*/
odp14       varchar2(20)             /*订货确认编号                           */
);

alter table odp_file add  constraint odp_pk primary key  (odp00,odp01,odp02,odp06,odp07,odp12) enable validate;
grant select on odp_file to tiptopgp;
grant update on odp_file to tiptopgp;
grant delete on odp_file to tiptopgp;
grant insert on odp_file to tiptopgp;
grant index on odp_file to public;
grant select on odp_file to ods;
