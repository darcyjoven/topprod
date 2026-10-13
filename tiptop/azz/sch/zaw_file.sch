/*
================================================================================
檔案代號:zaw_file
檔案名稱:CR报表格式设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table zaw_file
(
zaw01       varchar2(20) NOT NULL,   /*程序编号                               */
zaw02       varchar2(30) NOT NULL,   /*样板编号                               */
zaw03       varchar2(1) NOT NULL,    /*客制否                                 */
zaw04       varchar2(10) NOT NULL,   /*权限类型                               */
zaw05       varchar2(10) NOT NULL,   /*用户                                   */
zaw06       varchar2(1) NOT NULL,    /*语言别                                 */
zaw07       number(5) NOT NULL,      /*序号                                   */
zaw08       varchar2(80),            /*cr样板名称(.rpt)                       */
zaw09       varchar2(80),            /*cr样板说明                             */
zaw10       varchar2(10) DEFAULT 'std' NOT NULL, /*行业别*/
zaw11       number(10),              /*Time Out Setting                       */
zaw12       varchar2(1),             /*打印签核                               */
zawdate     date,                    /*最近更改日                             */
zawgrup     varchar2(10),            /*资料所有部门                           */
zawmodu     varchar2(10),            /*资料更改者                             */
zawuser     varchar2(10),            /*资料所有者                             */
zaw14       varchar2(30),            /*纸张名称                               */
zaw15       varchar2(1),             /*纸张方向(P:纵向/L:横向)                */
zaw16       varchar2(1),             /*no use                                 */
zaw17       varchar2(1),             /*no use                                 */
zaw18       varchar2(1),             /*no use                                 */
zaw13       varchar2(1) DEFAULT '1' NOT NULL, /*打印签核位置*/
zaworig     varchar2(10),            /*资料建立部门                           */
zaworiu     varchar2(10)             /*资料建立者                             */
);

alter table zaw_file add  constraint zaw_pk primary key  (zaw01,zaw02,zaw03,zaw04,zaw05,zaw06,zaw07,zaw10) enable validate;
grant select on zaw_file to tiptopgp;
grant update on zaw_file to tiptopgp;
grant delete on zaw_file to tiptopgp;
grant insert on zaw_file to tiptopgp;
grant index on zaw_file to public;
grant select on zaw_file to ods;
