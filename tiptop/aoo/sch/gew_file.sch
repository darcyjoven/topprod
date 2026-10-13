/*
================================================================================
檔案代號:gew_file
檔案名稱:资料抛转原则(资料中心)
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gew_file
(
gew01       varchar2(10) DEFAULT ' ' NOT NULL, /*资料中心代码*/
gew02       varchar2(1) DEFAULT ' ' NOT NULL, /*资料类型*/
gew03       varchar2(1),             /*自动抛转否                             */
gew04       varchar2(10) NOT NULL,   /*抛转营运中心                           */
gew05       varchar2(255),           /*抛转条件                               */
gew06       varchar2(1),             /*子公司可删除资料否                     */
gew07       varchar2(1),             /*更新存在资料否                         */
gew08       varchar2(1500),          /*抛转通知人员                           */
gew09       varchar2(255),           /*抛转条件                               */
gew10       varchar2(1) DEFAULT 'N' NOT NULL /*子公司可新增资料否*/
);

alter table gew_file add  constraint gew_pk primary key  (gew01,gew02,gew04) enable validate;
grant select on gew_file to tiptopgp;
grant update on gew_file to tiptopgp;
grant delete on gew_file to tiptopgp;
grant insert on gew_file to tiptopgp;
grant index on gew_file to public;
grant select on gew_file to ods;
