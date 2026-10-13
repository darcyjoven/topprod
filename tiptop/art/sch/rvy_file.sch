/*
================================================================================
檔案代號:rvy_file
檔案名稱:产品策略税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rvy_file
(
rvy01       varchar2(10) DEFAULT ' ' NOT NULL, /*产品策略编号*/
rvy02       number(10) DEFAULT '0' NOT NULL, /*项次*/
rvy03       number(5) DEFAULT '0' NOT NULL, /*序号*/
rvy04       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
rvy05       varchar2(1) DEFAULT '2' NOT NULL, /*进/销项*/
rvy06       number(20,6) DEFAULT '0',/*固定税额                               */
rvydate     date,                    /*最近更改日                             */
rvygrup     varchar2(10),            /*资料所有部门                           */
rvymodu     varchar2(10),            /*资料更改者                             */
rvyorig     varchar2(10),            /*资料建立部门                           */
rvyoriu     varchar2(10),            /*资料建立者                             */
rvyuser     varchar2(10)             /*资料所有者                             */
);

create unique index rvy_01 on rvy_file (rvy01,rvy02,rvy03);
alter table rvy_file add  constraint rvy_pk primary key  (rvy01,rvy02,rvy03) enable validate;
grant select on rvy_file to tiptopgp;
grant update on rvy_file to tiptopgp;
grant delete on rvy_file to tiptopgp;
grant insert on rvy_file to tiptopgp;
grant index on rvy_file to public;
grant select on rvy_file to ods;
