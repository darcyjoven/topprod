/*
================================================================================
檔案代號:stg_file
檔案名稱:工单入库明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table stg_file
(
stg01       varchar2(1) DEFAULT ' ' NOT NULL, /*工单类型*/
                                     /*工單類別                               */
stg02       number(5) DEFAULT '0' NOT NULL, /*年度*/
stg03       number(5) DEFAULT '0' NOT NULL, /*月份*/
stg04       varchar2(16) DEFAULT ' ' NOT NULL, /*工单号码*/
                                     /*工單號碼                               */
stg05       varchar2(16) DEFAULT ' ' NOT NULL, /*入库单号*/
                                     /*入庫單號                               */
stg051      number(5) DEFAULT '0' NOT NULL, /*入库单号-项次*/
                                     /*入庫單號-項次 (dennon 99/09/09)        */
stg06       date,                    /*入库日期                               */
                                     /*入庫日期                               */
stg07       number(15,3),            /*数量                                   */
                                     /*數量(若為退庫則數量為負數)             */
stg08       number(20,6),            /*单位标准成本:材料                      */
                                     /*單位標準成本:材料(累計)                */
stg09       number(20,6),            /*单位标准成本:人工                      */
                                     /*單位標準成本:人工(累計)                */
stg10       number(20,6),            /*单位标准成本:制费一                    */
                                     /*單位標準成本:製費一(累計)              */
stg11       number(20,6),            /*单位标准成本:制费二                    */
                                     /*單位標準成本:製費二(累計)              */
stg12       number(20,6),            /*标准成本:材料                          */
                                     /*標準成本:材料(單階)含下階人工,製費     */
stg13       number(20,6),            /*标准成本:人工                          */
                                     /*標準成本:人工(單階)                    */
stg14       number(20,6),            /*标准成本:制费一                        */
                                     /*標準成本:製費一(單階)                  */
stg15       number(20,6),            /*标准成本:制费二                        */
                                     /*標準成本:製費二(單階)                  */
stg16       number(20,6),            /*单位标准成本:材料                      */
                                     /*單位標準成本:材料(單階)                */
stg17       number(20,6),            /*单位标准成本:人工                      */
                                     /*單位標準成本:人工(單階)                */
stg18       number(20,6),            /*单位标准成本:制费一                    */
                                     /*單位標準成本:製費一(單階)              */
stg19       number(20,6),            /*单位标准成本:制费二                    */
                                     /*單位標準成本:製費二(單階)              */
stg20       varchar2(10),            /*仓库                                   */
                                     /*倉庫                                   */
stg21       varchar2(4),             /*币种                                   */
                                     /*幣別(委外工單使用)                     */
stg22       number(20,10),           /*汇率                                   */
                                     /*匯率(委外工單使用)                     */
stg23       number(20,6),            /*原币单价                               */
                                     /*原幣單價(委外工單使用)                 */
stg24       number(20,6),            /*本币单价                               */
                                     /*本幣單價(委外工單使用)                 */
stg25       number(20,6),            /*委外金额                               */
                                     /*委外金額(委外工單使用)                 */
stgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
stglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index stg_01 on stg_file (stg02,stg03,stg04,stg06);
alter table stg_file add  constraint stg_pk primary key  (stg01,stg02,stg03,stg04,stg05,stg051) enable validate;
grant select on stg_file to tiptopgp;
grant update on stg_file to tiptopgp;
grant delete on stg_file to tiptopgp;
grant insert on stg_file to tiptopgp;
grant index on stg_file to public;
grant select on stg_file to ods;
