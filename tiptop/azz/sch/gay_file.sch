/*
================================================================================
檔案代號:gay_file
檔案名稱:系统使用语言资料表
檔案目的:记录系统内现用语言 (文字) 种类资料
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table gay_file
(
gay01       varchar2(1) NOT NULL,    /*语言别                                 */
gay02       varchar2(1),             /*no use                                 */
gay03       varchar2(80),            /*语言名称 (以该语言本身表示)            */
gay04       varchar2(1),             /*鼎新语言包注记                         */
gayacti     varchar2(1),             /*资料有效码                             */
gaydate     date,                    /*最近更改日                             */
gaygrup     varchar2(10),            /*资料所有部门                           */
gaymodu     varchar2(10),            /*资料更改者                             */
gayuser     varchar2(10),            /*资料所有者                             */
gayorig     varchar2(10),            /*资料建立部门                           */
gayoriu     varchar2(10)             /*资料建立者                             */
);

alter table gay_file add  constraint gay_pk primary key  (gay01) enable validate;
grant select on gay_file to tiptopgp;
grant update on gay_file to tiptopgp;
grant delete on gay_file to tiptopgp;
grant insert on gay_file to tiptopgp;
grant index on gay_file to public;
grant select on gay_file to ods;
