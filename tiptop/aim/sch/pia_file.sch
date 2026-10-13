/*
================================================================================
檔案代號:pia_file
檔案名稱:盘点标签明细-「现有库存」资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table pia_file
(
pia01       varchar2(20) NOT NULL,   /*标签编号                               */
                                     /*Label#                                 */
                                     /*Store Inventory Detail Taking Label No. Of (Qty On Hand) Inventory Data。*/
pia02       varchar2(40),            /*料件编号                               */
                                     /*Item#                                  */
                                     /*Store Inventory Detail Item No. Of (Qty On Hand) Inventory Data。*/
pia03       varchar2(10),            /*仓库                                   */
                                     /*Warehouse                              */
                                     /*Store Inventory Detail Warehouse Of (Qty On Hand) Inventory Data。*/
pia04       varchar2(10),            /*库位                                   */
                                     /*Location                               */
                                     /*Save the Location which include the inventory details of*/
                                     /*Quantity On Hand.                      */
pia05       varchar2(24),            /*批号                                   */
                                     /*Lot#                                   */
                                     /*Store Inventory Detail Storing Lot# Of (Qty On Hand) Inventory Data。*/
pia06       varchar2(10),            /*库存等级                               */
                                     /*Inventory Class                        */
                                     /*Store Inventory Detail Inventory Class Of (Qty On Hand) Inventory Data。*/
pia07       varchar2(24),            /*仓位会计科目                           */
                                     /*Warehouse Account                      */
                                     /*Store Inventory Detail Warehouse Account Of (Qty On Hand) Inventory Data。*/
pia08       number(15,3),            /*现有库存量                             */
                                     /*Qty On Hand                            */
                                     /*Store Qty On Hand Of The Inventory Sheet*/
pia09       varchar2(4),             /*库存单位                               */
                                     /*Inventory Unit                         */
                                     /*Store Inventory Detail Qty Unit Of (Qty On Hand) Inventory Data。*/
pia10       number(20,8),            /*库存单位与料件库存单位转换             */
                                     /*Inventory / Item Inv Unit Conv.Rate    */
                                     /*Store Inventory Detail Inventory / Item Inv Unit Conv.Rate Of (Qty On Hand) Inventory Data。*/
pia11       varchar2(10),            /*生成人员                               */
                                     /*產生人員                               */
                                     /*儲存該筆「現有庫存」盤點資料產生者。   */
pia12       date,                    /*生成日期                               */
                                     /*產生日期                               */
                                     /*儲存該筆「現有庫存」盤點資料產生日期。 */
pia13       date,                    /*修正日期                               */
                                     /*儲存該筆「現有庫存」盤點資料再修正日期。*/
pia14       date,                    /*打印日期                               */
                                     /*Printed Date                           */
                                     /*Store Latest Modified Date Of (Qty On Hand) Inventory Taking Data。*/
pia15       number(5),               /*打印次数                               */
                                     /*Printed Times                          */
                                     /*Store Sum Printed Times Of (Qty On Hand) Inventory Taking Data。*/
pia16       varchar2(1),             /*空白标签否                             */
                                     /*空白標籤否                             */
pia17       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pia18       varchar2(1),             /*当前尚未使用                           */
                                     /*目前尚未使用                           */
pia19       varchar2(1),             /*是否已作盘点「过帐」                   */
                                     /*是否已作盤點「過帳」                   */
                                     /*儲存該筆「現有庫存」盤點資料是否已被作 */
                                     /*「過帳」處理。                         */
                                     /*--------------- 初盤資料 ---------------*/
pia30       number(15,3),            /*初盘（一）-- 盘点数量                  */
                                     /*初盤（一）-- 盤點數量                  */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的被輸入的盤點數量。             */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*盤點過帳時可用此數量作為依據。         */
pia31       varchar2(10),            /*初盘（一）-- 资料录入人员编            */
                                     /*初盤（一）-- 資料輸入人員代號          */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作人員。         */
pia32       date,                    /*初盘（一）-- 资料录入日期              */
                                     /*初盤（一）-- 資料輸入日期              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作日期。         */
pia33       varchar2(8),             /*初盘（一）-- 资料录入时间              */
                                     /*初盤（一）-- 資料輸入時間              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作時間。         */
pia34       varchar2(10),            /*初盘人员(一)                           */
                                     /*初盤人員(一)                           */
