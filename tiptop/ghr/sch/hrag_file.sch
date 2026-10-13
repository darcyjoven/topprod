/*
================================================================================
檔案代號:hrag_file
檔案名稱:代码组
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrag_file
(
hrag01      varchar2(10) NOT NULL,   /*代码组编号                             */
hrag02      varchar2(50),            /*代码组名称                             */
hrag03      varchar2(50),            /*所属模块                               */
hrag04      varchar2(1),             /*系统资料否                             */
hrag05      number(5),               /*项次                                   */
hrag06      varchar2(10) NOT NULL,   /*代码项编号                             */
hrag07      varchar2(255),           /*代码项名称                             */
hrag08      varchar2(1),             /*系统数据否                             */
hragacti    varchar2(1),             /*有效否                                 */
hrag09      varchar2(255),           /*备注                                   */
hraguser    varchar2(10),            /*资料所有者                             */
hraggrup    varchar2(10),            /*资料所有群                             */
hragmodu    varchar2(10),            /*资料修改者                             */
hragdate    date,                    /*最近修改日                             */
hragorig    varchar2(10),            /*资料建立者                             */
hragoriu    varchar2(10)             /*资料建立部门                           */
);

alter table hrag_file add  constraint tpc_hrag_pk primary key  (hrag01,hrag06) enable validate;
grant select on hrag_file to tiptopgp;
grant update on hrag_file to tiptopgp;
grant delete on hrag_file to tiptopgp;
grant insert on hrag_file to tiptopgp;
grant index on hrag_file to public;
grant select on hrag_file to ods;
