/*
================================================================================
檔案代號:lqj_file
檔案名稱:维护生效时间资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lqj_file
(
lqj01       varchar2(20) DEFAULT ' ' NOT NULL, /*促销单编号*/
lqj02       varchar2(1) DEFAULT ' ' NOT NULL, /*促销哦类型*/
lqj03       date DEFAULT sysdate NOT NULL, /*开始日期*/
lqj04       varchar2(2) DEFAULT ' ' NOT NULL, /*开始小时*/
lqj05       varchar2(2) DEFAULT ' ' NOT NULL, /*开始分钟*/
lqj06       date,                    /*截止日期                               */
lqj07       varchar2(2),             /*截止小时                               */
lqj08       varchar2(2)              /*截止分数                               */
);

alter table lqj_file add  constraint lqj_pk primary key  (lqj01,lqj03,lqj04,lqj05) enable validate;
grant select on lqj_file to tiptopgp;
grant update on lqj_file to tiptopgp;
grant delete on lqj_file to tiptopgp;
grant insert on lqj_file to tiptopgp;
grant index on lqj_file to public;
grant select on lqj_file to ods;
