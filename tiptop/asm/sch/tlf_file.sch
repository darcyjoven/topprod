/*
================================================================================
檔案代號:tlf_file
檔案名稱:异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tlf_file
(
tlf01       varchar2(40),            /*异动料件编号                           */
                                     /*異動料件編號                           */
                                     /*儲存異動料件                           */
                                     /*--異動經由何處所發生之資料(來源)--------*/
tlf02       number(5),               /*来源状况                               */
                                     /*Source Status                          */
                                     /*The Source Status that location have changed sort as follow:*/
                                     /*00: Adjust Inventory Taking            */
                                     /*   05: One-Step Adjust                 */
                                     /*   06: Two-Step Adjust                 */
                                     /*   07: Plant Two-Step Adjust           */
                                     /*10: Purchase                           */
                                     /*   11: General         Purchase Order  */
                                     /*   14: Consumption     Purchase Order  */
                                     /*   16: Capital Goods   Purchase Order  */
                                     /*   60: Subcontracting  Purchase Order  */
                                     /*20: Quality Control Zone               */
                                     /*25: F.Q.C.                             */
                                     /*30: Return Goods                       */
                                     /*   31: Return/Covering                 */
                                     /*   32: Return/Deduction                */
                                     /*40: Retire                             */
                                     /*50: Warehouse                          */
                                     /*   55: One-Step Transfer between Warehouse*/
                                     /*   56: Tow-Step Transfer between Warehouse*/
                                     /*   57: Work Center Transfer between Warehouse*/
                                     /*60: Work Order                         */
                                     /*   61: General Work Order              */
                                     /*   62: Final Assembly Work Order       */
                                     /*   63: Reprocess Work Order            */
                                     /*   64: Subcontracting Work Order       */
                                     /*   65: Disassembly Work Order          */
                                     /*   66: Multi-Plant Work Order          */
                                     /*70: Sales Order                        */
                                     /*   71: Manufacture Manage              */
                                     /*   72: Sales Manage                    */
                                     /*      722: Modify Delivery Line        */
                                     /*      723: Delete Delivery Line        */
                                     /*      724: Add Delivery Line           */
                                     /*      725: Delete All on Delivery Page */
                                     /*      731: Sales/Return Store-in       */
                                     /*      732: Modify Sales/Return Store-in Line*/
                                     /*      733: Delete Sales/Return Store-in Line*/
                                     /*      734: Add Sales/Return Store-in Line*/
                                     /*      735: Delete All on Sales/Return Store-in Page*/
                                     /*80: The Same Trade                     */
                                     /*90: MISC                               */
                                     /*100: MRB                               */
                                     /*   101: Accept                         */
                                     /*   102: Return/Covering Goods          */
                                     /*   103: Return Goods/Deduction         */
                                     /*   104: Retire                         */
                                     /*   105: Sort                           */
                                     /*   106: Reprocess                      */
                                     /*   107: No repeat any more!            */
                                     /*110:Reprocess                          */
                                     /*120:The Others(Exa:Apportioned Manufacture Expend)*/
tlf020      varchar2(10),            /*异动来源营运中心编号                   */
                                     /*营运中心编号                           */
tlf021      varchar2(10),            /*仓库                                   */
                                     /*倉庫別                                 */
                                     /*儲存發生異動的來源倉庫別               */
                                     /*視發生異動的來源狀況是否與庫存有關，而 */
                                     /*決定是否需儲存倉庫別                   */
tlf022      varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
                                     /*儲存發生異動的來源儲位                 */
                                     /*視發生異動的來源狀況是否與庫存有關，而 */
                                     /*決定是否需儲存儲位                     */
tlf023      varchar2(24),            /*批号                                   */
                                     /*批號 （庫存批號）                      */
                                     /*儲存發生異動的來源庫存批號             */
                                     /*視發生異動的來源狀況是否與庫存有關，而 */
                                     /*決定是否需儲存庫存批號                 */
tlf024      number(15,3),            /*异动后库存数量                         */
                                     /*異動後庫存數量                         */
                                     /*儲存發生異動的來源異動後庫存數量       */
                                     /*視發生異動的來源狀況是否與庫存有關，而 */
                                     /*決定是否需儲存異動後庫存數量           */
tlf025      varchar2(4),             /*异动后库存数量单位                     */
                                     /*異動後庫存數量單位                     */
                                     /*儲存發生異動的來源異動後庫存數量單位   */
                                     /*視發生異動的來源狀況是否與庫存有關，而 */
                                     /*決定是否需儲存異動後庫存數量單位       */
tlf026      varchar2(20),            /*单据编号                               */
                                     /*單據編號                               */
                                     /*儲存發生異動的來源異動單據編號         */
                                     /*視發生異動的來源狀況是否與單據有關，而 */
                                     /*決定是否需儲存異動單據，可能為採購單、 */
                                     /*驗收單、退貨單、報廢單、調撥單、發料單 */
                                     /*借料單....等                           */
