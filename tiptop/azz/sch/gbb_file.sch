/*
================================================================================
檔案代號:gbb_file
檔案名稱:SOP情境资料单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbb_file
(
gbb01       varchar2(10) NOT NULL,   /*SOP编号                                */
gbb02       varchar2(10) NOT NULL,   /*情境编号                               */
gbb03       varchar2(10) NOT NULL,   /*版本                                   */
gbb04       varchar2(1) NOT NULL,    /*语言别                                 */
gbb05       number(5) NOT NULL,      /*项次                                   */
gbb06       varchar2(20),            /*流程序号                               */
gbb07       varchar2(2),             /*性质                                   */
gbb08       varchar2(20),            /*程序编号                               */
gbb09       varchar2(255),           /*描述                                   */
gbb10       varchar2(80),            /*权责部门                               */
gbb11       varchar2(20),            /*下流程序号                             */
gbb12       varchar2(255),           /*WHEN                                   */
gbb13       varchar2(255),           /*WHAT                                   */
gbb14       varchar2(255),           /*HOW                                    */
gbb15       varchar2(20)             /*参考单据号码                           */
);

alter table gbb_file add  constraint gbb_pk primary key  (gbb01,gbb02,gbb03,gbb04,gbb05) enable validate;
grant select on gbb_file to tiptopgp;
grant update on gbb_file to tiptopgp;
grant delete on gbb_file to tiptopgp;
grant insert on gbb_file to tiptopgp;
grant index on gbb_file to public;
grant select on gbb_file to ods;
