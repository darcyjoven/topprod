/*
================================================================================
檔案代號:zoc_file
檔案名稱:开账字段条件设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zoc_file
(
zoc01       varchar2(15) NOT NULL,   /*档案编号                               */
zoc02       varchar2(20) NOT NULL,   /*字段编号                               */
zoc03       varchar2(20),            /*类型                                   */
zoc04       varchar2(8),             /*长度                                   */
zoc05       varchar2(1),             /*资料类型                               */
zoc06       varchar2(100),           /*资料预设值                             */
zoc07       varchar2(15),            /*自资料判断档案                         */
zoc08       varchar2(20),            /*资料判断字段                           */
zoc09       varchar2(20),            /*关联Key值                              */
zoc10       varchar2(255),           /*资料检核逻辑                           */
zoc11       varchar2(255),           /*资料说明                               */
zoc12       varchar2(1),             /*NOT NULL                               */
zoc13       varchar2(1)              /*Primary Key                            */
);

alter table zoc_file add  constraint zoc_pk primary key  (zoc01,zoc02) enable validate;
grant select on zoc_file to tiptopgp;
grant update on zoc_file to tiptopgp;
grant delete on zoc_file to tiptopgp;
grant insert on zoc_file to tiptopgp;
grant index on zoc_file to public;
grant select on zoc_file to ods;
