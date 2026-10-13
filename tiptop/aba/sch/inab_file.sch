/*
================================================================================
檔案代號:inab_file
檔案名稱:条码杂收发单头档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table inab_file
(
inab00      varchar2(1) DEFAULT '1' NOT NULL, /*异动类型*/
inab01      varchar2(20) DEFAULT ' ' NOT NULL, /*异动单号*/
inab02      date,                    /*扣帐日期                               */
inab03      date,                    /*录入日期                               */
inab04      varchar2(10),            /*人员                                   */
inab05      varchar2(10),            /*部门                                   */
inab06      varchar2(40),            /*参考单号                               */
inab07      varchar2(255),           /*备注                                   */
inabcond    date,                    /*审核日期                               */
inabconf    varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
inabcont    varchar2(8),             /*审核时间                               */
inabconu    varchar2(10),            /*审核人员                               */
inabdate    date,                    /*最近更改日                             */
inabgrup    varchar2(10),            /*资料所有群                             */
inablegal   varchar2(10) DEFAULT ' ' NOT NULL,
inabmodu    varchar2(10),
inaborig    varchar2(10),
inaboriu    varchar2(10),
inabplant   varchar2(10) DEFAULT ' ' NOT NULL,
inabpost    varchar2(1) DEFAULT ' ' NOT NULL,
inabud01    varchar2(255),
inabud02    varchar2(40),
inabud03    varchar2(40),
inabud04    varchar2(40),
inabud05    varchar2(40),
inabud06    varchar2(40),
inabud07    number(15,3),
inabud08    number(15,3),
inabud09    number(15,3),
inabud10    number(10),
inabud11    number(10),
inabud12    number(10),
inabud13    date,
inabud14    date,
inabud15    date,
inabuser    varchar2(10)
);

alter table inab_file add  constraint inab_pk primary key  (inab01) enable validate;
grant select on inab_file to tiptopgp;
grant update on inab_file to tiptopgp;
grant delete on inab_file to tiptopgp;
grant insert on inab_file to tiptopgp;
grant index on inab_file to public;
grant select on inab_file to ods;
