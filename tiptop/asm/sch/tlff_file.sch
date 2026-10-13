/*
================================================================================
檔案代號:tlff_file
檔案名稱:双单位异动记录档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table tlff_file
(
tlff01      varchar2(40),            /*异动料件编号                           */
                                     /*Transaction Item No.                   */
                                     /*Store Transaction Item                 */
                                     /*--Transaction Data Source--------      */
tlff02      number(5),               /*来源状况                               */
                                     /*Source Status                          */
                                     /*The Source Status that location have changed sort as follow:*/
                                     /*00: Adjust Inventory Taking            */
                                     /*   05: One-Step Adjust                 */
                                     /*   06: Two-Step Adjust                 */
                                     /*   07: Work Center Two-Step Adjust     */
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
tlff020     varchar2(10),            /*异动来源营运中心编号                   */
                                     /*营运中心编号                           */
tlff021     varchar2(10),            /*仓库                                   */
                                     /*Warehouse                              */
                                     /*Store Transaction Source Warehouse     */
tlff022     varchar2(10),            /*库位                                   */
                                     /*Location                               */
                                     /*Store Transaction Source Location      */
                                     /*Store Location Or Not, Considered Transaction Source Status Related Whith Inventory Or Not*/
tlff023     varchar2(24),            /*批号                                   */
                                     /*Lot# （Inventory Lot#）                */
                                     /*Store Transaction Source Inventory Lot#*/
                                     /*Store Inventory Lot# Or Not, Considered Transaction Source Status Related Whith Inventory Or Not*/
tlff024     number(15,3),            /*异动后库存数量                         */
                                     /*Inventory Qty after Transaction        */
                                     /*Store Source Inventory Qty after Transaction*/
                                     /*Store Inventory Qty after Transaction Or Not, Considered Transaction Source Status Related Whith Inventory Or Not*/
tlff025     varchar2(4),             /*异动后库存数量单位                     */
                                     /*Inventory Qty Unit after Transaction   */
                                     /*Store Source Inventory Qty Unit after Transaction*/
                                     /*Store Inventory Qty Unit after Transaction Or Not, Considered Transaction Source Status Related Whith Inventory Or Not*/
tlff026     varchar2(20),            /*单据编号                               */
                                     /*Document No.                           */
                                     /*Store Transaction Source Document No.  */
                                     /*Store Document No. Or Not, Considered Transaction Source Status Related Whith Document Or Not      Maybe P/O、Receiving Report、Goods Return Note、Scrap Note、Transfer Note、Issuing Note、 Borrowing Note....And So On*/
tlff027     number(5),               /*单据项次                               */
                                     /*Document Line No.                      */
                                     /*Store Transaction Source Document Line No.*/
                                     /*Store Document Line No. Or Not, Considered Transaction Source Status Related Whith Document Or Not. Ex. If There Is No Line# The Documents Of This Kind, Value Should Be 'NULL'*/
                                     /*---Data The Transactiong Taking Place(Purpose)---*/
tlff03      number(5),               /*目的状况                               */
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
tlff030     varchar2(10),            /*异动目的营运中心编号                   */
                                     /*营运中心编号                           */
tlff031     varchar2(10),            /*仓库                                   */
                                     /*Warehouse                              */
                                     /*Store Transaction Target W/H           */
tlff032     varchar2(10),            /*库位                                   */
                                     /*Location                               */
                                     /*Store Transaction Target Location      */
                                     /*Store Location Or Not, Considered Transaction Target Status Related Whith Inventory Or Not*/
tlff033     varchar2(24),            /*批号                                   */
                                     /*Lot# （Inventory Lot#）                */
                                     /*Store Transaction Target Inventory Lot#*/
                                     /*Store Inventory Lot# Or Not, Considered Transaction Target Status Related Whith Inventory Or Not*/
tlff034     number(15,3),            /*异动后库存数量                         */
                                     /*Inventory Qty after Transaction        */
                                     /*Store Target Inventory Qty after Transaction*/
                                     /*Store Inventory Qty after Transaction Or Not, Considered Transaction Target Status Related Whith Inventory Or Not*/
tlff035     varchar2(4),             /*异动后库存数量单位                     */
                                     /*Inventory Qty Unit after Transaction   */
                                     /*Store Target Inventory Qty Unit after Transaction*/
                                     /*Store Inventory Qty Unit after Transaction Or Not, Considered Transaction Target Status Related Whith Inventory Or Not*/
