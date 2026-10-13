/*
================================================================================
檔案代號:lqz_file
檔案名稱:积分清零记录文件
檔案目的:
上游檔案:
下游檔案:N
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqz_file
(
lqz01       varchar2(30) DEFAULT ' ' NOT NULL, /*卡号*/
lqz02       date DEFAULT sysdate NOT NULL, /*清零日期*/
lqz03       number(20),              /*上期剩余积分                           */
lqz04       number(20),              /*本期使用积分                           */
lqz05       number(20),              /*本次清零积分                           */
lqz06       number(20),              /*本期增加积分                           */
lqz07       number(20),              /*本期期末积分                           */
lqzdate     date,                    /*最近更改日                             */
lqzgrup     varchar2(10),            /*资料所有群                             */
lqzmodu     varchar2(10),            /*资料更改者                             */
lqzorig     varchar2(10),            /*资料建立部门                           */
lqzoriu     varchar2(10),            /*资料建立者                             */
lqzuser     varchar2(10)             /*资料所有者                             */
);

alter table lqz_file add  constraint lqz_pk primary key  (lqz01,lqz02) enable validate;
grant select on lqz_file to tiptopgp;
grant update on lqz_file to tiptopgp;
grant delete on lqz_file to tiptopgp;
grant insert on lqz_file to tiptopgp;
grant index on lqz_file to public;
grant select on lqz_file to ods;
