/*
================================================================================
檔案代號:azs_file
檔案名稱:标准基本资料档案清单档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table azs_file
(
azs01       varchar2(15) DEFAULT ' ' NOT NULL, /*档案编号*/
azs02       varchar2(1),             /*std行业用到否                          */
azs03       varchar2(1),             /*icd行业用到否                          */
azs04       varchar2(1),             /*slk行业用到否                          */
azs05       varchar2(1),             /*NO USE                                 */
azs06       varchar2(1),             /*NO USE                                 */
azs07       varchar2(1)              /*NO USE                                 */
);

alter table azs_file add  constraint azs_pk primary key  (azs01) enable validate;
grant select on azs_file to tiptopgp;
grant update on azs_file to tiptopgp;
grant delete on azs_file to tiptopgp;
grant insert on azs_file to tiptopgp;
grant index on azs_file to public;
grant select on azs_file to ods;