pia35       date,                    /*初盘日期(一)                           */
                                     /*初盤日期(一)                           */
pia40       number(15,3),            /*初盘（二）-- 盘点数量                  */
                                     /*初盤（二）-- 盤點數量                  */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的被輸入的盤點數量。             */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*本欄位僅供比對參考，不作為過帳依據。   */
pia41       varchar2(10),            /*初盘（二）-- 资料录入人员编            */
                                     /*初盤（二）-- 資料輸入人員代號          */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作人員。         */
pia42       date,                    /*初盘（二）-- 资料录入日期              */
                                     /*初盤（二）-- 資料輸入日期              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作日期。         */
pia43       varchar2(8),             /*初盘（二）-- 资料录入时间              */
                                     /*初盤（二）-- 資料輸入時間              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*作業後的輸入盤點數量操作時間。         */
pia44       varchar2(10),            /*初盘人员(二)                           */
                                     /*初盤人員(二)                           */
pia45       date,                    /*初盘日期(二)                           */
                                     /*初盤日期(二)                           */
                                     /*--------------- 複盤資料 ---------------*/
pia50       number(15,3),            /*复盘（一）-- 盘点数量                  */
                                     /*複盤（一）-- 盤點數量                  */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的被輸入的盤點數量。       */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*盤點過帳時可用此數量作為依據。         */
pia51       varchar2(10),            /*复盘（一）-- 资料录入人员编            */
                                     /*複盤（一）-- 資料輸入人員代號          */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作人員。   */
pia52       date,                    /*复盘（一）-- 资料录入日期              */
                                     /*複盤（一）-- 資料輸入日期              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作日期。   */
pia53       varchar2(8),             /*复盘（一）-- 资料录入时间              */
                                     /*複盤（一）-- 資料輸入時間              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作時間。   */
pia54       varchar2(10),            /*复盘人员(一)                           */
                                     /*複盤人員(一)                           */
pia55       date,                    /*复盘日期(一)                           */
                                     /*複盤日期(一)                           */
pia60       number(15,3),            /*复盘（二）-- 盘点数量                  */
                                     /*複盤（二）-- 盤點數量                  */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的被輸入的盤點數量。       */
                                     /*其數量單位為該筆庫存明細之庫存單位。   */
                                     /*本欄位僅供比對參考，不作為過帳依據。   */
pia61       varchar2(10),            /*复盘（二）-- 资料录入人员编            */
                                     /*複盤（二）-- 資料輸入人員代號          */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作人員。   */
pia62       date,                    /*复盘（二）-- 资料录入日期              */
                                     /*複盤（二）-- 資料輸入日期              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作日期。   */
pia63       varchar2(8),             /*复盘（二）-- 资料录入时间              */
                                     /*複盤（二）-- 資料輸入時間              */
                                     /*儲存該筆「現有庫存」盤點資料在經過初盤 */
                                     /*或抽盤作業後的輸入盤點數量操作時間。   */
pia64       varchar2(10),            /*复盘人员(二)                           */
                                     /*複盤人員(二)                           */
pia65       date,                    /*复盘日期(二)                           */
                                     /*複盤日期(二)                           */
pia66       number(20,6),            /*标准成本                               */
                                     /*標準成本                               */
pia67       number(20,6),            /*现时成本                               */
                                     /*現時成本                               */
pia68       number(20,6),            /*缺省成本                               */
                                     /*預設成本                               */
                                     /*---------- 使用者自行定義欄位 ----------*/
pia900      varchar2(4),             /*保税盘点位置                           */
                                     /*保稅盤點位置                           */
pia901      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pia902      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pia903      varchar2(1),             /*用户自行定义                           */
                                     /*使用者自行定義                         */
pia930      varchar2(10),            /*成本中心                               */
pia931      varchar2(10),            /*底稿类型                               */
piaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
pialegal    varchar2(10) NOT NULL,   /*所属法人                               */
pia70       varchar2(10)             /*理由码                                 */
);

create        index pia_02 on pia_file (pia02);
create        index pia_03 on pia_file (pia02,pia03,pia04,pia05);
alter table pia_file add  constraint pia_pk primary key  (pia01) enable validate;
grant select on pia_file to tiptopgp;
grant update on pia_file to tiptopgp;
grant delete on pia_file to tiptopgp;
grant insert on pia_file to tiptopgp;
grant index on pia_file to public;
grant select on pia_file to ods;
