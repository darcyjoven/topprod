/*
================================================================================
檔案代號:ase_file
檔案名稱:外币换算汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ase_file
(
ase01       number(5) DEFAULT '0' NOT NULL, /*年度*/
ase02       number(5) DEFAULT '0' NOT NULL, /*期别*/
ase03       varchar2(4) DEFAULT ' ' NOT NULL, /*来源币种*/
ase04       varchar2(4) DEFAULT ' ' NOT NULL, /*换算币种*/
ase05       number(20,10) DEFAULT '0' NOT NULL, /*现时汇率*/
ase06       number(20,10) DEFAULT '0' NOT NULL, /*历史汇率*/
ase07       number(20,10) DEFAULT '0' NOT NULL, /*平均汇率*/
ase08       varchar2(10) DEFAULT ' ' NOT NULL, /*公司代码*/
ase09       varchar2(24) DEFAULT ' ' NOT NULL, /*科目编号*/
aseacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
aseconf     varchar2(1) DEFAULT ' ' NOT NULL, /*审核否*/
asedate     date,                    /*最近更改日                             */
asegrup     varchar2(10),            /*资料所有群                             */
asemodu     varchar2(10),            /*资料更改者                             */
aseorig     varchar2(10),            /*资料建立部门                           */
aseoriu     varchar2(10),            /*资料建立者                             */
asepost     varchar2(1) DEFAULT ' ' NOT NULL, /*更新否*/
aseuser     varchar2(10)             /*资料所有者                             */
);

alter table ase_file add  constraint ase_pk primary key  (ase01,ase02,ase03,ase04,ase08,ase09) enable validate;
grant select on ase_file to tiptopgp;
grant update on ase_file to tiptopgp;
grant delete on ase_file to tiptopgp;
grant insert on ase_file to tiptopgp;
grant index on ase_file to public;
grant select on ase_file to ods;
