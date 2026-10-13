/*
================================================================================
檔案代號:idb_file
檔案名稱:ICD料件出库纪录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table idb_file
(
idb01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
idb02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
idb03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
idb04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
idb05       varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
idb06       varchar2(5) DEFAULT ' ' NOT NULL, /*bin*/
idb07       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
idb08       number(5) DEFAULT '0' NOT NULL, /*单据项次*/
idb09       date,                    /*单据日期                               */
idb10       number(15,3),            /*库存数量                               */
idb11       number(15,3),            /*出货数量                               */
idb12       varchar2(4),             /*单位                                   */
idb13       varchar2(40),            /*母体料号                               */
idb14       varchar2(24),            /*母批                                   */
idb15       varchar2(80),            /*Datecode                               */
idb16       number(15,3),            /*die数                                  */
idb17       number(15,6),            /*yield                                  */
idb18       varchar2(80),            /*test #                                 */
idb19       number(5),               /*deduct                                 */
idb20       varchar2(1),             /*pass bin                               */
idb21       varchar2(40),            /*接单料号                               */
idb22       varchar2(1),             /*no use                                 */
idb23       varchar2(1),             /*no use                                 */
idb24       varchar2(1),             /*no use                                 */
idb25       varchar2(255),           /*备注                                   */
idbplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
idblegal    varchar2(10) NOT NULL,   /*所属法人                               */
idb26       varchar2(3),             /*调整前刻号                             */
idb27       varchar2(5)              /*调整前BIN                              */
);

alter table idb_file add  constraint idb_pk primary key  (idb01,idb02,idb03,idb04,idb05,idb06,idb07,idb08) enable validate;
grant select on idb_file to tiptopgp;
grant update on idb_file to tiptopgp;
grant delete on idb_file to tiptopgp;
grant insert on idb_file to tiptopgp;
grant index on idb_file to public;
grant select on idb_file to ods;
