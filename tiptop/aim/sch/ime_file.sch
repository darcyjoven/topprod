/*
================================================================================
檔案代號:ime_file
檔案名稱:仓库/存放位置资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table ime_file
(
ime01       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*倉庫編號                               */
                                     /*儲存該倉庫別之編號                     */
ime02       varchar2(10) NOT NULL,   /*库位                                   */
                                     /*儲位                                   */
                                     /*儲存該倉庫別之下細分出之儲位           */
ime03       varchar2(80),            /*库位名称                               */
                                     /*儲位名稱                               */
                                     /*描述該儲位之簡稱                       */
ime04       varchar2(1),             /*仓位类型                               */
                                     /*倉儲類別                               */
                                     /*正確值 'S' 或 'W'                      */
                                     /*S: 一般性倉庫  Store Warehouse         */
                                     /*   含 原物料, 半成品, 成品倉庫         */
                                     /*W: 在製品倉庫  WIP   Warehouse         */
ime05       varchar2(1),             /*是否为可用仓位                         */
                                     /*是否為可用倉儲                         */
                                     /*提供使用者於倉庫管理時區別出可用料件   */
                                     /*與不可用料件或報廢等倉儲管理　　　　　 */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 可用倉儲                            */
                                     /*N: 不可用倉儲                          */
ime06       varchar2(1),             /*是否为ＭＲＰ可用仓位                   */
                                     /*是否為ＭＲＰ可用倉儲                   */
                                     /*使用者可針對專案用料或非生產線之可用料 */
                                     /*來區別是否為物料需求可用料             */
                                     /*如為不可用倉庫, 則必定為MRP不可用倉庫  */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: ＭＲＰ可用                          */
                                     /*N: ＭＲＰ不可用                        */
ime07       varchar2(1),             /*保税与否                               */
                                     /*保稅與否                               */
                                     /*闡明該倉庫是否為保稅倉庫, 以便作 保稅  */
                                     /*處理作業                               */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 保稅倉儲                            */
                                     /*N: 非保稅倉儲                          */
ime08       varchar2(1),             /*会计科目自动显示方式                   */
                                     /*會計科目自動顯示方式                   */
                                     /*正確值 '0' 或 '1' 或 '2'               */
                                     /*0: 使用者自行輸入會計科目              */
                                     /*1: 使用料件主檔[ima_file]會計科目      */
                                     /*2: 使用倉儲[ime_file]會計科目          */
ime09       varchar2(24),            /*仓位所属会计科目                       */
                                     /*倉儲所屬會計科目                       */
                                     /*闡明此倉儲所屬會計科目　　　　　　　　　*/
ime10       number(5),               /*工单发料优先顺序                       */
                                     /*工單發料優先順序                       */
                                     /*於生產管理時可控制此倉庫發料優先順序   */
ime11       number(5),               /*销售出货优先顺序                       */
                                     /*銷售出貨優先順序                       */
                                     /*於銷售管理時可控制此倉庫領料優先順序   */
ime091      varchar2(24),            /*存货科目二                             */
ime17       varchar2(1) DEFAULT ' ' NOT NULL, /*是否限定为仓管员*/
ime12       varchar2(1) DEFAULT '0', /*VMI特性                                */
ime13       varchar2(24),            /*代销科目                               */
ime131      varchar2(24),            /*代销科目二                             */
imeacti     varchar2(1) DEFAULT 'Y' NOT NULL /*库位有效码*/
);

alter table ime_file add  constraint ime_pk primary key  (ime01,ime02) enable validate;
grant select on ime_file to tiptopgp;
grant update on ime_file to tiptopgp;
grant delete on ime_file to tiptopgp;
grant insert on ime_file to tiptopgp;
grant index on ime_file to public;
grant select on ime_file to ods;
