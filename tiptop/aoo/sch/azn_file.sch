/*
================================================================================
檔案代號:azn_file
檔案名稱:会计期间明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table azn_file
(
azn01       date NOT NULL,           /*日期                                   */
azn02       number(5),               /*年度                                   */
azn03       number(5),               /*季别                                   */
                                     /*季別                                   */
azn04       number(5),               /*期别                                   */
                                     /*期別                                   */
azn05       number(5)                /*周别                                   */
                                     /*週別                                   */
);

create        index azn_02 on azn_file (azn02,azn04);
alter table azn_file add  constraint azn_pk primary key  (azn01) enable validate;
grant select on azn_file to tiptopgp;
grant update on azn_file to tiptopgp;
grant delete on azn_file to tiptopgp;
grant insert on azn_file to tiptopgp;
grant index on azn_file to public;
grant select on azn_file to ods;
