/*
================================================================================
檔案代號:vlh_file
檔案名稱:执行管制表
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vlh_file
(
vlh01       varchar2(10) NOT NULL,   /*工厂别                                 */
vlh02       varchar2(1),             /*状态                                   */
vlh03       varchar2(10),            /*APS版本                                */
vlh04       varchar2(10),            /*储存版本                               */
vlh05       varchar2(10),            /*运行人员                               */
vlh06       varchar2(1),             /*是否背景运行                           */
vlhlegal    varchar2(10) DEFAULT ' ' NOT NULL, /*所属法人*/
vlhplant    varchar2(10) DEFAULT ' ' NOT NULL /*所属工厂*/
);

alter table vlh_file add  constraint vlh_pk primary key  (vlh01) enable validate;
grant select on vlh_file to tiptopgp;
grant update on vlh_file to tiptopgp;
grant delete on vlh_file to tiptopgp;
grant insert on vlh_file to tiptopgp;
grant index on vlh_file to public;
grant select on vlh_file to ods;
