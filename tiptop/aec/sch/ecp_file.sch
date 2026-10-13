/*
================================================================================
檔案代號:ecp_file
檔案名稱:工单制程变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ecp_file
(
ecp01       varchar2(20) DEFAULT ' ' NOT NULL, /*变更单号*/
ecp02       date,                    /*资源编号                               */
ecp03       date,                    /*资源个数                               */
ecp04       varchar2(10),            /*资源类型                               */
ecp05       varchar2(10),            /*变更理由码                             */
ecp06       varchar2(255),           /*備注                                   */
ecp07       varchar2(1),             /*审核码                                 */
ecp08       varchar2(1),             /*发出码                                 */
ecp09       varchar2(1),             /*变更方式                               */
ecp10       varchar2(10),            /*no use                                 */
ecpdate     date,                    /*资料更改日期                           */
ecpgrup     varchar2(10),
ecpmodu     varchar2(10),            /*资料更改者                             */
ecpuser     varchar2(10),            /*资料所有者                             */
ecpplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
ecplegal    varchar2(10) NOT NULL,   /*所属法人                               */
ecporig     varchar2(10),            /*资料建立部门                           */
ecporiu     varchar2(10)             /*资料建立者                             */
);

alter table ecp_file add  constraint ecp_pk primary key  (ecp01) enable validate;
grant select on ecp_file to tiptopgp;
grant update on ecp_file to tiptopgp;
grant delete on ecp_file to tiptopgp;
grant insert on ecp_file to tiptopgp;
grant index on ecp_file to public;
grant select on ecp_file to ods;
