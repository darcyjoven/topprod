/*
================================================================================
檔案代號:rmk_file
檔案名稱:不良现象/修复代码代码档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table rmk_file
(
rmk01       varchar2(10) NOT NULL,   /*修复/不良现象代码                      */
                                     /*代碼                                   */
rmk02       varchar2(80),            /*说明                                   */
                                     /*說明                                   */
rmk03       varchar2(1)              /*码别                                   */
                                     /*碼別 1-Defect 2-Repair                 */
);

alter table rmk_file add  constraint rmk_pk primary key  (rmk01) enable validate;
grant select on rmk_file to tiptopgp;
grant update on rmk_file to tiptopgp;
grant delete on rmk_file to tiptopgp;
grant insert on rmk_file to tiptopgp;
grant index on rmk_file to public;
grant select on rmk_file to ods;
