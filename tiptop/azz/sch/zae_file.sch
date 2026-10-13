/*
================================================================================
檔案代號:zae_file
檔案名稱:报表连查sql设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table zae_file
(
zae01       varchar2(10) NOT NULL,   /*报表连查sql 编号                       */
zae02       varchar2(80),            /*编号说明                               */
zae03       varchar2(255),           /*sql内容                                */
zae04       number(5) NOT NULL,      /*序号                                   */
zae05       varchar2(1) NOT NULL,    /*语言别                                 */
zae06       varchar2(20),            /*字段编号                               */
zae07       varchar2(80),            /*字段说明                               */
zae08       number(5) NOT NULL,      /*报表下阶联查序号                       */
zae09       varchar2(1),             /*报表下阶联查类型 1:程序编号            */
zae10       varchar2(20)             /*报表下阶连查内容                       */
);

alter table zae_file add  constraint zae_pk primary key  (zae01,zae04,zae05,zae08) enable validate;
grant select on zae_file to tiptopgp;
grant update on zae_file to tiptopgp;
grant delete on zae_file to tiptopgp;
grant insert on zae_file to tiptopgp;
grant index on zae_file to public;
grant select on zae_file to ods;
