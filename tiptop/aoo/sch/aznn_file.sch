/*
================================================================================
檔案代號:aznn_file
檔案名稱:账套会计期间明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table aznn_file
(
aznn00      varchar2(5) NOT NULL,    /*帐套                                   */
aznn01      date NOT NULL,           /*日期                                   */
aznn02      number(5),               /*年度                                   */
                                     /*1-12,2-13                              */
aznn03      number(5),               /*季别                                   */
aznn04      number(5),               /*期别                                   */
aznn05      number(5)                /*周别                                   */
);

create        index aznn_02 on aznn_file (aznn02,aznn04);
alter table aznn_file add  constraint aznn_pk primary key  (aznn00,aznn01) enable validate;
grant select on aznn_file to tiptopgp;
grant update on aznn_file to tiptopgp;
grant delete on aznn_file to tiptopgp;
grant insert on aznn_file to tiptopgp;
grant index on aznn_file to public;
grant select on aznn_file to ods;
