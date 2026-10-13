/*
================================================================================
檔案代號:gajb_file
檔案名稱:画面元件权限设定备份档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gajb_file
(
gajb01      varchar2(20) DEFAULT ' ' NOT NULL, /*程序编号*/
gajb02      varchar2(20) DEFAULT ' ' NOT NULL, /*字段名称*/
gajb03      varchar2(255),           /*要显现的群组                           */
gajb04      varchar2(255),           /*要隐藏的群组                           */
gajb05      varchar2(255),           /*要显现的个人                           */
gajb06      varchar2(255),           /*要隐藏的个人                           */
gajb07      varchar2(255),           /*可录入的群组                           */
gajb08      varchar2(255),           /*不可录入的群组                         */
gajb09      varchar2(255),           /*可录入的个人                           */
gajb10      varchar2(255),           /*不可录入的个人                         */
gajb11      varchar2(10) DEFAULT ' ' NOT NULL, /*行业别*/
gajb12      varchar2(1) DEFAULT 'N' NOT NULL /*资料隐藏否*/
);

alter table gajb_file add  constraint gajb_pk primary key  (gajb01,gajb02,gajb11) enable validate;
grant select on gajb_file to tiptopgp;
grant update on gajb_file to tiptopgp;
grant delete on gajb_file to tiptopgp;
grant insert on gajb_file to tiptopgp;
grant index on gajb_file to public;
grant select on gajb_file to ods;
