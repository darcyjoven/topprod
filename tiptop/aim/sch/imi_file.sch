/*
================================================================================
檔案代號:imi_file
檔案名稱:多单位库存调整单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table imi_file
(
imi01       varchar2(20) NOT NULL,   /*库存调整单                             */
imi02       number(5) NOT NULL,      /*项次                                   */
imi03       varchar2(4),             /*单位                                   */
imi04       number(20,8),            /*单位数量换算率-对img09                 */
imi05       number(15,3),            /*调整数量                               */
imi06       varchar2(255),           /*备注                                   */
imi07       number(15,3),            /*现有库存                               */
imi08       number(15,3),            /*实际库存                               */
imi09       varchar2(1),             /*No Use                                 */
imi10       varchar2(1),             /*No Use                                 */
imiplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imilegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imi_file add  constraint imi_pk primary key  (imi01,imi02) enable validate;
grant select on imi_file to tiptopgp;
grant update on imi_file to tiptopgp;
grant delete on imi_file to tiptopgp;
grant insert on imi_file to tiptopgp;
grant index on imi_file to public;
grant select on imi_file to ods;
