/*
================================================================================
檔案代號:idc_file
檔案名稱:ICD料件/刻号/bin库存主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table idc_file
(
idc01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
idc02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库编号*/
idc03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位编号*/
idc04       varchar2(80) DEFAULT ' ' NOT NULL, /*批号*/
idc05       varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
idc06       varchar2(5) DEFAULT ' ' NOT NULL, /*Bin*/
idc07       varchar2(4),             /*明细单位                               */
idc08       number(15,3),            /*数量                                   */
idc09       varchar2(40),            /*母体料号                               */
idc10       varchar2(24),            /*母批                                   */
idc11       varchar2(80),            /*Datecode                               */
idc12       number(15,3),            /*die数                                  */
idc13       number(15,6),            /*yield                                  */
idc14       varchar2(80),            /*test #                                 */
idc15       number(5),               /*Deduct                                 */
idc16       varchar2(1),             /*pass bin                               */
idc17       varchar2(1),             /*hold 批否                              */
idc18       varchar2(1),             /*AFTER hold lot否                       */
idc19       varchar2(40),            /*接单料号                               */
idc20       varchar2(255),           /*备注                                   */
idc21       number(15,3)             /*已备置量                               */
);

alter table idc_file add  constraint idc_pk primary key  (idc01,idc02,idc03,idc04,idc05,idc06) enable validate;
grant select on idc_file to tiptopgp;
grant update on idc_file to tiptopgp;
grant delete on idc_file to tiptopgp;
grant insert on idc_file to tiptopgp;
grant index on idc_file to public;
grant select on idc_file to ods;
