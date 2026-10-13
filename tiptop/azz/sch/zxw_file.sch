/*
================================================================================
檔案代號:zxw_file
檔案名稱:部门用户权限类型档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zxw_file
(
zxw01       varchar2(10) NOT NULL,   /*用户编号                               */
                                     /*使用者代號,(Login user name)           */
zxw02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
zxw03       varchar2(1),             /*权限分类                               */
                                     /*權限分類 1:權限類別                    */
                                     /*         2:程式編號                    */
zxw04       varchar2(20),            /*权限类型                               */
                                     /*權限類別                               */
zxw05       varchar2(3000),          /*允许运行功能                           */
                                     /*允許執行功能                           */
zxw06       varchar2(1),             /*资料所有人--权限                       */
                                     /*資料所有人--權限                       */
zxw07       varchar2(1),             /*资料部门权限                           */
                                     /*資料部門權限                           */
zxw08       varchar2(1)              /*单身权限                               */
);

alter table zxw_file add  constraint zxw_pk primary key  (zxw01,zxw02) enable validate;
grant select on zxw_file to tiptopgp;
grant update on zxw_file to tiptopgp;
grant delete on zxw_file to tiptopgp;
grant insert on zxw_file to tiptopgp;
grant index on zxw_file to public;
grant select on zxw_file to ods;
