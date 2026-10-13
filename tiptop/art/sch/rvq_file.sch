/*
================================================================================
檔案代號:rvq_file
檔案名稱:调拨申请单单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rvq_file
(
rvq01       varchar2(20) DEFAULT ' ' NOT NULL, /*申请单号*/
rvq02       varchar2(1),             /*来源类型                               */
rvq03       date,                    /*申请日期                               */
rvq04       varchar2(10),            /*申请人员                               */
rvq05       varchar2(10),            /*申请营运中心                           */
rvq06       varchar2(20),            /*申请营运中心单号                       */
rvq07       varchar2(10),            /*拨出营运中心                           */
rvq08       varchar2(10),            /*拨入营运中心                           */
rvq09       varchar2(255),           /*备注                                   */
rvq10       date,                    /*审核日期                               */
rvq10t      varchar2(8),             /*审核时间                               */
rvq11       varchar2(10),            /*审核人员                               */
rvq12       date,                    /*核准日期                               */
rvq12t      varchar2(8),             /*核准时间                               */
rvq13       varchar2(10),            /*核准人员                               */
rvqacti     varchar2(1),             /*资料有效码                             */
rvqconf     varchar2(1),             /*确认码                                 */
rvqcrat     date,                    /*资料创建日                             */
rvqdate     date,                    /*最近更改日                             */
rvqgrup     varchar2(10),            /*资料所有部门                           */
rvqlegal    varchar2(10),            /*法人别                                 */
rvqmodu     varchar2(10),            /*资料更改者                             */
rvqorig     varchar2(10),            /*资料建立部门                           */
rvqoriu     varchar2(10),            /*资料建立者                             */
rvqplant    varchar2(10) DEFAULT ' ' NOT NULL, /*营运中心别*/
rvqpos      varchar2(1) DEFAULT 'N' NOT NULL, /*已传POS否*/
rvquser     varchar2(10),            /*资料所有者                             */
rvq00       varchar2(10) DEFAULT ' ' NOT NULL, /*单据类型*/
rvq14       varchar2(20),            /*调拨单号                               */
rvq15       varchar2(10),            /*在途仓库                               */
rvq904      varchar2(8),             /*多角流程编号                           */
rvq99       varchar2(17)             /*多角流转序号                           */
);

create unique index rvq_01 on rvq_file (rvq01,rvqplant);
alter table rvq_file add  constraint rvq_pk primary key  (rvq01,rvqplant) enable validate;
grant select on rvq_file to tiptopgp;
grant update on rvq_file to tiptopgp;
grant delete on rvq_file to tiptopgp;
grant insert on rvq_file to tiptopgp;
grant index on rvq_file to public;
grant select on rvq_file to ods;
