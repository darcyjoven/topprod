/*
================================================================================
檔案代號:pie_file
檔案名稱:盘点标签明细-「在制工单」资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pie_file
(
pie01       varchar2(20) NOT NULL,   /*标签编号                               */
                                     /*標籤編號                               */
pie02       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
                                     /*儲存該工單所屬下階料件編號，應為被發放 */
                                     /*投入生產的料件編號，對「在製工單」而言 */
                                     /*亦是將作此料件數量的盤點。             */
pie03       varchar2(6),             /*作业编号                               */
                                     /*作業編號 99.12                         */
                                     /*原為smallint現改為char(06) 作業編號    */
                                     /*儲存該工單備料料件，預期投入生產的作業 */
                                     /*所屬作業編號；可由[工單檔]指定的製程編 */
                                     /*號及產品結構而得                       */
pie04       varchar2(4),             /*发料单位                               */
                                     /*發料單位                               */
                                     /*儲存該工單備料料件的發料單位。         */
pie05       varchar2(10),            /*工作站编号                             */
                                     /*工作站編號                             */
                                     /*儲存該下階料件應於何工作站被盤點       */
pie06       varchar2(1),             /*旗标                                   */
                                     /*旗標                                   */
                                     /*儲存備料料件的來源特性                 */
                                     /*正確值 E/U/V/R/N                       */
                                     /*E: 消耗性料件                          */
                                     /*U: 大宗自製料件                        */
                                     /*V: 大宗採購料件                        */
                                     /*R: 在製途料件                          */
                                     /*N: 除外一般料件                        */
pie07       number(5) NOT NULL,      /*生成项次                               */
                                     /*產生項次                               */
                                     /*系統自動賦予                           */
pie08       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
                                     /*儲存該筆「在製工單」空白標籤資料產生者。*/
pie09       date,                    /*生成日期                               */
                                     /*產生日期                               */
                                     /*儲存該筆「在製工單」空白標籤資料產生日期*/
pie11       number(15,3),            /*应发量                                 */
                                     /*應發量                                 */
                                     /*儲存該工單備料料件的應發量。           */
pie12       number(15,3),            /*已发量                                 */
                                     /*已發量                                 */
                                     /*儲存該工單備料料件的已發量。           */
pie13       number(15,3),            /*超领量                                 */
                                     /*超領量                                 */
                                     /*儲存該工單備料料件的超領量。           */
                                     /*實收量 ＝ 已發量 ＋ 超領量。           */
pie14       number(20,8),            /*标准单位用量                           */
                                     /*標準單位用量(QPA)                      */
pie15       number(15,3),            /*报废数量                               */
                                     /*報廢數量                               */
pie151      number(15,3),            /*代买数量                               */
                                     /*代買數量                               */
pie152      number(20,8),            /*发料单位/库存转换率                    */
                                     /*發料單位/庫存轉換率                    */
pie153      number(15,3),            /*应盘数量                               */
                                     /*Qty to Inventory Taking                */
                                     /*Actual Qty Taken = ((Complete/Store-in Qty + Scrap Qty) * qpa ) + Down Level Scrap*/
                                     /*Qty to Inventory Taking  = Issued Qty + Qty Over-Withdrawn - Actual Qty Taken*/
pie16       varchar2(1),             /*是否已作盘点「过帐」                   */
                                     /*是否已作盤點「過帳」                   */
                                     /*儲存該筆「在製工單」盤點資料是否已被作 */
                                     /*「過帳」處理。                         */
                                     /*--------------- 初盤資料 ---------------*/
pie30       number(15,3),            /*初盘（一）-- 盘点数量                  */
                                     /*初盤（一）-- 盤點數量                  */
                                     /*儲存該筆「在製工單」盤點資料在經過初盤 */
                                     /*作業後的被輸入的盤點數量。             */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*盤點過帳時可用此數量作為依據。         */
pie31       varchar2(10),            /*初盘（一）-- 资料录入人员编            */
                                     /*1st Inv.Tk(1)-- Data Entered Employee No.*/
                                     /*Store The Operational Person For Inputting Inventory Qty After 1st Inv.Tk。*/
pie32       date,                    /*初盘（一）-- 资料录入日期              */
                                     /*1st Inv.Tk(1)-- Data Entered Date      */
                                     /*Store The Operational Date For Inputting Inventory Qty After 1st Inv.Tk。*/
pie33       varchar2(8),             /*初盘（一）-- 资料录入时间              */
                                     /*1st Inv.Tk(1)-- Data Time Entered      */
                                     /*Store The Operational Time For Inputting Inventory Qty After 1st Inv.Tk。*/
pie34       varchar2(10),            /*初盘人员(一)                           */
                                     /*初盤人員(一)                           */
pie35       date,                    /*初盘日期(一)                           */
                                     /*初盤日期(一)                           */
pie40       number(15,3),            /*初盘（二）-- 盘点数量                  */
                                     /*初盤（二）-- 盤點數量                  */
                                     /*儲存該筆「在製工單」盤點資料在經過初盤 */
                                     /*作業後的被輸入的盤點數量。             */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*本欄位僅供比對參考，不作為過帳依據。   */
