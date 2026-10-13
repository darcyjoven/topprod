/*
================================================================================
檔案代號:pmli_file
檔案名稱:请购单单身档(行业别架构)
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pmli_file
(
pmli01      varchar2(20) DEFAULT ' ' NOT NULL, /*请购单号   pmk01*/
pmli02      number(10) DEFAULT '0' NOT NULL, /*项次，请购单所含盖的项目编 */
pmlislk01   varchar2(20),            /*制单号                                 */
pmliplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
pmlilegal   varchar2(10) NOT NULL,   /*所属法人                               */
pmlislk02   varchar2(40),            /*款号                                   */
pmlislk03   number(5)                /*项次                                   */
);

alter table pmli_file add  constraint pmli_pk primary key  (pmli01,pmli02) enable validate;
grant select on pmli_file to tiptopgp;
grant update on pmli_file to tiptopgp;
grant delete on pmli_file to tiptopgp;
grant insert on pmli_file to tiptopgp;
grant index on pmli_file to public;
grant select on pmli_file to ods;
