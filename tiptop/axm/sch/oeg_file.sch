/*
================================================================================
檔案代號:oeg_file
檔案名稱:订单单身税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oeg_file
(
oeg01       varchar2(20) DEFAULT ' ' NOT NULL, /*订单单号*/
oeg02       number(5) DEFAULT '0' NOT NULL, /*项次*/
oeg03       number(5) DEFAULT '0' NOT NULL, /*序号*/
oeg04       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
oeg05       number(9,4) DEFAULT '0', /*税率                                   */
oeg06       number(20,6) DEFAULT '0',/*固定税额                               */
oeg07       varchar2(1),             /*含税否                                 */
oeg08       number(20,6) DEFAULT '0',/*税前金额                               */
oeg08t      number(20,6) DEFAULT '0',/*含税金额                               */
oeg09       number(20,6) DEFAULT '0',/*税额                                   */
oegdate     date,                    /*最近更改日                             */
oeggrup     varchar2(10),            /*资料所有部门                           */
oeglegal    varchar2(10) NOT NULL,   /*所属法人                               */
oegmodu     varchar2(10),            /*资料更改者                             */
oegorig     varchar2(10),            /*资料建立部门                           */
oegoriu     varchar2(10),            /*资料建立者                             */
oegplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeguser     varchar2(10)             /*资料所有者                             */
);

create unique index oeg_01 on oeg_file (oeg01,oeg02,oeg03);
alter table oeg_file add  constraint oeg_pk primary key  (oeg01,oeg02,oeg03) enable validate;
grant select on oeg_file to tiptopgp;
grant update on oeg_file to tiptopgp;
grant delete on oeg_file to tiptopgp;
grant insert on oeg_file to tiptopgp;
grant index on oeg_file to public;
grant select on oeg_file to ods;
