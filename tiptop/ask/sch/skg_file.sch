/*
================================================================================
檔案代號:skg_file
檔案名稱:裁床表档
檔案目的:裁床表单身档
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skg_file
(
skg01       varchar2(20) DEFAULT ' ' NOT NULL, /*pbi单号*/
skg02       varchar2(80) DEFAULT ' ' NOT NULL, /*款式编号*/
skg03       number(10) DEFAULT '0' NOT NULL, /*床号*/
skg04       number(10) DEFAULT '0' NOT NULL, /*项次*/
skg05       varchar2(20),            /*属性一                                 */
skg06       varchar2(20),            /*属性三                                 */
skg07       varchar2(20),            /*属性二                                 */
skg08       number(10) DEFAULT '0' NOT NULL, /*扎号*/
skg09       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
skgud01     varchar2(255),           /*自订字段-Textedit                      */
skgud02     varchar2(40),            /*自订字段-文字                          */
skgud03     varchar2(40),            /*自订字段-文字                          */
skgud04     varchar2(40),            /*自订字段-文字                          */
skgud05     varchar2(40),            /*自订字段-文字                          */
skgud06     varchar2(40),            /*自订字段-文字                          */
skgud07     number(15,3),            /*自订字段-数值                          */
skgud08     number(15,3),            /*自订字段-数值                          */
skgud09     number(15,3),            /*自订字段-数值                          */
skgud10     number(10),              /*自订字段-整数                          */
skgud11     number(10),              /*自订字段-整数                          */
skgud12     number(10),              /*自订字段-整数                          */
skgud13     date,                    /*自订字段-日期                          */
skgud14     date,                    /*自订字段-日期                          */
skgud15     date,                    /*自订字段-日期                          */
skg10       varchar2(255),           /*lot色                                  */
skg11       varchar2(255),           /*备注                                   */
skg12       varchar2(20),            /*工单单号                               */
skgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skg_file add  constraint skg_pk primary key  (skg01,skg02,skg03,skg04) enable validate;
grant select on skg_file to tiptopgp;
grant update on skg_file to tiptopgp;
grant delete on skg_file to tiptopgp;
grant insert on skg_file to tiptopgp;
grant index on skg_file to public;
grant select on skg_file to ods;
