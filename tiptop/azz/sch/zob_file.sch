/*
================================================================================
檔案代號:zob_file
檔案名稱:开账资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zob_file
(
zob01       varchar2(10) NOT NULL,   /*资料代号                               */
zob02       varchar2(15) NOT NULL,   /*档案编号                               */
zob03       varchar2(1),             /*必要否                                 */
zob04       varchar2(1),             /*汇入否                                 */
zob05       varchar2(1),             /*仅汇出人工输入字段                     */
zob06       number(10)               /*允许错误笔数                           */
);

alter table zob_file add  constraint zob_pk primary key  (zob01,zob02) enable validate;
grant select on zob_file to tiptopgp;
grant update on zob_file to tiptopgp;
grant delete on zob_file to tiptopgp;
grant insert on zob_file to tiptopgp;
grant index on zob_file to public;
grant select on zob_file to ods;
