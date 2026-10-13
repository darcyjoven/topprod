/*
================================================================================
檔案代號:hrav_file
檔案名稱:
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table hrav_file
(
hrav01      varchar2(40) NOT NULL,   /*变更单号                               */
hrav02      number(5) NOT NULL,      /*项次                                   */
hrav03      varchar2(50),            /*员工id                                 */
hrav04      varchar2(15),            /*表名                                   */
hrav05      varchar2(30),            /*字段代码                               */
hrav06      varchar2(255),           /*旧值                                   */
hrav07      varchar2(255),           /*新值                                   */
hrav08      date,                    /*生效日期                               */
hrav09      varchar2(255),           /*备注                                   */
hrav10      varchar2(1),             /*更新状态                               */
hravuser    varchar2(10),            /*资料所有者                             */
hravgrup    varchar2(10),            /*资料所有群                             */
hravmodu    varchar2(10),            /*资料更改者                             */
hravdate    date,                    /*最近修改日                             */
hravorig    varchar2(10),            /*资料建立部门                           */
hravoriu    varchar2(10)             /*资料建立者                             */
);

alter table hrav_file add  constraint tpc_hrav_pk primary key  (hrav01,hrav02) enable validate;
grant select on hrav_file to tiptopgp;
grant update on hrav_file to tiptopgp;
grant delete on hrav_file to tiptopgp;
grant insert on hrav_file to tiptopgp;
grant index on hrav_file to public;
grant select on hrav_file to ods;
