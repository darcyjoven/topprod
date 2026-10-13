/*
================================================================================
檔案代號:ogk_file
檔案名稱:销退单身税别资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogk_file
(
ogk01       varchar2(20) DEFAULT ' ' NOT NULL, /*销退单号*/
ogk02       number(5) DEFAULT '0' NOT NULL, /*项次*/
ogk03       number(5) DEFAULT '0' NOT NULL, /*序号*/
ogk04       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
ogk05       number(9,4) DEFAULT '0', /*税率                                   */
ogk06       number(20,6) DEFAULT '0',/*固定税额                               */
ogk07       varchar2(1),             /*含税否                                 */
ogk08       number(20,6) DEFAULT '0',/*税前金额                               */
ogk08t      number(20,6) DEFAULT '0',/*含税金额                               */
ogk09       number(20,6) DEFAULT '0',/*税额                                   */
ogkdate     date,                    /*最近更改日                             */
ogkgrup     varchar2(10),            /*资料所有部门                           */
ogklegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogkmodu     varchar2(10),            /*资料更改者                             */
ogkorig     varchar2(10),            /*资料建立部门                           */
ogkoriu     varchar2(10),            /*资料建立者                             */
ogkplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogkuser     varchar2(10)             /*资料所有者                             */
);

create unique index ogk_01 on ogk_file (ogk01,ogk02,ogk03);
alter table ogk_file add  constraint ogk_pk primary key  (ogk01,ogk02,ogk03) enable validate;
grant select on ogk_file to tiptopgp;
grant update on ogk_file to tiptopgp;
grant delete on ogk_file to tiptopgp;
grant insert on ogk_file to tiptopgp;
grant index on ogk_file to public;
grant select on ogk_file to ods;