tlf027      number(5),               /*单据项次                               */
                                     /*單據項次                               */
                                     /*儲存發生異動的來源異動單據明細項次     */
                                     /*視發生異動的來源狀況是否與單據有關，而 */
                                     /*決定是否需儲存異動單據明細項次資料，如 */
                                     /*該類單據無項次則其值應為'NULL'         */
                                     /*--異動至何處所發生之資料(目的)----------*/
tlf03       number(5),               /*目的状况                               */
                                     /*Target Status                          */
                                     /*The Target Status that location have changed sort as follow:*/
                                     /*00: Adjust Inventory Taking            */
                                     /*10: Purchase                           */
                                     /*    11: General         Purchase Order */
                                     /*    12: Subcontracting  Purchase Order */
                                     /*    13: Return/Covering Purchase Order */
                                     /*    14: Consumption     Purchase Order */
                                     /*    15: Service         Purchase Order */
                                     /*    16: Capital Goods   Purchase Order */
                                     /*    17: Multi-Plant     Purchase Order */
                                     /*    18: Indent          Purchase Order */
                                     /*20: Quality Control Zone               */
                                     /*25: F.Q.C.                             */
                                     /*30: Return Goods                       */
                                     /*    31:Return/Covering                 */
                                     /*    32:Return/Deduction                */
                                     /*40: Retire                             */
                                     /*50: Warehouse                          */
                                     /*    55: Transfer between Warehouse     */
                                     /*60: Work Order                         */
                                     /*    61 :General Work Order             */
                                     /*    62 :Final Assembly Work Order      */
                                     /*    63 :Reprocess Work Order           */
                                     /*    64 :Subcontracting Work Order      */
                                     /*    65 :Disassembly Work Order         */
                                     /*    66 :Multi-Plant Work Order         */
                                     /*70: Sales Order                        */
                                     /*    71: Manufacture Manage             */
                                     /*    72: Sales Manage                   */
                                     /*       722: Modify Delivery Line       */
                                     /*       723: Delete Delivery Line       */
                                     /*       724: Add Delivery Line          */
                                     /*       725: Delete All on Delivery Page*/
                                     /*       731: Sales/Return Store-in      */
                                     /*       732: Modify Sales/Return Store-in Line*/
                                     /*       733: Delete Sales/Return Store-in Line*/
                                     /*       734: Add Sales/Return Store-in Line*/
                                     /*       735: Delete All on Sales/Return Store-in Page*/
                                     /*80: The Same Trade                     */
                                     /*90: MISC                               */
                                     /*100: MRB                               */
                                     /*   101: Accept                         */
                                     /*   102: Return/Covering Goods          */
                                     /*   103: Return Goods/Deduction         */
                                     /*   104: Retire                         */
                                     /*   105: Sort                           */
                                     /*   106: Reprocess                      */
                                     /*   107: No repeat any more!            */
                                     /*110: Reprocess                         */
                                     /*120: The Others(Exa:Apportioned Manufacture Expend)*/
tlf030      varchar2(10),            /*异动目的营运中心编号                   */
                                     /*营运中心编号                           */
tlf031      varchar2(10),            /*仓库                                   */
                                     /*倉庫別                                 */
                                     /*儲存發生異動的目的倉庫別               */
                                     /*視發生異動的目的狀況是否與庫存有關，而 */
                                     /*決定是否需儲存倉庫別                   */
tlf032      varchar2(10),            /*库位                                   */
                                     /*儲位                                   */
                                     /*儲存發生異動的目的儲位                 */
                                     /*視發生異動的目的狀況是否與庫存有關，而 */
                                     /*決定是否需儲存儲位                     */
tlf033      varchar2(24),            /*批号                                   */
                                     /*批號 （庫存批號）                      */
                                     /*儲存發生異動的目的庫存批號             */
                                     /*視發生異動的目的狀況是否與庫存有關，而 */
                                     /*決定是否需儲存庫存批號                 */
tlf034      number(15,3),            /*异动后库存数量                         */
                                     /*異動後庫存數量                         */
                                     /*儲存發生異動的目的異動後庫存數量       */
                                     /*視發生異動的目的狀況是否與庫存有關，而 */
                                     /*決定是否需儲存異動後庫存數量           */
tlf035      varchar2(4),             /*异动后库存数量单位                     */
                                     /*異動後庫存數量單位                     */
                                     /*儲存發生異動的目的異動後庫存數量單位   */
                                     /*視發生異動的目的狀況是否與庫存有關，而 */
                                     /*決定是否需儲存異動後庫存數量單位       */
