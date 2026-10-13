/*
================================================================================
檔案代號:atr_file
檔案名稱:股东权益揭露事项维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atr_file
(
atr01       number(5) DEFAULT '0' NOT NULL, /*年度*/
atr02       number(5) DEFAULT '0' NOT NULL, /*月份*/
atr03       varchar2(8),             /*NO USE                                 */
atr04       number(20,6) DEFAULT '0' NOT NULL, /*异动金额*/
atr05       varchar2(1),             /*NO USE                                 */
atr06       number(20,6) DEFAULT '0' NOT NULL, /*NO USE*/
atr07       varchar2(1),             /*NO USE                                 */
atr08       varchar2(1),             /*NO USE                                 */
atr09       varchar2(1),             /*NO USE                                 */
atr10       varchar2(1),             /*NO USE                                 */
atr11       varchar2(10) DEFAULT ' ' NOT NULL, /*公司代码*/
atr12       varchar2(5) DEFAULT ' ' NOT NULL, /*帐套*/
atr13       varchar2(4) DEFAULT ' ' NOT NULL, /*币种*/
atr14       varchar2(10) DEFAULT ' ' NOT NULL, /*分类编号*/
atr15       varchar2(10) DEFAULT ' ' NOT NULL, /*群组编号*/
atr16       varchar2(1) DEFAULT ' ' NOT NULL, /*合并*/
atrdate     date,                    /*最近更改日                             */
atrgrup     varchar2(10),            /*资料所有群                             */
atrmodu     varchar2(10),            /*资料更改者                             */
atrorig     varchar2(10),            /*资料建立部门                           */
atroriu     varchar2(10),            /*资料建立者                             */
atruser     varchar2(10)             /*资料所有者                             */
);

alter table atr_file add  constraint atr_pk primary key  (atr01,atr02,atr11,atr12,atr13,atr14,atr15) enable validate;
grant select on atr_file to tiptopgp;
grant update on atr_file to tiptopgp;
grant delete on atr_file to tiptopgp;
grant insert on atr_file to tiptopgp;
grant index on atr_file to public;
grant select on atr_file to ods;
