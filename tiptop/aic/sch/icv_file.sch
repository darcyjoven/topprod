/*
================================================================================
檔案代號:icv_file
檔案名稱:ICD料件制程资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icv_file
(
icv01       varchar2(40) NOT NULL,   /*母体料号                               */
icv02       varchar2(10) NOT NULL,   /*工艺编号                               */
icv03       number(5) NOT NULL,      /*工艺序                                 */
icv04       varchar2(10),            /*作业编号                               */
icv05       varchar2(1),             /*工艺特性                               */
icv06       varchar2(10),            /*编码原则                               */
icv07       varchar2(10),
icv08       varchar2(120),           /*品名                                   */
icv09       varchar2(120),           /*规格                                   */
icv10       varchar2(40)             /*断阶料号                               */
);

alter table icv_file add  constraint icv_pk primary key  (icv01,icv02,icv03) enable validate;
grant select on icv_file to tiptopgp;
grant update on icv_file to tiptopgp;
grant delete on icv_file to tiptopgp;
grant insert on icv_file to tiptopgp;
grant index on icv_file to public;
grant select on icv_file to ods;
