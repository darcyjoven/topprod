/*
================================================================================
檔案代號:qco_file
檔案名稱:QC料件判断结果资料档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table qco_file
(
qco01       varchar2(20) DEFAULT ' ' NOT NULL, /*来源单号*/
qco02       number(5) DEFAULT '0' NOT NULL, /*来源项次*/
qco03       varchar2(10),            /*判定结果编码                           */
qco04       number(5) DEFAULT '0' NOT NULL, /*项次*/
qco05       number(5) DEFAULT '0' NOT NULL, /*检验批号*/
qco06       varchar2(40),            /*料件编号                               */
qco07       varchar2(10),            /*仓库                                   */
qco08       varchar2(10),            /*库位                                   */
qco09       varchar2(24),            /*批号                                   */
qco10       varchar2(4),             /*单位                                   */
qco11       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
qco12       number(20,8),            /*单位换算率(与库存单位)                 */
qco13       varchar2(4),             /*单位一                                 */
qco14       number(20,8),            /*单位一换算率(与库存单位)               */
qco15       number(15,3) DEFAULT '0' NOT NULL, /*单位一数量*/
qco16       varchar2(4),             /*单位二                                 */
qco17       number(20,8),            /*单位二换算率(与库存单位)               */
qco18       number(15,3) DEFAULT '0' NOT NULL, /*单位二数量*/
qco19       number(20,8),            /*对成品转换率                           */
qco20       number(15,3) DEFAULT '0' NOT NULL /*已转入库量*/
);

alter table qco_file add  constraint qco_pk primary key  (qco01,qco02,qco04,qco05) enable validate;
grant select on qco_file to tiptopgp;
grant update on qco_file to tiptopgp;
grant delete on qco_file to tiptopgp;
grant insert on qco_file to tiptopgp;
grant index on qco_file to public;
grant select on qco_file to ods;
