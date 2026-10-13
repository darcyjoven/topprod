/*
================================================================================
檔案代號:ogi_file
檔案名稱:出货单身税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogi_file
(
ogi01       varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
ogi02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ogi03       number(5) DEFAULT '0' NOT NULL, /*序号*/
ogi04       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
ogi05       number(9,4) DEFAULT '0', /*税率                                   */
ogi06       number(20,6) DEFAULT '0',/*固定税额                               */
ogi07       varchar2(1),             /*含税否                                 */
ogi08       number(20,6) DEFAULT '0',/*税前金额                               */
ogi08t      number(20,6) DEFAULT '0',/*含税金额                               */
ogi09       number(20,6) DEFAULT '0',/*税额                                   */
ogidate     date,                    /*最近更改日                             */
ogigrup     varchar2(10),            /*资料所有部门                           */
ogilegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogimodu     varchar2(10),            /*资料更改者                             */
ogiorig     varchar2(10),            /*资料建立部门                           */
ogioriu     varchar2(10),            /*资料建立者                             */
ogiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogiuser     varchar2(10)             /*资料所有者                             */
);

create unique index ogi_01 on ogi_file (ogi01,ogi02,ogi03);
alter table ogi_file add  constraint ogi_pk primary key  (ogi01,ogi02,ogi03) enable validate;
grant select on ogi_file to tiptopgp;
grant update on ogi_file to tiptopgp;
grant delete on ogi_file to tiptopgp;
grant insert on ogi_file to tiptopgp;
grant index on ogi_file to public;
grant select on ogi_file to ods;
