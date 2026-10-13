/*
================================================================================
檔案代號:icr_file
檔案名稱:ICD自动编码规则资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table icr_file
(
icr01       varchar2(10) NOT NULL,   /*编码原则编号                           */
icr02       varchar2(1) NOT NULL,    /*编号性质                               */
icr03       number(5) NOT NULL,      /*顺序                                   */
icr04       varchar2(1),             /*编码类型                               */
icr05       varchar2(10),            /*固定值                                 */
icr06       varchar2(20),            /*资料表名称                             */
icr061      varchar2(10),            /*字段名称                               */
icr07       varchar2(5),             /*位数                                   */
icr08       varchar2(1)              /*日期性质                               */
);

alter table icr_file add  constraint icr_pk primary key  (icr01,icr02,icr03) enable validate;
grant select on icr_file to tiptopgp;
grant update on icr_file to tiptopgp;
grant delete on icr_file to tiptopgp;
grant insert on icr_file to tiptopgp;
grant index on icr_file to public;
grant select on icr_file to ods;
