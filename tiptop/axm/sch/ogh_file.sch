/*
================================================================================
檔案代號:ogh_file
檔案名稱:出货单实际交易税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogh_file
(
ogh01       varchar2(20) DEFAULT ' ' NOT NULL, /*出货单号*/
ogh02       number(5) DEFAULT '0' NOT NULL, /*序号*/
ogh03       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
ogh04       number(9,4) DEFAULT '0', /*税率                                   */
ogh05       number(20,6) DEFAULT '0',/*固定税额                               */
ogh06       varchar2(1),             /*含税否                                 */
ogh07       number(20,6) DEFAULT '0',/*税前金额                               */
ogh07t      number(20,6) DEFAULT '0',/*含税金额                               */
ogh08       number(20,6) DEFAULT '0',/*税额                                   */
ogh09       number(20,6) DEFAULT '0',/*留抵税额                               */
oghdate     date,                    /*最近更改日                             */
oghgrup     varchar2(10),            /*资料所有部门                           */
oghlegal    varchar2(10) NOT NULL,   /*所属法人                               */
oghmodu     varchar2(10),            /*资料更改者                             */
oghorig     varchar2(10),            /*资料建立部门                           */
oghoriu     varchar2(10),            /*资料建立者                             */
oghplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oghuser     varchar2(10)             /*资料所有者                             */
);

create unique index ogh_01 on ogh_file (ogh01,ogh02);
alter table ogh_file add  constraint ogh_pk primary key  (ogh01,ogh02) enable validate;
grant select on ogh_file to tiptopgp;
grant update on ogh_file to tiptopgp;
grant delete on ogh_file to tiptopgp;
grant insert on ogh_file to tiptopgp;
grant index on ogh_file to public;
grant select on ogh_file to ods;
