/*
================================================================================
檔案代號:sge_file
檔案名稱:员工应投入工时档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table sge_file
(
sge01       date NOT NULL,           /*工作日期                               */
sge02       varchar2(10) NOT NULL,   /*员工编号                               */
sge03       number(10,2),            /*应投入工时                             */
sgeacti     varchar2(1),             /*资料有效码                             */
sgeuser     varchar2(10),            /*资料所有者                             */
sgegrup     varchar2(10),            /*资料所有群                             */
sgemodu     varchar2(10),            /*资料更改者                             */
sgedate     date,                    /*最近更改日                             */
sgeorig     varchar2(10),            /*资料建立部门                           */
sgeoriu     varchar2(10)             /*资料建立者                             */
);

alter table sge_file add  constraint sge_pk primary key  (sge01,sge02) enable validate;
grant select on sge_file to tiptopgp;
grant update on sge_file to tiptopgp;
grant delete on sge_file to tiptopgp;
grant insert on sge_file to tiptopgp;
grant index on sge_file to public;
grant select on sge_file to ods;
