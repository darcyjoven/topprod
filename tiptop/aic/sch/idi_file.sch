/*
================================================================================
檔案代號:idi_file
檔案名稱:ICD发票资料转入作业单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idi_file
(
idi01       varchar2(10) DEFAULT ' ' NOT NULL, /*厂商编号*/
idi02       varchar2(10) DEFAULT ' ' NOT NULL, /*厂别*/
idi03       varchar2(255),           /*上传档案档名                           */
idi04       varchar2(1),             /*从 c:\tiptop 上传                      */
idi05       varchar2(1),             /*字段分隔符号                           */
idi07       varchar2(1),             /*no use                                 */
idi08       number(5),               /*序号                                   */
idi09       varchar2(1),             /*no use                                 */
idi10       varchar2(1),             /*no use                                 */
idi11       varchar2(1),             /*no use                                 */
idi12       varchar2(1),             /*no use                                 */
idi13       varchar2(1),             /*no use                                 */
idi14       varchar2(1),             /*no use                                 */
idi15       varchar2(1),             /*no use                                 */
idiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table idi_file add  constraint idi_pk primary key  (idi01,idi02) enable validate;
grant select on idi_file to tiptopgp;
grant update on idi_file to tiptopgp;
grant delete on idi_file to tiptopgp;
grant insert on idi_file to tiptopgp;
grant index on idi_file to public;
grant select on idi_file to ods;
