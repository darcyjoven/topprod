/*
================================================================================
檔案代號:gam_file
檔案名稱:程序历程维护作业单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gam_file
(
gam01       varchar2(20) NOT NULL,   /*程序名称                               */
                                     /*程式名稱                               */
gam02       varchar2(80),            /*个案程序名称                           */
                                     /*個案程式名稱                           */
gamuser     varchar2(10),            /*OWNER                                  */
gamgrup     varchar2(10),            /*GROUP                                  */
gammodu     varchar2(10),            /*MODIFY USER                            */
gamdate     date,                    /*MODIFY DATE                            */
gamorig     varchar2(10),            /*资料建立部门                           */
gamoriu     varchar2(10)             /*资料建立者                             */
);

alter table gam_file add  constraint gam_pk primary key  (gam01) enable validate;
grant select on gam_file to tiptopgp;
grant update on gam_file to tiptopgp;
grant delete on gam_file to tiptopgp;
grant insert on gam_file to tiptopgp;
grant index on gam_file to public;
grant select on gam_file to ods;
