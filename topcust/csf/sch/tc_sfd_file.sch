/*
================================================================================
檔案代號:tc_sfd_file
檔案名稱:工单发料申请作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_sfd_file
(
tc_sfd01    varchar2(20) NOT NULL,   /*申请单号                               */
tc_sfd02    date,                    /*录入日期                               */
tc_sfd03    date,                    /*审核日期                               */
tc_sfd04    varchar2(1),             /*审核码                                 */
tc_sfd05    varchar2(1),             /*打印码                                 */
tc_sfd06    varchar2(10),            /*制造部门                               */
tc_sfd07    varchar2(20),            /*投产批次号                             */
tc_sfd08    varchar2(8),             /*序号                                   */
tc_sfduser  varchar2(10),            /*资料所有者                             */
tc_sfdgrup  varchar2(10),            /*资料所有部门                           */
tc_sfdmodu  varchar2(10),            /*资料更改者                             */
tc_sfddate  date,                    /*最近更改日                             */
tc_sfd09    varchar2(10),            /*审核人                                 */
tc_sfd10    varchar2(10),            /*理由码                                 */
tc_sfdud01  varchar2(255),           /*自订字段-Textedit                      */
tc_sfdud02  varchar2(40),            /*申请人                                 */
tc_sfdud03  varchar2(40),            /*自订字段-文字                          */
tc_sfdud04  varchar2(40),            /*自订字段-文字                          */
tc_sfdud05  varchar2(40),            /*自订字段-文字                          */
tc_sfdud06  varchar2(40),            /*自订字段-文字                          */
tc_sfdud07  number(15,3),            /*自订字段-数值                          */
tc_sfdud08  number(15,3),            /*自订字段-数值                          */
tc_sfdud09  number(15,3),            /*自订字段-数值                          */
tc_sfdud10  number(10),              /*自订字段-整数                          */
tc_sfdud11  number(10),              /*自订字段-整数                          */
tc_sfdud12  number(10),              /*自订字段-整数                          */
tc_sfdud13  date,                    /*自订字段-日期                          */
tc_sfdud14  date,                    /*自订字段-日期                          */
tc_sfdud15  date,                    /*自订字段-日期                          */
tc_sfdplant varchar2(10) NOT NULL,   /*所属营运中心                           */
tc_sfdlegal varchar2(10) NOT NULL,   /*所属法人                               */
tc_sfdoriu  varchar2(10),            /*资料建立者                             */
tc_sfdorig  varchar2(10)             /*资料建立部门                           */
);

alter table tc_sfd_file add  constraint tpc_sfd_pk primary key  (tc_sfd01) enable validate;
grant select on tc_sfd_file to tiptopgp;
grant update on tc_sfd_file to tiptopgp;
grant delete on tc_sfd_file to tiptopgp;
grant insert on tc_sfd_file to tiptopgp;
grant index on tc_sfd_file to public;
grant select on tc_sfd_file to ods;
