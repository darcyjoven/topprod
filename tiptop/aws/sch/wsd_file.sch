/*
================================================================================
檔案代號:wsd_file
檔案名稱:EasyFlow 集成设置主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:N
============.========================.==========================================
*/
create table wsd_file
(
wsd01       varchar2(20) NOT NULL,   /*程序编号                               */
wsd02       varchar2(1) NOT NULL,    /*是否为 Hard Code 程序                  */
wsd03       varchar2(10),            /*No Use                                 */
wsd04       varchar2(10),            /*No Use                                 */
wsd05       varchar2(10),            /*No Use                                 */
wsd06       varchar2(10),            /*No Use                                 */
wsd07       varchar2(10),            /*No Use                                 */
wsd08       varchar2(10),            /*No Use                                 */
wsd09       varchar2(10),            /*No Use                                 */
wsd10       varchar2(10),            /*No Use                                 */
wsdacti     varchar2(1),             /*资料有效码                             */
wsduser     varchar2(10),            /*资料所有者                             */
wsdgrup     varchar2(10),            /*资料所有群                             */
wsdmodu     varchar2(10),            /*资料更改者                             */
wsddate     date,                    /*最近更改日                             */
wsdorig     varchar2(10),            /*资料建立部门                           */
wsdoriu     varchar2(10)             /*资料建立者                             */
);

alter table wsd_file add  constraint wsd_pk primary key  (wsd01) enable validate;
grant select on wsd_file to tiptopgp;
grant update on wsd_file to tiptopgp;
grant delete on wsd_file to tiptopgp;
grant insert on wsd_file to tiptopgp;
grant index on wsd_file to public;
grant select on wsd_file to ods;
