/*
================================================================================
檔案代號:gdq_file
檔案名稱:XtraGrid 元文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gdq_file
(
gdq01       varchar2(100) DEFAULT ' ' NOT NULL,
gdq02       varchar2(20),
gdq03       varchar2(255),
gdq04       varchar2(255),
gdq05       varchar2(255),
gdq06       varchar2(255),
gdq07       varchar2(255),
gdq08       varchar2(100),
gdq09       date,
gdq10       varchar2(255),
gdq11       varchar2(255),
gdq12       varchar2(255),
gdq13       varchar2(255),
gdq14       varchar2(255),
gdq15       varchar2(255),
gdq16       varchar2(255),
gdq17       varchar2(255),
gdq18       varchar2(10),
gdq19       varchar2(20),
gdq20       varchar2(10),            /*权限类型                               */
gdq21       varchar2(1000),
gdq22       varchar2(255),
gdq23       varchar2(255),
gdq24       varchar2(255),
gdq25       varchar2(255),
gdq26       varchar2(255),
gdq27       varchar2(255),
gdq28       varchar2(255),
gdq29       varchar2(255),
gdq30       varchar2(255),
gdq31       varchar2(255),
gdq32       varchar2(1000),
gdq33       varchar2(255),
gdq34       varchar2(255),
gdq35       varchar2(255),
gdq36       varchar2(100),
gdq37       varchar2(1000),          /*收件者                                 */
gdq38       varchar2(1000),          /*副本                                   */
gdq39       varchar2(1000),          /*密件副本                               */
gdq40       varchar2(1000),          /*邮件本文                               */
gdq41       varchar2(80),            /*寄件者                                 */
gdq42       varchar2(255),           /*报表档名                               */
gdq43       varchar2(80),            /*用户允许印表方式                       */
gdq44       number(10),
gdq45       varchar2(1) DEFAULT ' ' NOT NULL,
gdq46       varchar2(50),
gdq47       varchar2(1) DEFAULT '.' NOT NULL,
gdq48       varchar2(1) DEFAULT ',' NOT NULL
);

alter table gdq_file add  constraint gdq_pk primary key  (gdq01) enable validate;
grant select on gdq_file to tiptopgp;
grant update on gdq_file to tiptopgp;
grant delete on gdq_file to tiptopgp;
grant insert on gdq_file to tiptopgp;
grant index on gdq_file to public;
grant select on gdq_file to ods;
