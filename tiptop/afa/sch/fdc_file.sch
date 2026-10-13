/*
================================================================================
檔案代號:fdc_file
檔案名稱:保险单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table fdc_file
(
fdc01       varchar2(20) NOT NULL,   /*保单编号                               */
fdc02       number(5) NOT NULL,      /*序号                                   */
fdc03       varchar2(10),            /*财产编号                               */
fdc032      varchar2(4),             /*附号                                   */
fdc04       number(5),               /*标的序号                               */
fdc05       varchar2(10),            /*折旧部门                               */
fdc06       number(20,6),            /*未折余额                               */
fdc07       number(20,6),            /*保险金额                               */
fdc08       number(9,4),             /*保险费率                               */
fdc09       number(20,6),            /*保险费                                 */
fdc10       number(20,6),            /*预付保险费                             */
fdc11       number(20,6),            /*已摊保费                               */
fdc12       varchar2(80),            /*中文名称                               */
fdc13       varchar2(1),             /*No Use                                 */
fdclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index fdc_02 on fdc_file (fdc03,fdc032);
alter table fdc_file add  constraint fdc_pk primary key  (fdc01,fdc02) enable validate;
grant select on fdc_file to tiptopgp;
grant update on fdc_file to tiptopgp;
grant delete on fdc_file to tiptopgp;
grant insert on fdc_file to tiptopgp;
grant index on fdc_file to public;
grant select on fdc_file to ods;
