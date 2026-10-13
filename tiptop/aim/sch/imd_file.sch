/*
================================================================================
檔案代號:imd_file
檔案名稱:仓库资料主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table imd_file
(
imd01       varchar2(10) NOT NULL,   /*仓库                                   */
                                     /*倉庫別                                 */
                                     /*倉庫別存在系統中代表編號, 是唯一的     */
imd02       varchar2(80),            /*仓库名称                               */
                                     /*倉庫名稱                               */
                                     /*描述該倉庫別之簡稱                     */
imd03       varchar2(255),           /*地址一                                 */
                                     /*地址一    #genero 改為TEXTEDIT         */
                                     /*描述該倉庫別之地址                     */
imd04       varchar2(255),           /*地址二                                 */
                                     /*NO USE    #genero                      */
imd05       varchar2(255),           /*地址三                                 */
                                     /*NO USE    #genero                      */
imd06       varchar2(40),            /*负责人                                 */
                                     /*負責人                                 */
                                     /*儲存此倉庫別之負責人                   */
imd07       varchar2(40),            /*电话                                   */
                                     /*電話                                   */
                                     /*描述該倉庫別之電話                     */
imd08       varchar2(24),            /*存货科目                               */
                                     /*存貨科目                               */
imd09       varchar2(10),            /*成本仓库                               */
                                     /*成本庫別                               */
imd10       varchar2(1),             /*仓位类型                               */
                                     /*倉儲類別                               */
                                     /*正確值 'S' 或 'W'                      */
                                     /*S: 一般性倉庫  Store Warehouse         */
                                     /*   含 原物料, 半成品, 成品倉庫         */
                                     /*W: 在製品倉庫  WIP   Warehouse         */
imd11       varchar2(1),             /*是否为可用仓位                         */
                                     /*是否為可用倉儲                         */
                                     /*提供使用者於倉庫管理時區別出可用料件   */
                                     /*與不可用料件或報廢等倉儲管理　　　　　 */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 可用倉儲                            */
                                     /*N: 不可用倉儲                          */
imd12       varchar2(1),             /*是否为ＭＲＰ可用仓位                   */
                                     /*是否為ＭＲＰ可用倉儲                   */
                                     /*使用者可針對專案用料或非生產線之可用料 */
                                     /*來區別是否為物料需求可用料             */
                                     /*如為不可用倉庫, 則必定為MRP不可用倉庫  */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: ＭＲＰ可用                          */
                                     /*N: ＭＲＰ不可用                        */
imd13       varchar2(1),             /*保税与否                               */
                                     /*保稅與否                               */
                                     /*闡明該倉庫是否為保稅倉庫, 以便作保稅   */
                                     /*處理作業                               */
                                     /*正確值 'Y' 或 'N'                      */
                                     /*Y: 保稅倉儲                            */
                                     /*N: 非保稅倉儲                          */
imd14       number(5),               /*生产发料优先顺序                       */
                                     /*生產發料優先順序                       */
                                     /*於生產管理時可控制此倉庫發料優先順序   */
imd15       number(5),               /*销售领料优先顺序                       */
                                     /*銷售領料優先順序                       */
                                     /*於銷售管理時可控制此倉庫領料優先順序   */
imdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
imduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
imdgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
imdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
imddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
imd16       varchar2(10),            /*成本中心                               */
imd081      varchar2(24),            /*存货科目二                             */
imd17       varchar2(1) DEFAULT ' ' NOT NULL, /*是否限定为仓管员*/
imd18       varchar2(1) DEFAULT '0' NOT NULL, /*仓库属性 0_商品,1_赠品,2_样品,*/
imd19       varchar2(1) DEFAULT 'N' NOT NULL,
imd20       varchar2(10),            /*归属营运中心                           */
imd21       varchar2(24),            /*代销科目                               */
imd211      varchar2(24),            /*代销科目二                             */
imdpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
imdoriu     varchar2(10),            /*资料建立者                             */
imdorig     varchar2(10),            /*资料建立部门                           */
imd22       varchar2(1) DEFAULT 'N' NOT NULL, /*默认仓*/
imd23       varchar2(1) DEFAULT ' ' NOT NULL /*允许负库存*/
);

alter table imd_file add  constraint imd_pk primary key  (imd01) enable validate;
grant select on imd_file to tiptopgp;
grant update on imd_file to tiptopgp;
grant delete on imd_file to tiptopgp;
grant insert on imd_file to tiptopgp;
grant index on imd_file to public;
grant select on imd_file to ods;
