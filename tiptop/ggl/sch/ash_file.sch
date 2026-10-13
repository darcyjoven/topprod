/*
================================================================================
檔案代號:ash_file
檔案名稱:合并财报会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ash_file
(
ash00       varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ash01       varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
ash02       varchar2(10),            /*NO USE                                 */
ash021      varchar2(20),            /*NO USE                                 */
ash03       varchar2(20),            /*NO USE                                 */
ash04       varchar2(24) DEFAULT ' ' NOT NULL, /*来源营运中心会计科目*/
ash05       varchar2(120),           /*来源营运中心会计科目名称               */
ash06       varchar2(24),            /*合并后财报会计科目编号                 */
ash07       varchar2(1),             /*NO USE                                 */
ash08       varchar2(1),             /*NO USE                                 */
ash09       varchar2(1),             /*NO USE                                 */
ash10       varchar2(1),             /*NO USE                                 */
ash11       varchar2(1),             /*再衡量汇率类型                         */
ash12       varchar2(1),             /*换算汇率类型                           */
ash13       varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
ashacti     varchar2(1),             /*资料有效码                             */
ashdate     date,                    /*最近更改日                             */
ashgrup     varchar2(10),            /*资料所有群                             */
ashmodu     varchar2(10),            /*资料更改者                             */
ashorig     varchar2(10),            /*资料建立部门                           */
ashoriu     varchar2(10),            /*资料建立者                             */
ashuser     varchar2(10)             /*资料所有者                             */
);

alter table ash_file add  constraint ash_pk primary key  (ash00,ash01,ash04,ash13) enable validate;
grant select on ash_file to tiptopgp;
grant update on ash_file to tiptopgp;
grant delete on ash_file to tiptopgp;
grant insert on ash_file to tiptopgp;
grant index on ash_file to public;
grant select on ash_file to ods;
