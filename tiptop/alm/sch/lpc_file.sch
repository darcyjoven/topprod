/*
================================================================================
檔案代號:lpc_file
檔案名稱:会员管理基础代码档
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lpc_file
(
lpc00       varchar2(1) DEFAULT ' ' NOT NULL, /*码类型*/
lpc01       varchar2(10) DEFAULT ' ' NOT NULL, /*代码*/
lpc02       varchar2(80),            /*代码描述                               */
lpc03       number(20,6) DEFAULT '0' NOT NULL, /*金额下限*/
lpc04       number(20,6) DEFAULT '0' NOT NULL, /*金额上限*/
lpcacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
lpccrat     date,                    /*资料创建日                             */
lpcgrup     varchar2(10),            /*资料所有群                             */
lpcmodu     varchar2(10),            /*资料更改者                             */
lpcorig     varchar2(10),            /*资料建立部门                           */
lpcoriu     varchar2(10),            /*资料建立者                             */
lpcuser     varchar2(10),            /*资料所有者                             */
lpc05       varchar2(1) DEFAULT 'N' NOT NULL, /*会员纪念日否*/
lpcpos      varchar2(1) DEFAULT ' ' NOT NULL /*已传POS否*/
);

alter table lpc_file add  constraint lpc_pk primary key  (lpc00,lpc01) enable validate;
grant select on lpc_file to tiptopgp;
grant update on lpc_file to tiptopgp;
grant delete on lpc_file to tiptopgp;
grant insert on lpc_file to tiptopgp;
grant index on lpc_file to public;
grant select on lpc_file to ods;
