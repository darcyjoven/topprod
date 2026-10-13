/*
================================================================================
檔案代號:fan_file
檔案名稱:折旧费用各期明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table fan_file
(
fan01       varchar2(10) NOT NULL,   /*财产编号                               */
fan02       varchar2(4) NOT NULL,    /*附号                                   */
fan03       number(5) NOT NULL,      /*折旧年度                               */
fan04       number(5) NOT NULL,      /*折旧期别                               */
fan041      varchar2(1) NOT NULL,    /*来源                                   */
fan05       varchar2(1) NOT NULL,    /*分摊方式                               */
fan06       varchar2(10) NOT NULL,   /*保管部门                               */
fan07       number(20,6),            /*折旧金额                               */
fan08       number(20,6),            /*本期累折                               */
fan09       varchar2(10),            /*被分摊部门                             */
fan10       varchar2(1),             /*资产状态                               */
fan11       varchar2(24),            /*资产会计科目                           */
fan12       varchar2(24),            /*折旧会计科目                           */
fan13       varchar2(10),            /*分摊类型                               */
fan14       number(20,6),            /*成本                                   */
fan15       number(20,6),            /*累折                                   */
fan16       number(20,10),           /*分摊比率                               */
fan17       number(20,6),            /*已计提减值准备                         */
fan18       number(15,2),            /*No Use                                 */
fan111      varchar2(24),            /*资产会计科目二                         */
fan121      varchar2(24),            /*折旧会计科目二                         */
fanlegal    varchar2(10) NOT NULL,   /*所属法人                               */
fan19       varchar2(30),            /*分录底稿单号                           */
fan20       varchar2(24),            /*累折科目                               */
fan201      varchar2(24)             /*累折科目二                             */
);

alter table fan_file add  constraint fan_pk primary key  (fan01,fan02,fan03,fan04,fan041,fan05,fan06) enable validate;
grant select on fan_file to tiptopgp;
grant update on fan_file to tiptopgp;
grant delete on fan_file to tiptopgp;
grant insert on fan_file to tiptopgp;
grant index on fan_file to public;
grant select on fan_file to ods;