tlf036      varchar2(20),            /*单据编号                               */
                                     /*單據編號(參考號碼)                     */
                                     /*儲存發生異動的目的異動單據編號         */
                                     /*視發生異動的目的狀況是否與單據有關，而 */
                                     /*決定是否需儲存異動單據，可能為採購單、 */
                                     /*驗收單、退貨單、報廢單、調撥單、發料單 */
                                     /*借料單....等                           */
tlf037      number(5),               /*单据项次                               */
                                     /*單據項次                               */
                                     /*儲存發生異動的目的異動單據明細項次     */
                                     /*視發生異動的目的狀況是否與單據有關，而 */
                                     /*決定是否需儲存異動單據明細項次資料，如 */
                                     /*該類單據無項次則其值應為'NULL'         */
                                     /*--異動資料------------------------------*/
tlf04       varchar2(10),            /*工作站                                 */
                                     /*儲存發生異動的工作站                   */
tlf05       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存發生異動的作業編號                 */
tlf06       date,                    /*单据扣帐日期                           */
tlf07       date,                    /*运行扣帐日期                           */
                                     /*異動資料產生日期                       */
                                     /*儲存異動資料產生日期                   */
tlf08       varchar2(8),             /*异动资料生成时间                       */
                                     /*異動資料產生時間 (時:分:秒)            */
                                     /*儲存異動資料產生時間                   */
tlf09       varchar2(10),            /*异动资料发出者                         */
                                     /*異動資料發出者                         */
                                     /*儲存異動資料產生者                     */
tlf10       number(15,3),            /*异动数量                               */
                                     /*異動數量                               */
                                     /*儲存異動數量                           */
tlf11       varchar2(4),             /*异动数量单位                           */
                                     /*異動數量單位                           */
                                     /*儲存異動數量單位                       */
tlf12       number(20,8),            /*异动数量单位与异动目的数量             */
                                     /*異動數量單位與異動目的數量單位轉換率   */
                                     /*儲存異動數量單位與異動目的數量單位之間 */
                                     /*的轉換率                               */
tlf13       varchar2(20),            /*异动指令编号                           */
                                     /*異動命令代號                           */
                                     /*儲存異動命令代號                       */
tlf14       varchar2(10),            /*异动原因                               */
                                     /*異動原因                               */
                                     /*儲存異動原因                           */
                                     /*異動原因包括退貨原因、報廢原因         */
tlf15       varchar2(24),            /*借方会计科目                           */
                                     /*借方會計科目 (成本計算後更新)          */
tlf16       varchar2(24),            /*贷方会计科目                           */
                                     /*貸方會計科目 (成本計算後更新)          */
tlf17       varchar2(255),           /*备注                                   */
                                     /*備註                                   */
tlf18       number(15,3),            /*异动后总库存量                         */
                                     /*異動後總庫存量                         */
                                     /*儲存異動後該料件總庫存數量             */
                                     /*數量單位為該料件庫存單位（料件主檔）   */
tlf19       varchar2(10),            /*异动厂商/客户编号/部门编号             */
                                     /*Transaction Vender No. And Customer No./Department No. Store Transaction Vender No. And Customer No.*/
tlf20       varchar2(10),            /*项目号码                               */
                                     /*專案號碼                               */
                                     /*儲存異動有關的專案號碼                 */
tlf21       number(20,6),            /*成会异动成本                           */
                                     /*成會異動成本 (成會計算後更新)          */
tlf211      date,                    /*成会计算日期                           */
                                     /*成會計算日期 (成本計算後更新)          */
tlf212      varchar2(8),             /*成会计算时间                           */
                                     /*成會計算時間 (成本計算後更新)          */
tlf2131     number(5),               /*No Use                                 */
tlf2132     number(5),               /*No Use                                 */
tlf214      number(5),               /*No Use                                 */
tlf215      number(5),               /*No Use                                 */
tlf2151     number(5),               /*No Use                                 */
tlf216      number(5),               /*No Use                                 */
tlf2171     number(5),               /*No Use                                 */
tlf2172     number(5),               /*No Use                                 */
tlf219      number(5),               /*1.第二单位   2.第一单位                */
                                     /*No-use            97/06/18             */
tlf218      varchar2(30),            /*第二单位的rowid内容                    */
                                     /*No-use            97/06/18             */
tlf220      varchar2(4),             /*单位  双单位的单位                     */
                                     /*No-use            97/06/18             */
tlf221      number(20,6),            /*材料成本                               */
tlf222      number(20,6),            /*人工成本                               */
tlf2231     number(20,6),            /*制费成本                               */
                                     /*製費成本                               */
