/*
================================================================================
檔案代號:aej_file
檔案名稱:合併個體會計科目餘額檔
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table aej_file
(
aej00       varchar2(5) DEFAULT ' ' NOT NULL, /*集团帐套*/
aej01       varchar2(10) DEFAULT ' ' NOT NULL, /*集团代号*/
aej02       varchar2(10) DEFAULT ' ' NOT NULL, /*合併個體編號*/
aej03       varchar2(5) DEFAULT ' ' NOT NULL, /*合併個體帳別*/
aej04       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aej05       number(5) DEFAULT '0' NOT NULL, /*会计年度*/
aej06       number(5) DEFAULT '0' NOT NULL, /*期别*/
aej07       number(20,6) DEFAULT '0' NOT NULL, /*借方金额*/
aej08       number(20,6) DEFAULT '0' NOT NULL, /*贷方金额*/
aej09       number(10),              /*借方总笔数                             */
aej10       number(10),              /*贷方总笔数                             */
aej11       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
aejlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
aej12       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aej13       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aej14       varchar2(4),             /*no use                                 */
aej15       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aej16       number(20,6) DEFAULT '0' NOT NULL, /*no use*/
aej17       varchar2(4),             /*no use                                 */
aej18       varchar2(10) DEFAULT ' ' /*no use                                 */
);

alter table aej_file add  constraint aej_pk primary key  (aej00,aej01,aej02,aej03,aej04,aej05,aej06,aej11) enable validate;
grant select on aej_file to tiptopgp;
grant update on aej_file to tiptopgp;
grant delete on aej_file to tiptopgp;
grant insert on aej_file to tiptopgp;
grant index on aej_file to public;
grant select on aej_file to ods;
