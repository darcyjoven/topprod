/*
================================================================================
檔案代號:img_file
檔案名稱:库存资料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table img_file
(
img01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
                                     /*儲存存放地點的料件編號                 */
img02       varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*倉庫編號                               */
                                     /*儲存料件所在之倉庫編號                 */
img03       varchar2(10) NOT NULL,   /*库位                                   */
                                     /*儲位                                   */
                                     /*儲存料件所在之儲位                     */
img04       varchar2(24) NOT NULL,   /*批号                                   */
                                     /*批號(進貨)                             */
                                     /*儲存料件所在之進貨批號                 */
img05       varchar2(20),            /*参考号码                               */
                                     /*參考號碼                               */
                                     /*其值可能為驗收單號.採購單號等進貨單    */
                                     /*系統維護                               */
img06       number(5),               /*参考序号                               */
                                     /*Reference Serial No.                   */
                                     /*Value Maybe Receiving Report Line #;P/O Line # And So On Like Receipt Line # System Maintain*/
img07       varchar2(4),             /*采购单位/生产单位                      */
                                     /*採購單位/生產單位(收料單位)            */
                                     /*系統維護                               */
img08       number(15,3),            /*收货数量                               */
                                     /*收貨數量(進貨數量)                     */
                                     /*單位使用採購/生產單位                  */
                                     /*系統維護                               */
img09       varchar2(4),             /*库存单位                               */
                                     /*庫存單位                               */
                                     /*img之單位                              */
img10       number(15,3) NOT NULL,   /*库存数量                               */
                                     /*庫存數量                               */
                                     /*儲存料件在某倉儲下之庫存總數量         */
img11       number(15,3),            /*No Use                                 */
img12       number(15,3),            /*No Use                                 */
img13       date,                    /*制造日期                               */
img14       date,                    /*最近一次盘点日期                       */
                                     /*最近一次盤點日期                       */
                                     /*儲存料件倉儲最近一次盤點日期           */
                                     /*系統維護                               */
img15       date,                    /*最近一次收料日期                       */
                                     /*儲存料件倉儲最近一次收料日期           */
                                     /*系統維護                               */
img16       date,                    /*最近一次发料日期                       */
                                     /*最近一次發料日期                       */
                                     /*儲存料件倉儲最近一次發料日期           */
                                     /*系統維護                               */
img17       date,                    /*最近一次异动日期                       */
                                     /*最近一次異動日期                       */
                                     /*儲存料件倉儲最近一之進出料日期         */
                                     /*系統維護                               */
img18       date,                    /*有效日期                               */
                                     /*Expiry Date                            */
                                     /*Store Item Using Valid Date,There is Time Limit Of Item Using,Can Create Ending Date When Maintain*/
img19       varchar2(10),            /*库存等级                               */
                                     /*庫存等級                               */
                                     /*描述料件所區分出之庫存等級             */
img20       number(20,8),            /*单位数量换算率                         */
                                     /*單位數量換算率                         */
                                     /*收料單位對庫存單位換算率               */
img21       number(20,8) NOT NULL,   /*单位数量换算率-对料件库存单            */
                                     /*單位數量換算率-對料件庫存單位          */
                                     /*img對ima換算率                         */
img22       varchar2(1),             /*仓位类型                               */
                                     /*倉儲類別                               */
                                     /*正確值 'S' 或 'W'                      */
                                     /*S: 一般性倉庫  Store Warehouse         */
                                     /*   含 原物料, 半成品, 成品倉庫         */
                                     /*W: 在製品倉庫  WIP   Warehouse         */
img23       varchar2(1),             /*是否为可用仓位                         */
                                     /*是否為可用倉儲                         */
                                     /*提供使用者於倉庫管理時區別出可用料件   */
                                     /*與不可用料件或報廢等倉儲管理　　　　　 */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 可用倉儲                            */
                                     /*N: 不可用倉儲                          */
img24       varchar2(1),             /*是否为ＭＲＰ可用仓位                   */
                                     /*是否為ＭＲＰ可用倉儲                   */
                                     /*使用者可針對專案用料或非生產線之可用料 */
                                     /*來區別是否為物料需求可用料             */
                                     /*如為不可用倉庫, 則必定為MRP不可用倉庫  */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: ＭＲＰ可用                          */
                                     /*N: ＭＲＰ不可用                        */
img25       varchar2(1),             /*保税与否                               */
                                     /*保稅與否                               */
                                     /*闡明該倉庫是否為保稅倉庫, 以便作保稅   */
                                     /*處理作業                               */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 保稅倉儲                            */
                                     /*N: 非保稅倉儲                          */
img26       varchar2(24),            /*仓位所属会计科目                       */
                                     /*倉儲所屬會計科目                       */
                                     /*闡明此倉儲所屬會計科目　　　　　　　　　*/
img27       number(5),               /*工单发料优先顺序                       */
                                     /*工單發料優先順序                       */
img28       number(5),               /*销售出货优先顺序                       */
                                     /*銷售出貨優先順序                       */
img30       number(20,6),            /*直接材料成本                           */
                                     /*成本使用計算方式為以下兩種使用:        */
                                     /*FIFO :先進先出                         */
                                     /*LIFO :後進先出                         */
                                     /*儲存當時材料成本    　　　　　　　     */
img31       number(20,6),            /*间接材料成本                           */
                                     /*間接材料成本                           */
                                     /*成本使用計算方式為以下兩種使用:        */
                                     /*FIFO :先進先出                         */
                                     /*LIFO :後進先出                         */
                                     /*儲存當時間接材料成本                   */
img32       number(20,6),            /*委外加工材料成本                       */
                                     /*廠外加工材料成本                       */
                                     /*成本使用計算方式為以下兩種使用:        */
                                     /*FIFO :先進先出                         */
                                     /*LIFO :後進先出                         */
                                     /*儲存當時廠外加工材料成本               */
img33       number(20,6),            /*委外加工人工成本                       */
                                     /*廠外加工人工成本                       */
                                     /*成本使用計算方式為以下兩種使用:        */
                                     /*FIFO :先進先出                         */
                                     /*LIFO :後進先出                         */
                                     /*儲存當時廠外加工人工成本　　　　　     */
img34       number(20,8),            /*库存单位对成本单位的转换率             */
                                     /*Inv to Cost Unit Conversion Rate       */
                                     /*When Use Multi-Unit Inv Unit Conv. To Cost Unit*/
img35       varchar2(10),            /*项目号码                               */
                                     /*專案號碼                               */
                                     /*闡述此批料件是否針對某一專案使用　     */
img36       varchar2(4),             /*外观编号                               */
                                     /*外觀編號                               */
                                     /*闡述此批料件之外觀編號                 */
img37       date,                    /*呆滞日期                               */
                                     /*呆滯日期                               */
img38       varchar2(255),           /*备注                                   */
imgplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
imglegal    varchar2(10) NOT NULL    /*所属法人                               */
);

alter table img_file add  constraint img_pk primary key  (img01,img02,img03,img04) enable validate;
grant select on img_file to tiptopgp;
grant update on img_file to tiptopgp;
grant delete on img_file to tiptopgp;
grant insert on img_file to tiptopgp;
grant index on img_file to public;
grant select on img_file to ods;
