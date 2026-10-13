/*
================================================================================
檔案代號:qdc_file
檔案名稱:Xbar-R控制数据单身档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table qdc_file
(
qdc01       varchar2(20) NOT NULL,   /*QC 单号                                */
                                     /*QC 單號                                */
qdc011      number(5) NOT NULL,      /*QC 项次                                */
                                     /*QC 項次  (For IQC)                     */
qdc012      number(5) NOT NULL,      /*QC 分批检验项次                        */
                                     /*QC 分批檢驗項次 (For IQC)              */
qdc013      number(5) NOT NULL,      /*QC 单身项次                            */
                                     /*QC 單身項次                            */
qdc02       number(5) NOT NULL,      /*组号                                   */
                                     /*組號                                   */
qdc03       date,                    /*日期                                   */
qdc04       varchar2(8),             /*时间                                   */
                                     /*時間                                   */
qdc05       number(15,3),            /*数量                                   */
                                     /*數量                                   */
qdc06       number(15,3),            /*合计                                   */
                                     /*合計                                   */
qdc07       number(15,3),            /*Xbar                                   */
qdc08       number(15,3),            /*R                                      */
qdc09       varchar2(1),             /*No Use                                 */
qdc10       varchar2(1),             /*No Use                                 */
qdcplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
qdclegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table qdc_file add  constraint qdc_pk primary key  (qdc01,qdc011,qdc012,qdc013,qdc02) enable validate;
grant select on qdc_file to tiptopgp;
grant update on qdc_file to tiptopgp;
grant delete on qdc_file to tiptopgp;
grant insert on qdc_file to tiptopgp;
grant index on qdc_file to public;
grant select on qdc_file to ods;
