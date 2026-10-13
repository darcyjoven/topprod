/*
================================================================================
檔案代號:wad_file
檔案名稱:通用接口之本机报表定义主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wad_file
(
wad01       varchar2(20) DEFAULT ' ' NOT NULL, /*报表ID*/
wad02       varchar2(40) DEFAULT ' ' NOT NULL, /*报表名称*/
wad03       varchar2(100),           /*运行指令                               */
wad04       varchar2(10) DEFAULT 'default' NOT NULL, /*使用者*/
wad05       varchar2(1) DEFAULT 'N' NOT NULL, /*是否为 Hard Code 程序*/
wad06       varchar2(20) DEFAULT 'default' NOT NULL /*他系统代码*/
);

alter table wad_file add  constraint wad_pk primary key  (wad01,wad04,wad06) enable validate;
grant select on wad_file to tiptopgp;
grant update on wad_file to tiptopgp;
grant delete on wad_file to tiptopgp;
grant insert on wad_file to tiptopgp;
grant index on wad_file to public;
grant select on wad_file to ods;
