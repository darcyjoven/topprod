/*
================================================================================
檔案代號:vnc_file
檔案名稱:APS加班资讯维护档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table vnc_file
(
vnc01       varchar2(10) DEFAULT ' ' NOT NULL, /*资源编号*/
vnc02       date DEFAULT sysdate NOT NULL, /*日期*/
vnc03       number(9) DEFAULT '0' NOT NULL, /*开始时间(整数)*/
vnc04       number(9),               /*结束时间(整数)                         */
vnc05       number(1),               /*是否排程                               */
vnc031      varchar2(8) DEFAULT ' ' NOT NULL, /*加班起始时间*/
vnc041      varchar2(8),             /*加班起止时间                           */
vnc06       number(1) DEFAULT '0' NOT NULL, /*是否为外包*/
vnc07       number(1) DEFAULT '0' NOT NULL, /*资源类型*/
vnc08       number(1) NOT NULL,      /*加班型态                               */
vnc09       number(5) DEFAULT '0' NOT NULL, /*年度*/
vnc10       number(5) DEFAULT '0' NOT NULL /*月份*/
);

alter table vnc_file add  constraint vnc_pk primary key  (vnc01,vnc02,vnc03,vnc06,vnc07,vnc08,vnc09,vnc10) enable validate;
grant select on vnc_file to tiptopgp;
grant update on vnc_file to tiptopgp;
grant delete on vnc_file to tiptopgp;
grant insert on vnc_file to tiptopgp;
grant index on vnc_file to public;
grant select on vnc_file to ods;
