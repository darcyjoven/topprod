/*
================================================================================
檔案代號:adc_file
檔案名稱:調撥倉庫設定檔
檔案目的:
上游檔案:
下游檔案:
============.========================.==========================================
*/
create table adc_file
(
adc01       varchar2(10),            /*營運中心編號                           */
adc02       varchar2(10),            /*倉庫                                   */
adcacti     varchar2(1),             /*有效否                                 */
adc03       varchar2(1),             /*所有權                                 */
adc04       varchar2(1),             /*倉庫級別                               */
adc05       number(15,3),            /*倉庫面積                               */
adc06       number(15,3),            /*倉庫容積                               */
adc07       number(15,3),            /*最高存量限制                           */
adc08       varchar2(1),             /*倉庫類別                               */
adc09       varchar2(2),             /*運輸群組                               */
adc10       varchar2(10)             /*運輸地點                               */
);

create unique index adc_01 on adc_file (adc01,adc02);
grant select on adc_file to public;
grant index on adc_file to public;
grant update on adc_file to public;
grant delete on adc_file to public;
grant insert on adc_file to public;
