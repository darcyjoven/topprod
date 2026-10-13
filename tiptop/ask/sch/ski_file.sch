/*
================================================================================
檔案代號:ski_file
檔案名稱:裁剪拉布登记单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ski_file
(
ski01       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
ski02       varchar2(20) DEFAULT ' ' NOT NULL, /*款式号*/
ski03       number(5) DEFAULT '0' NOT NULL, /*床号*/
ski04       number(5) DEFAULT '0' NOT NULL, /*项次*/
ski05       number(5),
ski06       varchar2(6),             /*颜色                                   */
ski07       number(15,3),            /*布长                                   */
ski08       number(5),               /*张数                                   */
ski09       number(15,3),
ski10       number(15,3),
ski11       varchar2(255),           /*備注                                   */
ski12       varchar2(10),            /*lot色                                  */
ski13       varchar2(10),
skiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ski_file add  constraint ski_pk primary key  (ski01,ski02,ski03,ski04) enable validate;
grant select on ski_file to tiptopgp;
grant update on ski_file to tiptopgp;
grant delete on ski_file to tiptopgp;
grant insert on ski_file to tiptopgp;
grant index on ski_file to public;
grant select on ski_file to ods;
