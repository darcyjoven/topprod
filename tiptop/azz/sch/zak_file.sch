/*
================================================================================
檔案代號:zak_file
檔案名稱:定义设置查询的sql
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zak_file
(
zak01       varchar2(80) NOT NULL,   /*查询单ID                               */
zak02       varchar2(2000),          /*SQL指令                                */
zak03       varchar2(2000),          /*table 列表                             */
zak04       varchar2(2000),          /*Field 列表                             */
zak05       varchar2(2000),          /*where 条件                             */
zak06       varchar2(1),             /*SQL是否由Wizard生成                    */
zak07       varchar2(1) NOT NULL,    /*客制码                                 */
zak08       varchar2(255)            /*No Use                                 */
);

alter table zak_file add  constraint zak_pk primary key  (zak01,zak07) enable validate;
grant select on zak_file to tiptopgp;
grant update on zak_file to tiptopgp;
grant delete on zak_file to tiptopgp;
grant insert on zak_file to tiptopgp;
grant index on zak_file to public;
grant select on zak_file to ods;
