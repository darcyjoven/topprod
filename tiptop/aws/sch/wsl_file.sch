/*
================================================================================
檔案代號:wsl_file
檔案名稱:EasyFlow 集成自动功能 log 档
檔案目的:纪录单据程序运行过程中错误发生信息, 供集成程序判断是否正确运行
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table wsl_file
(
wsl01       varchar2(20) NOT NULL,   /*fglappserver/fglserver 的值            */
wsl02       varchar2(10) NOT NULL,   /*用户编号                               */
wsl03       varchar2(20) NOT NULL,   /*程序编号                               */
wsl04       varchar2(7),             /*错误信息编号                           */
wsl05       varchar2(255)            /*错误信息内容                           */
);

alter table wsl_file add  constraint wsl_pk primary key  (wsl01,wsl02,wsl03) enable validate;
grant select on wsl_file to tiptopgp;
grant update on wsl_file to tiptopgp;
grant delete on wsl_file to tiptopgp;
grant insert on wsl_file to tiptopgp;
grant index on wsl_file to public;
grant select on wsl_file to ods;
