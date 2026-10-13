/*
================================================================================
檔案代號:axp_file
檔案名稱:外币换算汇率档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table axp_file
(
axp01       number(5) NOT NULL,      /*年度                                   */
axp02       number(5) NOT NULL,      /*期别                                   */
axp03       varchar2(4) NOT NULL,    /*来源币种                               */
axp04       varchar2(4) NOT NULL,    /*换算币种                               */
axp05       number(20,10),           /*现时汇率                               */
axp06       number(20,10),           /*历史汇率                               */
axp07       number(20,10),           /*平均汇率                               */
axp08       varchar2(10) NOT NULL,   /*公司编号                               */
axp09       varchar2(24) NOT NULL,   /*科目编号                               */
axpconf     varchar2(1),             /*审核否                                 */
axppost     varchar2(1),             /*更新否                                 */
axpacti     varchar2(1),             /*有效否                                 */
axpuser     varchar2(10),            /*资料所有者                             */
axpgrup     varchar2(10),            /*资料所有群                             */
axpmodu     varchar2(10),            /*资料更改者                             */
axpdate     date,                    /*最近更改日                             */
axporig     varchar2(10),            /*资料建立部门                           */
axporiu     varchar2(10)             /*资料建立者                             */
);

alter table axp_file add  constraint axp_pk primary key  (axp01,axp02,axp03,axp04,axp08,axp09) enable validate;
grant select on axp_file to tiptopgp;
grant update on axp_file to tiptopgp;
grant delete on axp_file to tiptopgp;
grant insert on axp_file to tiptopgp;
grant index on axp_file to public;
grant select on axp_file to ods;
