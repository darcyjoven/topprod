/*
================================================================================
檔案代號:gda_file
檔案名稱:CR 报表预览设定SQL档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gda_file
(
gda01       varchar2(80) NOT NULL,   /*程序代码                               */
gda02       varchar2(1) NOT NULL,    /*客制码                                 */
gda03       varchar2(10) NOT NULL,   /*权限类型                               */
gda04       varchar2(10) NOT NULL,   /*用户                                   */
gda05       varchar2(1500),          /*SQL指令                                */
gda06       varchar2(1500),          /*Table 列表
                                                                                  */
gda07       varchar2(1500),          /*Field 列表                             */
gda08       varchar2(1500),          /*Where 列表                             */
gda09       varchar2(1)              /*SQL是否由Wizard生成                    */
);

alter table gda_file add  constraint gda_pk primary key  (gda01,gda02,gda03,gda04) enable validate;
grant select on gda_file to tiptopgp;
grant update on gda_file to tiptopgp;
grant delete on gda_file to tiptopgp;
grant insert on gda_file to tiptopgp;
grant index on gda_file to public;
grant select on gda_file to ods;
