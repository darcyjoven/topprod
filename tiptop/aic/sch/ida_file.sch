/*
================================================================================
檔案代號:ida_file
檔案名稱:ICD料件入库纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ida_file
(
ida01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
ida02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
ida03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
ida04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
ida05       varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
ida06       varchar2(5) DEFAULT ' ' NOT NULL, /*bin*/
ida07       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
ida08       number(5) DEFAULT '0' NOT NULL, /*单据项次*/
ida09       date,                    /*异动日期                               */
ida10       number(15,3),            /*实收数量                               */
ida11       number(15,3),            /*不良数量                               */
ida12       number(15,3),            /*报废数量                               */
ida13       varchar2(4),             /*单位                                   */
ida14       varchar2(40),            /*母体料号                               */
ida15       varchar2(24),            /*母批                                   */
ida16       varchar2(80),            /*Datecode                               */
ida17       number(15,3),            /*die数                                  */
ida18       number(15,6),            /*yield                                  */
ida19       varchar2(80),            /*test #                                 */
ida20       number(5),               /*Deduct                                 */
ida21       varchar2(1),             /*pass bin                               */
ida22       varchar2(40),            /*接单料号                               */
ida23       varchar2(1),             /*no use                                 */
ida24       varchar2(1),             /*no use                                 */
ida25       varchar2(1),             /*no use                                 */
ida26       varchar2(1),             /*入库否                                 */
ida27       varchar2(1),             /*转入否                                 */
ida28       varchar2(5),             /*异动别                                 */
ida29       varchar2(255),           /*备注                                   */
ida30       varchar2(20),            /*来源单据                               */
ida31       varchar2(24),            /*来源单据项次                           */
idaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idalegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table ida_file add  constraint ida_pk primary key  (ida01,ida02,ida03,ida04,ida05,ida06,ida07,ida08) enable validate;
grant select on ida_file to tiptopgp;
grant update on ida_file to tiptopgp;
grant delete on ida_file to tiptopgp;
grant insert on ida_file to tiptopgp;
grant index on ida_file to public;
grant select on ida_file to ods;
