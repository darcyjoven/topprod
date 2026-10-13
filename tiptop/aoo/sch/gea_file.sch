/*
================================================================================
檔案代號:gea_file
檔案名稱:区域别档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table gea_file
(
gea01       varchar2(10) NOT NULL,   /*区域编号                               */
                                     /*區域編號                               */
                                     /*區域包含一個以上國別                   */
gea02       varchar2(80),            /*区域名称                               */
                                     /*區域名稱                               */
geaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
geauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
geagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
geamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
geadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
geaorig     varchar2(10),            /*资料建立部门                           */
geaoriu     varchar2(10)             /*资料建立者                             */
);

alter table gea_file add  constraint gea_pk primary key  (gea01) enable validate;
grant select on gea_file to tiptopgp;
grant update on gea_file to tiptopgp;
grant delete on gea_file to tiptopgp;
grant insert on gea_file to tiptopgp;
grant index on gea_file to public;
grant select on gea_file to ods;
