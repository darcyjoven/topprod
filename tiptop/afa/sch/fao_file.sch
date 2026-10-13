/*
================================================================================
檔案代號:fao_file
檔案名稱:税签折旧费用各期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table fao_file
(
fao01       varchar2(10) NOT NULL,   /*财产编号                               */
fao02       varchar2(4) NOT NULL,    /*附号                                   */
fao03       number(5) NOT NULL,      /*折旧年度                               */
fao04       number(5) NOT NULL,      /*折旧期别                               */
fao041      varchar2(1) NOT NULL,    /*来源                                   */
fao05       varchar2(1) NOT NULL,    /*分摊方式                               */
fao06       varchar2(10) NOT NULL,   /*保管部门                               */
fao07       number(20,6),            /*折旧金额                               */
fao08       number(20,6),            /*本期累折                               */
fao09       varchar2(10),            /*被分摊部门                             */
                                     /*No use                                 */
fao10       varchar2(1),             /*资产状态                               */
fao11       varchar2(24),            /*资产会计科目                           */
fao12       varchar2(24),            /*折旧会计科目                           */
fao13       varchar2(10),            /*分摊类型                               */
fao14       number(20,6),            /*成本                                   */
fao15       number(20,6),            /*累折                                   */
fao16       number(9,4),             /*分摊比率                               */
fao17       number(20,6),            /*已计提减值准备                         */
fao18       number(15,2),            /*No Use                                 */
fao111      varchar2(24),            /*资产会计科目二                         */
fao121      varchar2(24),            /*折旧会计科目二                         */
faolegal    varchar2(10) NOT NULL,   /*所属法人                               */
fao20       varchar2(24),            /*累折科目                               */
fao201      varchar2(24)             /*累折科目二                             */
);

alter table fao_file add  constraint fao_pk primary key  (fao01,fao02,fao03,fao04,fao041,fao05,fao06) enable validate;
grant select on fao_file to tiptopgp;
grant update on fao_file to tiptopgp;
grant delete on fao_file to tiptopgp;
grant insert on fao_file to tiptopgp;
grant index on fao_file to public;
grant select on fao_file to ods;
