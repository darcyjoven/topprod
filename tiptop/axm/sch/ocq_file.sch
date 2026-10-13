/*
================================================================================
檔案代號:ocq_file
檔案名稱:末维属性组资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ocq_file
(
ocq01       varchar2(10) DEFAULT ' ' NOT NULL, /*组别代码*/
ocq02       varchar2(80) DEFAULT ' ' NOT NULL, /*组别名称*/
ocq03       varchar2(10) DEFAULT ' ' NOT NULL, /*属性代码*/
ocq04       varchar2(20) NOT NULL,   /*属性值                                 */
ocq05       varchar2(80),            /*说明                                   */
ocqacti     varchar2(1),             /*资料有效码                             */
ocqdate     date,                    /*资料更改日期                           */
ocqgrup     varchar2(10),            /*资料所属群组                           */
ocqmodu     varchar2(10),            /*资料更改者                             */
ocquser     varchar2(10),            /*资料所有者                             */
ocq06       varchar2(1),             /*类型                                   */
ocqorig     varchar2(10),            /*资料建立部门                           */
ocqoriu     varchar2(10)             /*资料建立者                             */
);

alter table ocq_file add  constraint ocq_pk primary key  (ocq01,ocq04) enable validate;
grant select on ocq_file to tiptopgp;
grant update on ocq_file to tiptopgp;
grant delete on ocq_file to tiptopgp;
grant insert on ocq_file to tiptopgp;
grant index on ocq_file to public;
grant select on ocq_file to ods;
