/*
================================================================================
檔案代號:ide_file
檔案名稱:ICD回货资料厂商设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ide_file
(
ide01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
ide02       varchar2(1) DEFAULT ' ' NOT NULL, /*类型*/
ide03       varchar2(5),             /*收货单别                               */
ide04       date,                    /*回货日期                               */
ide05       varchar2(20),            /*回货资料档档名                         */
ide06       varchar2(1),             /*字段分隔符号                           */
ide07       varchar2(1),             /*资料存在处理方式                       */
ide08       varchar2(1),             /*从 c:tiptop 上传                       */
ide09       varchar2(1),             /*需换行                                 */
ide10       number(5),               /*上传作业错误信息档序号                 */
ide11       number(5),               /*转档作业错误信息档序号                 */
ide12       varchar2(1),             /*no use                                 */
ide13       varchar2(1),             /*no use                                 */
ide14       varchar2(1),             /*no use                                 */
ide15       varchar2(1),             /*no use                                 */
ideplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idelegal    varchar2(10) NOT NULL,   /*所属法人                               */
ide16       number(5)
);

alter table ide_file add  constraint ide_pk primary key  (ide01,ide02) enable validate;
grant select on ide_file to tiptopgp;
grant update on ide_file to tiptopgp;
grant delete on ide_file to tiptopgp;
grant insert on ide_file to tiptopgp;
grant index on ide_file to public;
grant select on ide_file to ods;