tlff036     varchar2(20),            /*单据编号                               */
                                     /*Document No.(Reference No.)            */
                                     /*Store Target Transaction Document No.  */
                                     /*Store Transaction Document No. Or Not, Considered Transaction Target Status Related Whith Document Or Not  Maybe P/O、Receiving Report、Goods Return Note、Scrap Note、Transfer Note、Issuing Note、 Borrowing Note....And So On*/
tlff037     number(5),               /*单据项次                               */
                                     /*Document Line No.                      */
                                     /*Store Target Transaction Source Document Line No.*/
                                     /*Store Document Line No. Or Not, Considered Transaction Target Status Related Whith Document Or Not. Ex. If There Is No Line# The Documents Of This Kind, Value Should Be 'NULL'*/
                                     /*---Transaction Data ------------------------------*/
tlff04      varchar2(10),            /*工作站                                 */
                                     /*Workstation                            */
                                     /*Store Transaction Workstation          */
tlff05      varchar2(6),             /*作业编号                               */
                                     /*Task No.                               */
                                     /*Store Transaction Task No.             */
tlff06      date,                    /*单据扣帐日期                           */
tlff07      date,                    /*运行扣帐日期                           */
                                     /*異動資料產生日期                       */
                                     /*儲存異動資料產生日期                   */
tlff08      varchar2(8),             /*异动资料生成时间                       */
                                     /*Transaction Data Generated Time (H:M:S)*/
                                     /*Store Transaction Data Generated Time  */
tlff09      varchar2(10),            /*异动资料发出者                         */
                                     /*Transaction Data Issued By             */
                                     /*Store Transaction Data Issued By       */
tlff10      number(15,3),            /*异动数量                               */
                                     /*Transaction Qty                        */
                                     /*Store Transaction Qty                  */
tlff11      varchar2(4),             /*异动数量单位                           */
                                     /*Transaction Qty Unit                   */
                                     /*Store Transaction Qty Unit             */
tlff12      number(20,8),            /*异动数量单位与异动目的数量             */
                                     /*Tran.Qt Unit/Tran Target Qt Unit Conversion Rt*/
                                     /*Store Tran.Qt Unit/Tran Target Qt Unit Conversion Rt*/
tlff13      varchar2(20),            /*异动指令编号                           */
                                     /*Transaction Command Code               */
                                     /*Store Transaction Command Code         */
tlff14      varchar2(10),            /*异动原因                               */
                                     /*Transaction Cause                      */
                                     /*Store Transaction Cause                */
                                     /*Transaction Cause Includes Return Cause、Scrap Cause*/
tlff15      varchar2(24),            /*借方会计科目                           */
                                     /*Debit Account (Update after Costing)   */
tlff16      varchar2(24),            /*贷方会计科目                           */
                                     /*Credit Account (Update after Costing)  */
tlff17      varchar2(255),           /*备注                                   */
                                     /*備註                                   */
tlff18      number(15,3),            /*异动后总库存量                         */
                                     /*Total Inventory Qty after Transaction  */
                                     /*Store Total Inventory Qty after Transaction*/
                                     /*Qty Unit Is The Item Inventory Unit（Item Master）*/
tlff19      varchar2(10),            /*异动厂商/客户编号/部门编号             */
                                     /*Transaction Vender# And Customer#/Department No.*/
                                     /*Store Transaction Vender# And Customer#*/
tlff20      varchar2(10),            /*项目号码                               */
                                     /*Project#                               */
                                     /*Store Transaction Project#             */
tlff21      number(20,6),            /*成会异动成本                           */
                                     /*Cost Actg Tran.Cost (Update aft Costing)*/
tlff211     date,                    /*成会计算日期                           */
                                     /*Cost Actg Costing Dt(Update aft Costing)*/
tlff212     varchar2(5),             /*成会计算时间                           */
                                     /*Cost Actg Costing Tm(Update aft Costing)*/
