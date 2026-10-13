/*
================================================================================
檔案代號:idv_file
檔案名稱:ICD制造通知单单身档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idv_file
(
idv01       varchar2(16) DEFAULT ' ' NOT NULL, /*制造通知单号*/
idv02       number(5) DEFAULT '0' NOT NULL, /*项次*/
idv03       varchar2(40),            /*生产料号                               */
idv04       date,                    /*预计生产完工日期                       */
idv09       varchar2(1) DEFAULT 'N' NOT NULL, /*结案否*/
idv11       varchar2(16),            /*工单号码                               */
idv12       varchar2(1) DEFAULT '1' NOT NULL, /*生产型态*/
idv13       varchar2(40),            /*发料料号                               */
idv14       varchar2(10),            /*仓库                                   */
idv15       varchar2(10),            /*库位                                   */
idv16       varchar2(24),            /*批号                                   */
idv17       varchar2(4),             /*单位一                                 */
idv18       number(15,3) DEFAULT '0' NOT NULL, /*单位一数量*/
idv19       varchar2(4),             /*单位二                                 */
idv20       number(15,3),            /*单位二数量                             */
idv21       varchar2(10),            /*作业编号                               */
idv22       varchar2(10),            /*工艺编号                               */
idv23       varchar2(40),            /*DATECODE                               */
idv24       varchar2(24),            /*回货批号                               */
idv25       varchar2(4),             /*生产单位                               */
idv26       number(15,3) DEFAULT '0' NOT NULL, /*生产数量*/
idv27       varchar2(4),             /*生产参考单位                           */
idv28       number(15,3),            /*生产参考数量                           */
idv29       varchar2(10),            /*下阶段厂商                             */
idv30       varchar2(255),           /*备注                                   */
idv31       varchar2(40),            /*项目编号                               */
idv32       varchar2(30),            /*WBS编号                                */
idvlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
idvplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属营运中心*/
);

create unique index idv_01 on idv_file (idv01,idv02);
alter table idv_file add  constraint idv_pk primary key  (idv01,idv02) enable validate;
grant select on idv_file to tiptopgp;
grant update on idv_file to tiptopgp;
grant delete on idv_file to tiptopgp;
grant insert on idv_file to tiptopgp;
grant index on idv_file to public;
grant select on idv_file to ods;
