/*
================================================================================
檔案代號:fgb_file
檔案名稱:量测仪器校定项目维护作业
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table fgb_file
(
fgb01       varchar2(15) NOT NULL,   /*仪器编号                               */
fgb02       number(5) NOT NULL,      /*项次                                   */
fgb03       varchar2(6),             /*校定项目                               */
fgb04       varchar2(255),           /*备注                                   */
fgbacti     varchar2(1),             /*资料有效码                             */
fgbuser     varchar2(10),            /*资料所有者                             */
fgbgrup     varchar2(10),            /*资料所有群                             */
fgbmodu     varchar2(10),            /*资料更改者                             */
fgbdate     date,                    /*最近更改日                             */
fgborig     varchar2(10),            /*资料建立部门                           */
fgboriu     varchar2(10)             /*资料建立者                             */
);

alter table fgb_file add  constraint fgb_pk primary key  (fgb01,fgb02) enable validate;
grant select on fgb_file to tiptopgp;
grant update on fgb_file to tiptopgp;
grant delete on fgb_file to tiptopgp;
grant insert on fgb_file to tiptopgp;
grant index on fgb_file to public;
grant select on fgb_file to ods;
