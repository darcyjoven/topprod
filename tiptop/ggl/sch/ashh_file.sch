/*
================================================================================
檔案代號:ashh_file
檔案名稱:合并后财报会计科目
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ashh_file
(
ashh00      varchar2(5) DEFAULT ' ' NOT NULL, /*帐别*/
ashh01      varchar2(10) DEFAULT ' ' NOT NULL, /*上层公司编号*/
ashh02      varchar2(1),             /*NO USE                                 */
ashh021     varchar2(1),             /*NO USE                                 */
ashh03      varchar2(1),             /*NO USE                                 */
ashh04      varchar2(24) DEFAULT ' ' NOT NULL, /*来源营运中心会计科目编号*/
ashh05      varchar2(120),           /*来源营运中心会计科目名称               */
ashh06      varchar2(24),            /*合并后财报会计科目编号                 */
ashh07      varchar2(1),             /*NO USE                                 */
ashh08      varchar2(1),             /*NO USE                                 */
ashh09      varchar2(1),             /*NO USE                                 */
ashh10      varchar2(1),             /*NO USE                                 */
ashh11      varchar2(1),             /*再衡量汇率类型                         */
ashh12      varchar2(1),             /*换算汇率类型                           */
ashh13      varchar2(10) DEFAULT ' ' NOT NULL, /*族群编号*/
ashhacti    varchar2(1),             /*资料有效码                             */
ashhdate    date,                    /*最近更改日                             */
ashhgrup    varchar2(10),            /*资料所有群                             */
ashhmodu    varchar2(10),            /*资料更改者                             */
ashhorig    varchar2(10),            /*资料建立部门                           */
ashhoriu    varchar2(10),            /*资料建立者                             */
ashhuser    varchar2(10)             /*资料所有者                             */
);

alter table ashh_file add  constraint ashh_pk primary key  (ashh00,ashh01,ashh04,ashh13) enable validate;
grant select on ashh_file to tiptopgp;
grant update on ashh_file to tiptopgp;
grant delete on ashh_file to tiptopgp;
grant insert on ashh_file to tiptopgp;
grant index on ashh_file to public;
grant select on ashh_file to ods;
