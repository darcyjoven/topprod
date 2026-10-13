/*
================================================================================
檔案代號:gaz_file
檔案名稱:程序名称多语言记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gaz_file
(
gaz01       varchar2(20) NOT NULL,   /*程序代码                               */
                                     /*program code                           */
gaz02       varchar2(1) NOT NULL,    /*语言别                                 */
gaz03       varchar2(500),           /*程序名称                               */
gaz04       varchar2(4000),          /*作业目的                               */
gaz05       varchar2(1) NOT NULL,    /*客製碼                                 */
gazuser     varchar2(10),            /*Create User                            */
gazgrup     varchar2(10),            /*Modify Group                           */
gazmodu     varchar2(10),            /*Modify User                            */
gazdate     date,                    /*Modify Date                            */
gaz06       varchar2(255),           /*报表打印抬头                           */
gazorig     varchar2(10),            /*资料建立部门                           */
gazoriu     varchar2(10)             /*资料建立者                             */
);

alter table gaz_file add  constraint gaz_pk primary key  (gaz01,gaz02,gaz05) enable validate;
grant select on gaz_file to tiptopgp;
grant update on gaz_file to tiptopgp;
grant delete on gaz_file to tiptopgp;
grant insert on gaz_file to tiptopgp;
grant index on gaz_file to public;
grant select on gaz_file to ods;
