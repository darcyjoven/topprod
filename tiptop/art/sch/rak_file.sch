/*
================================================================================
檔案代號:rak_file
檔案名稱:促销单生失效时段配置文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rak_file
(
rak01       varchar2(10) DEFAULT ' ' NOT NULL, /*制定營運中心*/
rak02       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单号*/
rak03       varchar2(1) DEFAULT ' ' NOT NULL, /*促销类型*/
rak04       number(5) DEFAULT '0' NOT NULL, /*组别*/
rak05       number(5) DEFAULT '0' NOT NULL,
rak06       date,                    /*促销开始日期                           */
rak07       date,                    /*促销结束日期                           */
rak08       varchar2(8),
rak09       varchar2(8),
rak10       varchar2(2),
rak11       varchar2(1) DEFAULT ' ' NOT NULL,
rakacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
rakcrdate   date,
rakdate     date,                    /*最近更改日                             */
rakgrup     varchar2(10),            /*资料所有群                             */
raklegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
rakmodu     varchar2(10),            /*资料更改者                             */
rakorig     varchar2(10),            /*资料建立部门                           */
rakoriu     varchar2(10),            /*资料建立者                             */
rakplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rakpos      varchar2(1) DEFAULT ' ' NOT NULL, /*已传POS否*/
rakuser     varchar2(10)             /*资料所有者                             */
);

alter table rak_file add  constraint rak_pk primary key  (rak01,rak02,rak03,rak04,rak05,rakplant) enable validate;
grant select on rak_file to tiptopgp;
grant update on rak_file to tiptopgp;
grant delete on rak_file to tiptopgp;
grant insert on rak_file to tiptopgp;
grant index on rak_file to public;
grant select on rak_file to ods;
