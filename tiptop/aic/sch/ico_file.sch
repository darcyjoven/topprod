/*
================================================================================
檔案代號:ico_file
檔案名稱:ICD料件生产资讯资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ico_file
(
ico01       varchar2(20) NOT NULL,   /*单据编号                               */
ico02       number(5) NOT NULL,      /*项次                                   */
ico03       varchar2(10) NOT NULL,   /*类型                                   */
ico04       varchar2(5) NOT NULL,    /*No.                                    */
ico05       varchar2(1),             /*Date Code否                            */
ico06       varchar2(255),           /*Comment                                */
ico07       varchar2(40),            /*料号                                   */
icoacti     varchar2(1),             /*资料有效码                             */
icodate     date,                    /*最近更改日                             */
icogrup     varchar2(10),            /*资料所有群                             */
icomodu     varchar2(10),            /*资料更改者                             */
icouser     varchar2(10),            /*资料所有者                             */
icoorig     varchar2(10),            /*资料建立部门                           */
icooriu     varchar2(10)             /*资料建立者                             */
);

alter table ico_file add  constraint ico_pk primary key  (ico01,ico02,ico03,ico04) enable validate;
grant select on ico_file to tiptopgp;
grant update on ico_file to tiptopgp;
grant delete on ico_file to tiptopgp;
grant insert on ico_file to tiptopgp;
grant index on ico_file to public;
grant select on ico_file to ods;
