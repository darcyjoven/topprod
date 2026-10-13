/*
================================================================================
檔案代號:adc_file
檔案名稱:调拨仓库设置档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table adc_file
(
adc01       varchar2(10) NOT NULL,   /*营运中心编号                           */
adc02       varchar2(10) NOT NULL,   /*仓库                                   */
adcacti     varchar2(1),             /*有效否                                 */
adc03       varchar2(1),             /*所有权                                 */
adc04       varchar2(1),             /*仓库级别                               */
adc05       number(15,3),            /*仓库面积                               */
adc06       number(15,3),            /*仓库容积                               */
adc07       number(15,3),            /*最高存量限制                           */
adc08       varchar2(1),             /*仓库类型                               */
adc09       varchar2(2),             /*运输群组                               */
adc10       varchar2(10)             /*运输地点                               */
);

alter table adc_file add  constraint adc_pk primary key  (adc01,adc02) enable validate;
grant select on adc_file to tiptopgp;
grant update on adc_file to tiptopgp;
grant delete on adc_file to tiptopgp;
grant insert on adc_file to tiptopgp;
grant index on adc_file to public;
grant select on adc_file to ods;
