/*
================================================================================
檔案代號:zaj_file
檔案名稱:定义运行query前应运行的process
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table zaj_file
(
zaj01       varchar2(80) NOT NULL,   /*查询单ID                               */
zaj02       number(5) NOT NULL,      /*运行顺序                               */
zaj03       varchar2(1),             /*启动否                                 */
zaj04       varchar2(1),             /*来源类型                               */
zaj05       varchar2(255),           /*运行指令                               */
zaj06       varchar2(255),           /*备注                                   */
zaj07       varchar2(1) NOT NULL     /*客制码                                 */
);

alter table zaj_file add  constraint zaj_pk primary key  (zaj01,zaj02,zaj07) enable validate;
grant select on zaj_file to tiptopgp;
grant update on zaj_file to tiptopgp;
grant delete on zaj_file to tiptopgp;
grant insert on zaj_file to tiptopgp;
grant index on zaj_file to public;
grant select on zaj_file to ods;
