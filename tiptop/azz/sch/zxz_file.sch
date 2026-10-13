/*
================================================================================
檔案代號:zxz_file
檔案名稱:数据库使用者记录档
檔案目的:维护数据库使用者记录
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zxz_file
(
zxz01       varchar2(20) DEFAULT ' ' NOT NULL, /*数据库代码*/
zxz02       varchar2(40) DEFAULT ' ' NOT NULL, /*使用者记录*/
zxz03       date,                    /*No Use                                 */
zxz04       varchar2(10) NOT NULL,   /*用户资料                               */
zxzacti     varchar2(1),             /*有效码                                 */
zxzdate     date,                    /*DATE                                   */
zxzgrup     varchar2(10),            /*GROUP                                  */
zxzmodu     varchar2(10),            /*MODIFY USER                            */
zxzuser     varchar2(10),            /*OWNER                                  */
zxzorig     varchar2(10),            /*资料建立部门                           */
zxzoriu     varchar2(10)             /*资料建立者                             */
);

alter table zxz_file add  constraint zxz_pk primary key  (zxz01) enable validate;
grant select on zxz_file to tiptopgp;
grant update on zxz_file to tiptopgp;
grant delete on zxz_file to tiptopgp;
grant insert on zxz_file to tiptopgp;
grant index on zxz_file to public;
grant select on zxz_file to ods;
