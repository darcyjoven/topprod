/*
================================================================================
檔案代號:gbd_file
檔案名稱:Action Default多语言对照档
檔案目的:
上游檔案:
下游檔案:
檔案類型:Z
多語系檔案:Y
============.========================.==========================================
*/
create table gbd_file
(
gbd01       varchar2(80) NOT NULL,   /*Action 代码                            */
gbd02       varchar2(20) NOT NULL,   /*程序代码                               */
gbd03       varchar2(1) NOT NULL,    /*语言别                                 */
gbd04       varchar2(80),            /*Action 名称                            */
gbd05       varchar2(1500),          /*Action 功能提示                        */
gbd06       varchar2(1),             /*是否为标准 TIPTOP Action               */
gbd07       varchar2(1) NOT NULL,    /*客制码                                 */
gbd08       varchar2(1),             /*No Use                                 */
gbd09       varchar2(1),             /*No Use                                 */
gbd10       varchar2(25),            /*No Use                                 */
gbd11       date                     /*异动日期                               */
);

alter table gbd_file add  constraint gbd_pk primary key  (gbd01,gbd02,gbd03,gbd07) enable validate;
grant select on gbd_file to tiptopgp;
grant update on gbd_file to tiptopgp;
grant delete on gbd_file to tiptopgp;
grant insert on gbd_file to tiptopgp;
grant index on gbd_file to public;
grant select on gbd_file to ods;
