/*
================================================================================
檔案代號:mlj_file
檔案名稱:javamail参数维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table mlj_file
(
mlj01       varchar2(20) NOT NULL,   /*程序编号                               */
                                     /*程式代號(program code)                 */
mlj02       varchar2(1),             /*XML档档名                              */
                                     /*XML檔檔名(1)固定(.xml)(2)變動($pid.xml)*/
mlj03       varchar2(30),            /*MAIL SERVER IP                         */
mlj04       varchar2(5),             /*MAIL SERVER Port                       */
mlj05       varchar2(40),            /*MAIL SERVER User                       */
mlj06       varchar2(20),            /*MAIL SERVER User Password              */
mlj07       varchar2(1),             /*是否启动Javamail                       */
                                     /*是否啟動Javamail                       */
mljuser     varchar2(10),            /*资料所有者                             */
mljgrup     varchar2(10),            /*资料所有部门                           */
mljmodu     varchar2(10),            /*资料更改者                             */
mljdate     date,                    /*最近更改日                             */
mlj08       varchar2(1),             /*是否检查认证                           */
mlj09       varchar2(1),             /*是否读取系统寄件者                     */
mlj10       varchar2(1) DEFAULT 'N' NOT NULL, /*加密*/
mljoriu     varchar2(10),            /*资料建立者                             */
mljorig     varchar2(10),            /*资料建立部门                           */
mlj11       varchar2(1) DEFAULT 'S' NOT NULL /*加密类型*/
);

alter table mlj_file add  constraint mlj_pk primary key  (mlj01) enable validate;
grant select on mlj_file to tiptopgp;
grant update on mlj_file to tiptopgp;
grant delete on mlj_file to tiptopgp;
grant insert on mlj_file to tiptopgp;
grant index on mlj_file to public;
grant select on mlj_file to ods;
