/*
================================================================================
檔案代號:geb_file
檔案名稱:国家档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table geb_file
(
geb01       varchar2(10) NOT NULL,   /*国家编号                               */
                                     /*國別編號                               */
geb02       varchar2(80),            /*国家名称                               */
                                     /*國別名稱                               */
geb03       varchar2(10),            /*隶属区域编号                           */
                                     /*隸屬區域編號                           */
gebacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
gebuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
gebgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
gebmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
gebdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
geborig     varchar2(10),            /*资料建立部门                           */
geboriu     varchar2(10)             /*资料建立者                             */
);

alter table geb_file add  constraint geb_pk primary key  (geb01) enable validate;
grant select on geb_file to tiptopgp;
grant update on geb_file to tiptopgp;
grant delete on geb_file to tiptopgp;
grant insert on geb_file to tiptopgp;
grant index on geb_file to public;
grant select on geb_file to ods;