pie41       varchar2(10),            /*初盘（二）-- 资料录入人员编            */
                                     /*1st Inv.Tk(2)-- Data Entered Employee No.*/
                                     /*Store The Operational Person For Inputting Inventory Qty After 1st Inv.Tk。*/
pie42       date,                    /*初盘（二）-- 资料录入日期              */
                                     /*First Check 2-- Data input time        */
                                     /*Save the option time of Inventory data in the*/
                                     /*'In-Producting Work Order' task, which the time has*/
                                     /*been first-checked.                    */
pie43       varchar2(8),             /*初盘（二）-- 资料录入时间              */
                                     /*First Check 2-- Data input time        */
                                     /*Save the option time of Inventory data in the*/
                                     /*'In-Producting Work Order' task, which the time has*/
                                     /*been first-checked.                    */
pie44       varchar2(10),            /*初盘人员(二)                           */
                                     /*初盤人員(二)                           */
pie45       date,                    /*初盘日期(二)                           */
                                     /*初盤日期(二)                           */
                                     /*--------------- 複盤資料 ---------------*/
pie50       number(15,3),            /*复盘（一）-- 盘点数量                  */
                                     /*Retake Inventory 2-- Inventory Quantity*/
                                     /*Save the inputed quantity of Inventory data in the*/
                                     /*'In-Producting Work Order' task, which the quantity has*/
                                     /*been first-checked or spot-checked.    */
                                     /*The quantity could be used to post inventory.*/
pie51       varchar2(10),            /*复盘（一）-- 资料录入人员编            */
                                     /*2nd Inv.Taking(1)-- Data Typing Employee No.*/
                                     /*Store The Operational Person For Inputting Inventory Qty (IP W/O) After 1st Inv.Tk Or Selective Inv. Taking。*/
pie52       date,                    /*复盘（一）-- 资料录入日期              */
                                     /*2nd Inv.Taking(1) --Date of Entry      */
                                     /*Store The Operational Date For Inputting Inventory Qty (IP W/O) After 1st Inv.Tk Or Selective Inv. Taking。*/
pie53       varchar2(8),             /*复盘（一）-- 资料录入时间              */
                                     /*2nd Inv.Taking(1)-- Time Data Entered  */
                                     /*Store The Operational Time For Inputting Inventory Qty (IP W/O) After 1st Inv.Tk Or Selective Inv. Taking。*/
pie54       varchar2(10),            /*复盘人员(一)                           */
                                     /*複盤人員(一)                           */
pie55       date,                    /*复盘日期(一)                           */
                                     /*複盤日期(一)                           */
pie60       number(15,3),            /*复盘（二）-- 盘点数量                  */
                                     /*Retake Inventory 2-- Inventory Quantity*/
                                     /*Save the inputed quantity of Inventory data in the*/
                                     /*'In-Producting Work Order' task, which the quantity has*/
                                     /*been first-checked or spot-checked.    */
                                     /*The quantity unit is that of the inventory details.*/
                                     /*This feild is only used for comparation, but not as the*/
                                     /*basis of posting account。             */
pie61       varchar2(10),            /*复盘（二）-- 资料录入人员编            */
                                     /*複盤（二）-- 資料輸入人員代號          */
                                     /*儲存該筆「在製工單」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作人員。   */
pie62       date,                    /*复盘（二）-- 资料录入日期              */
                                     /*複盤（二）-- 資料輸入日期              */
                                     /*儲存該筆「在製工單」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作日期。   */
pie63       varchar2(8),             /*复盘（二）-- 资料录入时间              */
                                     /*複盤（二）-- 資料輸入時間              */
                                     /*儲存該筆「在製工單」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作時間。   */
pie64       varchar2(10),            /*复盘人员(二)                           */
                                     /*複盤人員(二)                           */
pie65       date,                    /*复盘日期(二)                           */
                                     /*複盤日期(二)                           */
pie66       number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
pie67       number(20,6),            /*现时成本                               */
                                     /*現時成本                               */
pie68       number(20,6),            /*缺省成本                               */
                                     /*預設成本                               */
                                     /*---------- 使用者自行定義欄位 ----------*/
pie900      varchar2(40),            /*取替代之主料                           */
                                     /*如無取替代此欄位為空白                 */
                                     /*原為 char(01)                          */
pie901      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pie902      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pie903      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pieplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pielegal    varchar2(10) NOT NULL,   /*所属法人                               */
pie012      varchar2(10),            /*工艺段号                               */
pie013      number(5) DEFAULT '0',   /*工艺序                                 */
pie27       varchar2(40),            /*No Use                                 */
piedate     date,                    /*盘点过账日                             */
pie70       varchar2(10)             /*理由码                                 */
);

create        index pie_02 on pie_file (pie02);
alter table pie_file add  constraint pie_pk primary key  (pie01,pie07) enable validate;
grant select on pie_file to tiptopgp;
grant update on pie_file to tiptopgp;
grant delete on pie_file to tiptopgp;
grant insert on pie_file to tiptopgp;
grant index on pie_file to public;
grant select on pie_file to ods;
