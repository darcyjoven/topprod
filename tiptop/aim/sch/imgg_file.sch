/*
================================================================================
檔案代號:imgg_file
檔案名稱:多单位库存明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table imgg_file
(
imgg00      varchar2(1),             /*区分双单位类型(1.母子单位  2.          */
imgg01      varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*Store Location Item#                   */
imgg02      varchar2(10) NOT NULL,   /*仓库编号                               */
                                     /*Store Warehouse # Of The Item          */
imgg03      varchar2(10) NOT NULL,   /*库位                                   */
                                     /*Store Location Of The Item             */
imgg04      varchar2(24) NOT NULL,   /*批号                                   */
                                     /*Store Purchasing Lot# Of The Item      */
imgg05      varchar2(20),            /*参考号码                               */
                                     /*Value Maybe Receiving Report No., P/O No. As  Receive Doc. System Maintain*/
imgg06      number(5),               /*参考序号                               */
                                     /*Value Maybe Receiving Report Line#, P/O Line# As  Receive Doc. Line#. System Maintain*/
imgg07      varchar2(4),             /*采购单位/生产单位(收料单位)            */
                                     /*System Maintain                        */
imgg08      number(15,3),            /*收货数量(进货数量)                     */
                                     /*Unit Using Purchasing/Production Unit  */
                                     /*System Maintain                        */
imgg09      varchar2(4) NOT NULL,    /*库存单位                               */
                                     /*img Unit                               */
imgg10      number(15,3) NOT NULL,   /*库存数量                               */
                                     /*Store Sum Inventory Qty Of The Item In One WH/L*/
imgg11      number(15,3),            /*No Use                                 */
imgg12      number(15,3),            /*No Use                                 */
imgg13      date,                    /*制造日期
                                                                                    */
imgg14      date,                    /*最近一次盘点日期                       */
                                     /*Store Item WH/L Latest Inventory Taking Date*/
                                     /*System Maintain                        */
imgg15      date,                    /*最近一次收料日期                       */
                                     /*Store Item WH/L Latest Purchase Item Receipt Date*/
                                     /*System Maintain                        */
imgg16      date,                    /*最近一次发料日期                       */
                                     /*Store Item WH/L Latest Issuing Date    */
                                     /*System Maintain                        */
imgg17      date,                    /*最近一次异动日期                       */
                                     /*Store Item WH/L Latest Purchase/Out-Item Date*/
                                     /*System Maintain                        */
imgg18      date,                    /*有效日期                               */
                                     /*Store Item Using Valid Date,There is Time Limit Of Item Using,Can Create Ending Date When Maintain*/
imgg19      varchar2(10),            /*库存等级                               */
                                     /*Desc. Inventory Class Differentiated By Item*/
imgg20      number(20,8),            /*单位数量换算率                         */
                                     /*Item Receipt Unit - Inventory Unit Conversion Rate*/
imgg21      number(20,8) NOT NULL,   /*单位数量换算率-对ima25                 */
                                     /*img-ima Conversion Rate                */
imgg22      varchar2(1),             /*仓位类型                               */
                                     /*Right Value 'S' 或 'W'                 */
                                     /*S: General Warehouse  Store Warehouse  */
                                     /*   Contain Raw Material, Semi-Product, Finished Product Warehouse*/
                                     /*W: Processing Product Warehouse WIP   Warehouse*/
imgg23      varchar2(1),             /*是否为可用仓位                         */
                                     /*Supply User The WH/L Management: Distinguish The Usable Item And Unusable Or Scrap */
                                     /*Right Value 'Y' Or 'N'                 */
                                     /*Y: Usable WH/L                         */
                                     /*N: Unusable WH/L                       */
imgg24      varchar2(1),             /*是否为ｍｒｐ可用仓位                   */
                                     /*The user can distinguish if it is the Required */
                                     /*Material of Available according to Project Mateiral or*/
                                     /*Useable Mateiral not on Production Line,if the */
                                     /*warehouse is unusable, then it must be unavaiable MRP */
                                     /*warehouse.                             */
                                     /*The choose list show as follow:        */
                                     /*Y: ＭＲＰ Available                    */
                                     /*N: ＭＲＰ Unavailable                  */
imgg25      varchar2(1),             /*保税与否                               */
                                     /*Clarify The Warehouse Bonded Or Not,In Order To Run Bonded Processing*/
                                     /*Right Value 'Y' Or 'N'                 */
                                     /*Y: Bonded Warehouse                    */
                                     /*N: Not Bonded Warehouse                */
imgg26      varchar2(24),            /*仓位所属会计科目                       */
                                     /*Clarify Account Of The Warehouse　     */
imgg27      number(5),               /*工单发料优先顺序                       */
imgg28      number(5),               /*销售出货优先顺序                       */
imgg30      number(20,6),            /*直接材料成本                           */
                                     /*Cost Using The Follow Two Calculating Method          */
                                     /*fifo :First In First Out                         lifo :Last In First Out*/
imgg31      number(20,6),            /*间接材料成本                           */
                                     /*成本使用計算方式為以下兩種使用:         */
                                     /*fifo :先進先出                          */
                                     /*lifo :后進先出                          */
                                     /*儲存當時間接材料成本                   */
imgg32      number(20,6),            /*委外加工材料成本                       */
                                     /*Cost caculate methods show as follow:         */
                                     /*fifo :First In First Out                          */
                                     /*lifo :Last In First Out                          */
                                     /*Save Subcontracting Labour Cost of Then　　*/
imgg33      number(20,6),            /*委外加工人工成本                       */
                                     /*Cost caculate methods show as follow:         */
                                     /*fifo :First In First Out                          */
                                     /*lifo :Last In First Out                          */
                                     /*Save Subcontracting Labour Cost of Then　　*/
imgg34      number(20,8),            /*库存单位对成本单位的转换率             */
                                     /*Inventory Unit Converse To Cost Unit Druing Multi-Unit Using*/
imgg35      varchar2(10),            /*项目号码                               */
                                     /*Desc. The Item Used For One Project Or Not*/
imgg36      varchar2(4),             /*外观编号                               */
                                     /*Desc. Look No. Of The Item             */
imgg37      date,                    /*呆滞日期                               */
imgg211     number(20,8) NOT NULL,   /*单位数量换算率-对img09                 */
imggplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
imgglegal   varchar2(10) NOT NULL    /*所属法人                               */
);

alter table imgg_file add  constraint imgg_pk primary key  (imgg01,imgg02,imgg03,imgg04,imgg09) enable validate;
grant select on imgg_file to tiptopgp;
grant update on imgg_file to tiptopgp;
grant delete on imgg_file to tiptopgp;
grant insert on imgg_file to tiptopgp;
grant index on imgg_file to public;
grant select on imgg_file to ods;
