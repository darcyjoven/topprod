/*
================================================================================
檔案代號:vmk_file
檔案名稱:APS料件供应商维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vmk_file
(
vmk01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vmk02       varchar2(10) DEFAULT ' ' NOT NULL, /*供应商编号*/
vmk05       number(18,8),            /*最大采购量                             */
vmk10       number(18,8),            /*变动采购前置时间                       */
vmk11       number(18,8),            /*变动天数的基本数量                     */
vmk12       number(1),               /*合并尾批                               */
vmk13       number(18,8),            /*并单之判断比率                         */
vmk15       number(1),               /*批量开立规则                           */
vmk16       number(18,8),            /*关键料软性前置时间                     */
vmk17       number(18,8),            /*关键料软性变动前置时间                 */
vmk19       varchar2(1) DEFAULT '1' NOT NULL, /*供货商型态(1采购, 2委外)*/
vmk20       number(18,8),            /*最少采购数量                           */
vmk21       number(18,8)             /*采购单位批量                           */
);

alter table vmk_file add  constraint vmk_pk primary key  (vmk01,vmk02,vmk19) enable validate;
grant select on vmk_file to tiptopgp;
grant update on vmk_file to tiptopgp;
grant delete on vmk_file to tiptopgp;
grant insert on vmk_file to tiptopgp;
grant index on vmk_file to public;
grant select on vmk_file to ods;
