/*
================================================================================
檔案代號:atg_file
檔案名稱:母公司现金流量表维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table atg_file
(
atg01       varchar2(4) DEFAULT ' ' NOT NULL, /*现金异动码*/
atg02       varchar2(100),           /*说明                                   */
atg03       varchar2(2),             /*变动分类                               */
atg05       number(5),               /*行序                                   */
atgacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
atgdate     date,                    /*最近更改日                             */
atggrup     varchar2(10),            /*资料所有群                             */
atgmodu     varchar2(10),            /*资料更改者                             */
atgorig     varchar2(10),            /*资料建立部门                           */
atgoriu     varchar2(10),            /*资料建立者                             */
atguser     varchar2(10)             /*资料所有者                             */
);

alter table atg_file add  constraint atg_pk primary key  (atg01) enable validate;
grant select on atg_file to tiptopgp;
grant update on atg_file to tiptopgp;
grant delete on atg_file to tiptopgp;
grant insert on atg_file to tiptopgp;
grant index on atg_file to public;
grant select on atg_file to ods;
