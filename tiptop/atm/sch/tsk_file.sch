/*
================================================================================
檔案代號:tsk_file
檔案名稱:集团调拨申请单单头档(多角贸易)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table tsk_file
(
tsk01       varchar2(20) NOT NULL,   /*调拨申请单号                           */
tsk02       date,                    /*申请日期                               */
tsk03       varchar2(10),            /*需求营运中心                           */
tsk04       varchar2(10),            /*在途仓库                               */
tsk05       varchar2(1),             /*状态码                                 */
                                     /*1-Open 2-Reviewed 3-Posted 4-Created Order*/
tsk06       varchar2(17),            /*多角贸易流程序号                       */
tsk07       varchar2(8),             /*多角贸易流程代码                       */
tsk08       varchar2(10),            /*员工                                   */
tsk09       varchar2(10),            /*部门                                   */
tsk10       varchar2(255),           /*备注                                   */
tsk11       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk12       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk13       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk14       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk15       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk16       varchar2(10),            /*下游厂商对应的客户编号                 */
tsk17       varchar2(10),            /*需求仓库                               */
tsk18       date,                    /*预计出货日                             */
tsk19       date,                    /*实际出货日                             */
tsk20       varchar2(1),             /*导物流状况码                           */
                                     /*0-Uneduced                             */
tsk21       number(15,3),            /*重量                                   */
tsk22       number(15,3),            /*体积                                   */
tskuser     varchar2(10),            /*资料所有者                             */
tskgrup     varchar2(10),            /*资料所有部门                           */
tskmodu     varchar2(10),            /*资料更改者                             */
tskdate     date,                    /*最近更改日                             */
tskacti     varchar2(1),             /*资料有效否                             */
tsk23       varchar2(1) DEFAULT '1' NOT NULL, /*资料来源 1.手工录入 2.需求分 */
tsk24       varchar2(10),            /*需求营运中心                           */
tsk25       varchar2(10),            /*来源营运中心                           */
tsk26       varchar2(20),            /*来源单号                               */
tskplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tsklegal    varchar2(10) NOT NULL,   /*所属法人                               */
tskoriu     varchar2(10),            /*资料建立者                             */
tskorig     varchar2(10),            /*资料建立部门                           */
tskcond     date,                    /*审核日期                               */
tskcont     varchar2(8),             /*审核时间                               */
tskconu     varchar2(10)             /*审核人员                               */
);

create        index tsk06 on tsk_file (tsk06);
alter table tsk_file add  constraint tsk_pk primary key  (tsk01) enable validate;
grant select on tsk_file to tiptopgp;
grant update on tsk_file to tiptopgp;
grant delete on tsk_file to tiptopgp;
grant insert on tsk_file to tiptopgp;
grant index on tsk_file to public;
grant select on tsk_file to ods;
