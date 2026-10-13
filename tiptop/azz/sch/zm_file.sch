/*
================================================================================
檔案代號:zm_file
檔案名稱:目录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zm_file
(
zm01        varchar2(20) NOT NULL,   /*目录编号                               */
                                     /*目錄代號                               */
zm03        number(5) NOT NULL,      /*序号                                   */
                                     /*序號                                   */
zm04        varchar2(20)             /*程序编号                               */
                                     /*程式代號(Program code)                 */
);

alter table zm_file add  constraint zm_pk primary key  (zm01,zm03) enable validate;
grant select on zm_file to tiptopgp;
grant update on zm_file to tiptopgp;
grant delete on zm_file to tiptopgp;
grant insert on zm_file to tiptopgp;
grant index on zm_file to public;
grant select on zm_file to ods;