tlff2131    number(5),               /*No Use                                 */
tlff2132    number(5),               /*No Use                                 */
tlff214     number(5),               /*No Use                                 */
tlff215     number(5),               /*No Use                                 */
tlff2151    number(5),               /*No Use                                 */
tlff216     number(5),               /*No Use                                 */
tlff2171    number(5),               /*No Use                                 */
tlff2172    number(5),               /*No Use                                 */
tlff219     number(5),               /*1.第二单位   2.第一单位                */
                                     /*No-use            97/06/18             */
tlff218     varchar2(30),            /*第二单位的rowid内容                    */
                                     /*No-use            97/06/18             */
tlff220     varchar2(4),             /*单位  双单位的单位                     */
                                     /*No-use                   97/06/18      */
tlff221     number(20,6),            /*材料成本                               */
tlff222     number(20,6),            /*人工成本                               */
tlff2231    number(20,6),            /*制费成本                               */
                                     /*製費成本                               */
tlff2232    number(20,6),            /*加工成本                               */
tlff224     number(20,6),            /*其他成本                               */
tlff225     number(5),               /*No Use                                 */
tlff2251    number(5),               /*No Use                                 */
tlff226     number(5),               /*No Use                                 */
tlff2271    number(5),               /*No Use                                 */
tlff2272    number(5),               /*No Use                                 */
tlff229     number(5),               /*No Use                                 */
tlff230     number(5),               /*No Use                                 */
tlff231     number(5),               /*No Use                                 */
tlff60      number(20,8),            /*异动单据单位对库存单位之换             */
                                     /*Tran.Doc Unit/Inv.Unit(ima_file) Conversion Rate*/
tlff61      varchar2(5),             /*单别                                   */
                                     /*Document (=tlff905[1,3])          97/10/27*/
tlff62      varchar2(40),            /*工单单号                               */
                                     /*W/O No.                                */
tlff63      number(10),              /*No Use                                 */
tlff64      varchar2(20),            /*手册编号                               */
                                     /*Register Book No.  (A050)              */
tlff65      varchar2(20),            /*凭证编号                               */
                                     /*傳票編號                               */
tlff66      varchar2(1),             /*多仓出货 Flag                          */
                                     /*No use                                 */
tlff901     varchar2(1),             /*成本仓库                               */
                                     /*Cost Warehouse             97/08/23    */
                                     /*default=imd09                          */
tlff902     varchar2(10),            /*仓库                                   */
                                     /*Warehouse                97/06/18      */
tlff903     varchar2(10),            /*库位                                   */
                                     /*Location                 97/06/18      */
tlff904     varchar2(24),            /*批号                                   */
                                     /*Lot#                 97/06/18          */
tlff905     varchar2(20),            /*单号                                   */
                                     /*Document No.                 97/06/18  */
tlff906     number(5),               /*项次                                   */
                                     /*Line No.                 97/06/18      */
tlff907     number(5),               /*入出库码                               */
                                     /*Store-in/out Cd(1:St-in  -1:St-o  0:Othr*/
tlff908     varchar2(1),             /*保税审核否                             */
                                     /*保稅確認否                             */
tlff909     varchar2(1),             /*保税撷取否                             */
                                     /*保稅擷取否                             */
tlff910     varchar2(1),             /*合同撷取否                             */
tlff99      varchar2(17),            /*多角序号                               */
tlff930     varchar2(10),            /*成本中心                               */
tlff931     number(20,6),            /*内部成本                               */
tlffplant   varchar2(10) NOT NULL,   /*所属营运中心                           */
tlfflegal   varchar2(10) NOT NULL,   /*所属法人                               */
tlff27      varchar2(40),            /*取替代料号                             */
tlff012     varchar2(10),            /*工艺段号                               */
tlff013     number(5)                /*工艺序                                 */
);

create        index tlff_07 on tlff_file (tlff036,tlff037);
create        index tlff_04 on tlff_file (tlff905,tlff906);
create        index tlff_05 on tlff_file (tlff036);
create        index tlff_06 on tlff_file (tlff026,tlff027);
create        index tlff_03 on tlff_file (tlff62,tlff01);
create        index tlff99 on tlff_file (tlff99);
create        index tlff_01 on tlff_file (tlff01,tlff06);
grant select on tlff_file to tiptopgp;
grant update on tlff_file to tiptopgp;
grant delete on tlff_file to tiptopgp;
grant insert on tlff_file to tiptopgp;
grant index on tlff_file to public;
grant select on tlff_file to ods;
