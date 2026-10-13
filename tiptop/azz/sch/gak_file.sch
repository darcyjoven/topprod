/*
================================================================================
檔案代號:gak_file
檔案名稱:程序联结资料维护单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gak_file
(
gak01       varchar2(20) NOT NULL,   /*LINK程序                               */
                                     /* 程式代碼                              */
gak02       varchar2(100),           /*No Use                                 */
gak03       varchar2(1000),          /*No Use                                 */
gak04       varchar2(1),             /*No Use                                 */
gak05       varchar2(1),             /*No Use                                 */
gakuser     varchar2(10),            /*OWNER                                  */
                                     /* OWNER                                 */
gakgrup     varchar2(10),            /*GROUP                                  */
                                     /* GROUP                                 */
gakmodu     varchar2(10),            /*MODIFY USER                            */
                                     /* MODIFY USER                           */
gakdate     date,                    /*MODIFY DATE                            */
                                     /* MODIFY DATE                           */
gakorig     varchar2(10),            /*资料建立部门                           */
gakoriu     varchar2(10)             /*资料建立者                             */
);

alter table gak_file add  constraint gak_pk primary key  (gak01) enable validate;
grant select on gak_file to tiptopgp;
grant update on gak_file to tiptopgp;
grant delete on gak_file to tiptopgp;
grant insert on gak_file to tiptopgp;
grant index on gak_file to public;
grant select on gak_file to ods;
