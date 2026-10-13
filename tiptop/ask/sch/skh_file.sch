/*
================================================================================
檔案代號:skh_file
檔案名稱:飞票资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table skh_file
(
skh01       varchar2(20) DEFAULT ' ' NOT NULL, /*飞票号码*/
skh02       varchar2(20) DEFAULT ' ' NOT NULL, /*pbi号*/
skh03       varchar2(80) DEFAULT ' ' NOT NULL, /*款式号*/
skh04       number(10) DEFAULT '0' NOT NULL, /*床号*/
skh05       number(10) DEFAULT '0' NOT NULL, /*扎号*/
skh06       varchar2(20) DEFAULT ' ' NOT NULL, /*工单号码*/
skh08       varchar2(10),            /*单元编号                               */
skh09       varchar2(20),            /*属性一                                 */
skh10       varchar2(20),            /*属性三                                 */
skh100      varchar2(1) DEFAULT ' ' NOT NULL, /*打印码*/
skh11       varchar2(20),            /*属性二                                 */
skh12       number(15,3) DEFAULT '0' NOT NULL, /*数量*/
skh13       varchar2(20) DEFAULT ' ' NOT NULL, /*制单号*/
skh99       varchar2(80) DEFAULT ' ' NOT NULL, /*飞票标识码*/
skh07       number(5),               /*工序                                   */
skh14       number(5),               /*单元次序                               */
skhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
skhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table skh_file add  constraint skh_pk primary key  (skh01) enable validate;
grant select on skh_file to tiptopgp;
grant update on skh_file to tiptopgp;
grant delete on skh_file to tiptopgp;
grant insert on skh_file to tiptopgp;
grant index on skh_file to public;
grant select on skh_file to ods;
