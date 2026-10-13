/*
================================================================================
檔案代號:idd_file
檔案名稱:ICD料件库存更改档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table idd_file
(
idd01       varchar2(40) DEFAULT ' ' NOT NULL, /*料件编号*/
idd02       varchar2(10) DEFAULT ' ' NOT NULL, /*仓库*/
idd03       varchar2(10) DEFAULT ' ' NOT NULL, /*库位*/
idd04       varchar2(24) DEFAULT ' ' NOT NULL, /*批号*/
idd05       varchar2(3) DEFAULT ' ' NOT NULL, /*刻号*/
idd06       varchar2(5) DEFAULT ' ' NOT NULL, /*bin*/
idd07       varchar2(4),             /*单位                                   */
idd08       date DEFAULT sysdate NOT NULL, /*单据日期*/
idd09       date DEFAULT sysdate NOT NULL, /*生成日期*/
idd10       varchar2(20) DEFAULT ' ' NOT NULL, /*单据编号*/
idd11       number(5) NOT NULL,      /*单据项次                               */
idd12       varchar2(5) DEFAULT ' ' NOT NULL, /*入出库*/
idd13       number(15,3),            /*数量                                   */
idd14       varchar2(10),            /*异动指令编号                           */
idd15       varchar2(40),            /*母体料号                               */
idd16       varchar2(24),            /*母批                                   */
idd17       varchar2(80),            /*Datecode                               */
idd18       number(15,3),            /*die数                                  */
idd19       number(15,6),            /*yield                                  */
idd20       varchar2(80),            /*test #                                 */
idd21       number(5),               /*deduct                                 */
idd22       varchar2(1),             /*pass bin                               */
idd23       varchar2(40),            /*接单料号                               */
idd24       varchar2(1),             /*入库否                                 */
idd25       varchar2(255),           /*备注                                   */
idd26       number(15,3),            /*不良数量                               */
idd27       number(15,3),            /*报废数量                               */
idd28       varchar2(1),             /*转入否                                 */
idd29       number(15,3),            /*库存数量                               */
idd30       varchar2(20),            /*来源单据                               */
idd31       varchar2(24),            /*来源单据项次                           */
iddplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
iddlegal    varchar2(10) NOT NULL,   /*所属法人                               */
idd32       varchar2(1) DEFAULT ' ', /*no use                                 */
idd33       varchar2(3),             /*变更后刻号                             */
idd34       varchar2(5)              /*变更后BIN                              */
);

alter table idd_file add  constraint idd_pk primary key  (idd01,idd02,idd03,idd04,idd05,idd06,idd08,idd10,idd11,idd12) enable validate;
grant select on idd_file to tiptopgp;
grant update on idd_file to tiptopgp;
grant delete on idd_file to tiptopgp;
grant insert on idd_file to tiptopgp;
grant index on idd_file to public;
grant select on idd_file to ods;
