/*
================================================================================
檔案代號:lmq_file
檔案名稱:出租状态颜色设定档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table lmq_file
(
lmq01       varchar2(1) DEFAULT ' ' NOT NULL, /*状态编号*/
lmq02       varchar2(10),            /*颜色                                   */
lmq03       varchar2(30),            /*说明                                   */
lmqacti     varchar2(1),             /*资料有效码                             */
lmqcrat     date,                    /*资料创建日                             */
lmqdate     date,                    /*资料更改日                             */
lmqgrup     varchar2(10),            /*资料所有群                             */
lmqmodu     varchar2(10),            /*资料更改者                             */
lmquser     varchar2(10),            /*资料所有者                             */
lmqorig     varchar2(10),            /*资料建立部门                           */
lmqoriu     varchar2(10)             /*资料建立者                             */
);

alter table lmq_file add  constraint lmq_pk primary key  (lmq01) enable validate;
grant select on lmq_file to tiptopgp;
grant update on lmq_file to tiptopgp;
grant delete on lmq_file to tiptopgp;
grant insert on lmq_file to tiptopgp;
grant index on lmq_file to public;
grant select on lmq_file to ods;
