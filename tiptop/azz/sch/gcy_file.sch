/*
================================================================================
檔案代號:gcy_file
檔案名稱:CR 报表预览设定单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gcy_file
(
gcy01       varchar2(80) NOT NULL,   /*程序编号                               */
gcy02       varchar2(1) NOT NULL,    /*客制码                                 */
gcy03       varchar2(10) NOT NULL,   /*权限类型                               */
gcy04       varchar2(10) NOT NULL,   /*用户                                   */
gcy05       varchar2(1),             /*是否启用                               */
gcydate     date,                    /*最近更改日                             */
gcygrup     varchar2(10),            /*资料所有群                             */
gcymodu     varchar2(10),            /*资料更改者                             */
gcyuser     varchar2(10),            /*资料所有者                             */
gcyorig     varchar2(10),            /*资料建立部门                           */
gcyoriu     varchar2(10)             /*资料建立者                             */
);

alter table gcy_file add  constraint gcy_pk primary key  (gcy01,gcy02,gcy03,gcy04) enable validate;
grant select on gcy_file to tiptopgp;
grant update on gcy_file to tiptopgp;
grant delete on gcy_file to tiptopgp;
grant insert on gcy_file to tiptopgp;
grant index on gcy_file to public;
grant select on gcy_file to ods;
