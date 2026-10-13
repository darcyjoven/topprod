/*
================================================================================
檔案代號:tc_ccc_file
檔案名稱:成本需求推算表
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tc_ccc_file
(
tc_ccc01    number(10) NOT NULL,     /*年度                                   */
tc_ccc02    number(10) NOT NULL,     /*期别                                   */
tc_ccc03    varchar2(1) NOT NULL,    /*料件类型                               */
tc_ccc04    varchar2(40) NOT NULL,   /*料件编码                               */
tc_ccc05    varchar2(10),            /*库存单位                               */
tc_ccc06    number(15,3),            /*期初数量                               */
tc_ccc07    number(20,6),            /*期初单价                               */
tc_ccc07a   number(20,6),            /*期初材料单价                           */
tc_ccc07b   number(20,6),            /*期初人工单价                           */
tc_ccc07c   number(20,6),            /*期初制费单价                           */
tc_ccc07d   number(20,6),            /*期初加工单价                           */
tc_ccc08    number(20,6),            /*期初金额                               */
tc_ccc08a   number(20,6),            /*期初材料金额                           */
tc_ccc08b   number(20,6),            /*期初人工金额                           */
tc_ccc08c   number(20,6),            /*期初制费金额                           */
tc_ccc08d   number(20,6),            /*期初加工金额                           */
tc_ccc09    number(15,3),            /*本期入库量                             */
tc_ccc09a   number(15,3),            /*本期采购入库量                         */
tc_ccc09b   number(15,3),            /*本期仓退数量                           */
tc_ccc09c   number(15,3),            /*本期完工入库量                         */
tc_ccc09d   number(15,3),            /*本期返工入库量                         */
tc_ccc09e   number(15,3),            /*本期产线退料量                         */
tc_ccc10    number(20,6),            /*本期入库单价                           */
tc_ccc10a   number(20,6),            /*本期入库材料单价                       */
tc_ccc10b   number(20,6),            /*本期入库人工单价                       */
tc_ccc10c   number(20,6),            /*本期入库制费单价                       */
tc_ccc10d   number(20,6),            /*本期入库加工费单价                     */
tc_ccc11    number(20,6),            /*本期入库金额                           */
tc_ccc11a   number(20,6),            /*本期入库材料金额                       */
tc_ccc11b   number(20,6),            /*本期入库人工金额                       */
tc_ccc11c   number(20,6),            /*本期入库制费金额                       */
tc_ccc11d   number(20,6),            /*本期入库加工费金额                     */
tc_ccc12    number(15,3),            /*本期发出数量                           */
tc_ccc12a   number(15,3),            /*本期工单发出数量                       */
tc_ccc12b   number(15,3),            /*本期出货发出数量                       */
tc_ccc13    number(20,6),            /*本期发出单价                           */
tc_ccc13a   number(20,6),            /*本期发出材料单价                       */
tc_ccc13b   number(20,6),            /*本期发出人工单价                       */
tc_ccc13c   number(20,6),            /*本期发出制费单价                       */
tc_ccc13d   number(20,6),            /*本期发出加工费单价                     */
tc_ccc14    number(20,6),            /*本期发出金额                           */
tc_ccc14a   number(20,6),            /*本期发出材料金额                       */
tc_ccc14b   number(20,6),            /*本期发出人工金额                       */
tc_ccc14c   number(20,6),            /*本期发出制费金额                       */
tc_ccc14d   number(20,6),            /*本期发出加工费金额                     */
tc_ccc15    number(15,3),            /*本期杂收发数量                         */
tc_ccc15a   number(15,3),            /*本期杂收数量                           */
tc_ccc15b   number(15,3),            /*本期杂发数量                           */
tc_ccc16    number(20,6),            /*本期杂收发金额                         */
tc_ccc17    number(15,3),            /*本期结存数量                           */
tc_ccc18    number(20,6),            /*本期结存金额                           */
tc_ccc18a   number(20,6),            /*本期结存材料金额                       */
tc_ccc18b   number(20,6),            /*本期结存人工金额                       */
tc_ccc18c   number(20,6),            /*本期结存制费金额                       */
tc_ccc18d   number(20,6),            /*本期结存加工金额                       */
tc_ccc19    number(20,6),            /*本期平均单价                           */
tc_ccc19a   number(20,6),            /*本期平均材料单价                       */
tc_ccc19b   number(20,6),            /*本期平均人工单价                       */
tc_ccc19c   number(20,6),            /*本期平均制费单价                       */
tc_ccc19d   number(20,6)             /*本期平均加工单价                       */
);

create unique index tic_ccc_01 on tc_ccc_file (tc_ccc02,tc_ccc01,tc_ccc03,tc_ccc04);
alter table tc_ccc_file add  constraint tpc_ccc_pk primary key  (tc_ccc01,tc_ccc02,tc_ccc03,tc_ccc04) enable validate;
grant select on tc_ccc_file to tiptopgp;
grant update on tc_ccc_file to tiptopgp;
grant delete on tc_ccc_file to tiptopgp;
grant insert on tc_ccc_file to tiptopgp;
grant index on tc_ccc_file to public;
grant select on tc_ccc_file to ods;
