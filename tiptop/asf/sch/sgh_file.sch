/*
================================================================================
檔案代號:sgh_file
檔案名稱:工单工艺批次变更档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sgh_file
(
sgh01       varchar2(20) NOT NULL,   /*变更单号                               */
sgh02       varchar2(40),            /*产品编号                               */
sgh03       varchar2(6),             /*工艺编号                               */
sgh04       date,                    /*录入日期                               */
sgh05       date,                    /*发放日期                               */
sgh06       varchar2(10),            /*变更原因                               */
sgh07       varchar2(10),
sgh08       varchar2(255),           /*備注                                   */
sgh09       varchar2(20),            /*工单编号                               */
sgh10       varchar2(20),            /*pbi号                                  */
sghconf     varchar2(1),             /*审核码                                 */
sghdate     date,                    /*资料更改日期                           */
sghgrup     varchar2(10),            /*资料所属群组                           */
sghmodu     varchar2(10),            /*资料更改者                             */
sghuser     varchar2(10),            /*资料所有者                             */
sghplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sghlegal    varchar2(10) NOT NULL,   /*所属法人                               */
sghorig     varchar2(10),            /*资料建立部门                           */
sghoriu     varchar2(10)             /*资料建立者                             */
);

alter table sgh_file add  constraint sgh_pk primary key  (sgh01) enable validate;
grant select on sgh_file to tiptopgp;
grant update on sgh_file to tiptopgp;
grant delete on sgh_file to tiptopgp;
grant insert on sgh_file to tiptopgp;
grant index on sgh_file to public;
grant select on sgh_file to ods;