tlf2232     number(20,6),            /*加工成本                               */
tlf224      number(20,6),            /*其他成本                               */
tlf225      number(5),               /*No Use                                 */
tlf2251     number(5),               /*No Use                                 */
tlf226      number(5),               /*No Use                                 */
tlf2271     number(5),               /*No Use                                 */
tlf2272     number(5),               /*No Use                                 */
tlf229      number(5),               /*No Use                                 */
tlf230      number(5),               /*No Use                                 */
tlf231      number(5),               /*No Use                                 */
tlf60       number(20,8),            /*异动单据单位对库存单位之换             */
                                     /*異動單據單位對庫存單位(ima_file)之換算率*/
tlf61       varchar2(5),             /*单别                                   */
                                     /*單別 (=tlf905[1,3])          97/10/27  */
tlf62       varchar2(40),            /*工单单号                               */
                                     /*工單單號                               */
tlf63       number(10),              /*No Use                                 */
tlf64       varchar2(20),            /*手册编号                               */
tlf65       varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
tlf66       varchar2(1),             /*多仓出货 Flag                          */
tlf901      varchar2(10),            /*成本仓库                               */
                                     /*成本庫別             97/08/23          */
                                     /*default=imd09                          */
tlf902      varchar2(10),            /*仓库                                   */
                                     /*倉庫                 97/06/18          */
tlf903      varchar2(10),            /*库位                                   */
                                     /*儲位                 97/06/18          */
tlf904      varchar2(24),            /*批号                                   */
                                     /*批號                 97/06/18          */
tlf905      varchar2(20),            /*单号                                   */
                                     /*單號                 97/06/18          */
tlf906      number(5),               /*项次                                   */
                                     /*項次                 97/06/18          */
tlf907      number(5),               /*入出库码                               */
                                     /*入出庫碼 (1:入庫   -1:出庫   0:其它    */
tlf908      varchar2(1),             /*保税审核否                             */
                                     /*保稅確認否                             */
tlf909      varchar2(1),             /*保税撷取否                             */
                                     /*保稅擷取否                             */
tlf910      varchar2(1),             /*合同撷取否                             */
tlf99       varchar2(17),            /*多角序号                               */
tlf930      varchar2(10),            /*成本中心                               */
tlf931      number(20,6),            /*内部成本                               */
tlf151      varchar2(24),            /*借方会计科目二                         */
                                     /*借方會計科目 (成本計算後更新)          */
tlf161      varchar2(24),            /*贷方会计科目二                         */
                                     /*貸方會計科目 (成本計算後更新)          */
tlf2241     number(20,6) DEFAULT '0',/*制费三成本                             */
tlf2242     number(20,6) DEFAULT '0',/*制费四成本                             */
tlf2243     number(20,6) DEFAULT '0',/*制费五成本                             */
tlfcost     varchar2(40),            /*类别代号(批次号/专案号/利润            */
tlf41       varchar2(30),            /*WBS编码                                */
tlf42       varchar2(4),             /*活动编号                               */
tlf43       varchar2(10),            /*理由码                                 */
tlf211x     date,                    /*成会计算日期                           */
tlf212x     varchar2(8),             /*成会计算时间                           */
tlf21x      number(20,6),            /*成会异动成本                           */
tlf221x     number(20,6),            /*材料成本                               */
tlf222x     number(20,6),            /*人工成本                               */
tlf2231x    number(20,6),            /*制费一成本                             */
tlf2232x    number(20,6),            /*加工成本                               */
tlf2241x    number(20,6),            /*制费三成本                             */
tlf2242x    number(20,6),            /*制费四成本                             */
tlf2243x    number(20,6),            /*制费五成本                             */
tlf224x     number(20,6),            /*制费二成本                             */
tlf65x      varchar2(20),            /*凭证编号                               */
tlfplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
tlflegal    varchar2(10) NOT NULL,   /*所属法人                               */
tlf27       varchar2(40),            /*被替代料号                             */
tlf28       varchar2(1),             /*成会分类                               */
tlf012      varchar2(10),            /*工艺段号                               */
tlf013      number(5),               /*工艺序                                 */
tlf920      varchar2(1)              /*需立賬否                               */
);

create        index tlf_04 on tlf_file (tlf905,tlf906);
create        index tlf99 on tlf_file (tlf99);
create        index tlf_10 on tlf_file (tlfcost);
create        index tlf_05 on tlf_file (tlf036);
create        index tlf_06 on tlf_file (tlf026,tlf027);
create        index tlf_01 on tlf_file (tlf01,tlf06);
create        index tlf_07 on tlf_file (tlf036,tlf037);
create        index tlf_03 on tlf_file (tlf62,tlf01);
grant select on tlf_file to tiptopgp;
grant update on tlf_file to tiptopgp;
grant delete on tlf_file to tiptopgp;
grant insert on tlf_file to tiptopgp;
grant index on tlf_file to public;
grant select on tlf_file to ods;
