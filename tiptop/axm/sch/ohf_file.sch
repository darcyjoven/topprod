/*
================================================================================
檔案代號:ohf_file
檔案名稱:客诉经手人员记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ohf_file
(
ohf01       varchar2(20) NOT NULL,   /*客诉单号                               */
                                     /*客訴單號                               */
ohf02       varchar2(1) NOT NULL,    /*类型                                   */
                                     /*類別                                   */
                                     /*0.客訴原因                             */
                                     /*1.調查結果                             */
                                     /*2.處理對策及改善對策                   */
                                     /*3.審核                                 */
                                     /*4.核決                                 */
                                     /*5.結案註記                             */
ohf03       varchar2(10),            /*主办人员                               */
                                     /*主辦人員                               */
ohf04       varchar2(10),            /*审核人员                               */
                                     /*審核人員                               */
ohf05       varchar2(10),            /*责任单位                               */
                                     /*責任單位                               */
ohf06       varchar2(1),             /*No Use                                 */
ohf07       varchar2(1)              /*No Use                                 */
);

alter table ohf_file add  constraint ohf_pk primary key  (ohf01,ohf02) enable validate;
grant select on ohf_file to tiptopgp;
grant update on ohf_file to tiptopgp;
grant delete on ohf_file to tiptopgp;
grant insert on ohf_file to tiptopgp;
grant index on ohf_file to public;
grant select on ohf_file to ods;
