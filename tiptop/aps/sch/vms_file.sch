/*
================================================================================
檔案代號:vms_file
檔案名稱:aps替代作业维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vms_file
(
vms01       varchar2(40) DEFAULT ' ' NOT NULL, /*料号*/
vms02       varchar2(80) DEFAULT ' ' NOT NULL, /*工艺路线*/
vms03       varchar2(60) DEFAULT ' ' NOT NULL, /*加工序号*/
vms04       varchar2(6),             /*作业编号                               */
vms05       number(5) NOT NULL,      /*项次                                   */
vms06       number(5),               /*优先顺序                               */
vms07       varchar2(10),            /*工作站                                 */
vms08       varchar2(10),            /*机器编号                               */
vms09       number(15,3),            /*固定人工工时                           */
vms10       number(15,3),            /*标准人工工时                           */
vms11       number(15,3),            /*固定机器工时                           */
vms12       number(15,3),            /*标准机器工时                           */
vms13       varchar2(1),             /*委外否                                 */
vms012      varchar2(10) DEFAULT ' ' NOT NULL /*工艺段号*/
);

alter table vms_file add  constraint vms_pk primary key  (vms01,vms02,vms03,vms05,vms012) enable validate;
grant select on vms_file to tiptopgp;
grant update on vms_file to tiptopgp;
grant delete on vms_file to tiptopgp;
grant insert on vms_file to tiptopgp;
grant index on vms_file to public;
grant select on vms_file to ods;
