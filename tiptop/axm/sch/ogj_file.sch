/*
================================================================================
檔案代號:ogj_file
檔案名稱:销退单实际交易税别明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ogj_file
(
ogj01       varchar2(20) DEFAULT ' ' NOT NULL, /*销退单号*/
ogj02       number(5) DEFAULT '0' NOT NULL, /*序号*/
ogj03       varchar2(4) DEFAULT ' ' NOT NULL, /*税种*/
ogj04       number(9,4) DEFAULT '0', /*税率                                   */
ogj05       number(20,6) DEFAULT '0',/*固定税额                               */
ogj06       varchar2(1),             /*含税否                                 */
ogj07       number(20,6) DEFAULT '0',/*税前金额                               */
ogj07t      number(20,6) DEFAULT '0',/*含税金额                               */
ogj08       number(20,6) DEFAULT '0',/*税额                                   */
ogj09       number(20,6) DEFAULT '0',/*留抵税额                               */
ogjdate     date,                    /*最近更改日                             */
ogjgrup     varchar2(10),            /*资料所有部门                           */
ogjlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ogjmodu     varchar2(10),            /*资料更改者                             */
ogjorig     varchar2(10),            /*资料建立部门                           */
ogjoriu     varchar2(10),            /*资料建立者                             */
ogjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ogjuser     varchar2(10)             /*资料所有者                             */
);

create unique index ogj_01 on ogj_file (ogj01,ogj02);
alter table ogj_file add  constraint ogj_pk primary key  (ogj01,ogj02) enable validate;
grant select on ogj_file to tiptopgp;
grant update on ogj_file to tiptopgp;
grant delete on ogj_file to tiptopgp;
grant insert on ogj_file to tiptopgp;
grant index on ogj_file to public;
grant select on ogj_file to ods;
