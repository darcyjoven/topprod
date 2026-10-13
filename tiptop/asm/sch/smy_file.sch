/*
================================================================================
檔案代號:smy_file
檔案名稱:制造管理系统
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table smy_file
(
smyslip     varchar2(5) NOT NULL,    /*单    别                               */
                                     /*單    別                               */
smydesc     varchar2(80),            /*单据名称                               */
                                     /*單據名稱                               */
smyauno     varchar2(1),             /*自动编号否                             */
                                     /*自動編號否(Y/N)                        */
smymxno     varchar2(20),            /*已用单号                               */
                                     /*已用單號                               */
smysys      varchar2(3),             /*系统                                   */
                                     /*系統別                                 */
                                     /*aim: 庫存管理系統                      */
                                     /*apm: 採購管理系統                      */
                                     /*asf: 生產管理系統                      */
                                     /*abm: 產品結構管理系統                  */
                                     /*aqc: 品質管理系統                      */
smykind     varchar2(2),             /*单据性质                               */
                                     /*單據性質                               */
                                     /*aim: 1: 發料單                         */
                                     /*     2: 收料單                         */
                                     /*     3: 報廢單                         */
                                     /*     4: 調撥單                         */
                                     /*     5: 盤點單                         */
                                     /*     6: 借入單  #BugNo:6817            */
                                     /*     7: 調撥調整單                     */
                                     /*     8: 其他異動單                     */
                                     /*     9: 兩階段調撥單                   */
                                     /*     A: 撥入單                         */
                                     /*     B: 週期調點單                     */
                                     /*     C: 還料單  #BugNo:6817 add        */
                                     /*----------------------------------------*/
                                     /*apm: 1: 請購單                         */
                                     /*     2: 採購單                         */
                                     /*     3: 收貨單                         */
                                     /*     4: 驗退/倉退單                    */
                                     /*     5: 核價單 (97/08 add)             */
                                     /*     6: 詢價單                         */
                                     /*     7: 入庫單                         */
                                     /*     8: 無交期採購單                   */
                                     /*----------------------------------------*/
                                     /*asf: 1: 工單                           */
                                     /*     2: Run Card                       */
                                     /*     3: 工單發料單                     */
                                     /*     4: 工單退料單                     */
                                     /*     7: 製造通知單                     */
                                     /*     8: PBI No.                        */
                                     /*     9: 工單作業移轉單                 */
                                     /*     A: 工單完工入庫/退回單            */
                                     /*     B: FQC(全檢)單                    */
                                     /*     C: 拆件式工單完工入庫             */
                                     /*     D: PQC                            */
                                     /*     E: 品質異常單                     */
                                     /*     F: 報廢單                         */
                                     /*     G: Run Card 製程調整單            */
                                     /*     H: Run Card 製程分割單            */
                                     /*     I: Run Card 製程合併單            */
                                     /*     M: 模具零件需求單                 */
                                     /*     N: 通知單                         */
                                     /*----------------------------------------*/
                                     /*abm: 1: 工程變異單                     */
                                     /*     2: 設計變更單                     */
                                     /*----------------------------------------*/
                                     /*aqc:1:品質異常單                       */
                                     /*      2:檢驗申請單                     */
smyapr      varchar2(1),             /*签核处理                               */
                                     /*簽核處理(Y/N)                          */
smyatsg     varchar2(1),             /*是否自动赋予签核等级                   */
                                     /*是否自動賦予簽核等級(Y/N)              */
smysign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
smydays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
smyprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
smyprint    varchar2(1),             /*立即打印                               */
                                     /*立即列印                               */
                                     /*單據輸入時是否立即列印                 */
smydmy1     varchar2(1),             /*计算成本否                             */
                                     /*是否為成會入項(Y/N)                    */
smydmy2     varchar2(1),             /*成会单据类型                           */
                                     /*Cost Accounting Doc Category (1/2/3/4/5/X)*/
                                     /*1.Store-in (Purchase, Manufactured, Subcontracting)*/
                                     /*2.Sales                                */
                                     /*3.Withdraw(W/O, MISC Issue)            */
                                     /*4.Transfer(Same plant/Same Item Code)  */
                                     /*5.Adjust(MISC Issue, Inventory Taking) */
                                     /*X.Un-Inventory Transaction             */
smydmy3     varchar2(1),             /*保税处理类型                           */
                                     /*保稅處理類別                           */
smydmy4     varchar2(1),             /*是否立即审核                           */
                                     /*是否立即確認                     (8506)*/
smydmy5     varchar2(1),             /*No Use                                 */
                                     /*編號方式  1.依流水號 2.依年月 3.依tlf905*/
smyware     varchar2(1),             /*仓库设限方式                           */
                                     /*倉庫設限方式                           */
smy51       varchar2(5),             /*对应验退单别                           */
                                     /*Corresponding Return Note Type         */
smy52       varchar2(5),             /*对应入库单别                           */
                                     /*對應入庫單別                     (86/07)*/
smy53       varchar2(1) DEFAULT ' ', /*两交内部交易单据否                     */
smy54       varchar2(24),            /*No Use                                 */
smy55       varchar2(5),             /*凭证分群码                             */
                                     /*傳票分群碼(拋轉傳票時的彙總代碼)       */
smy56       varchar2(1),             /*是否影响呆滞日期                       */
                                     /*是否影響呆滯日期(Y/N)                  */
smy57       varchar2(10),            /*第一码:工单工艺否                      */
                                     /*第一碼:工單制程否                      */
                                     /*第二碼:工單FQC否                       */
                                     /*第三碼:入庫單流水號是否預設同收貨單流水*/
                                     /*第四碼:是否走Blanket PO 流程           */
                                     /*第五碼:是否輸入手冊編號                */
                                     /*第六碼:委外型態                        */
                                     /*       委外工單對委外採購型態為  1: 一對一*/
                                     /*                                 2: 一對多*/
smy58       varchar2(1),             /*是否生成Run Card                       */
                                     /*是否產生Run Card                       */
smy59       varchar2(1),             /*是否做预算控管                         */
                                     /*是否做預算控管 (For 請採購預算)        */
smy60       varchar2(10),            /*成本中心                               */
                                     /*成本中心(for 6.00.04 製程成本)         */
smymemo1    varchar2(255),           /*备注                                   */
                                     /*備註                                   */
smymemo2    varchar2(255),           /*备注                                   */
                                     /*備註                                   */
smymemo3    varchar2(255),           /*备注                                   */
                                     /*備註                                   */
smyacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
smyuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
smygrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
smymodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
smydate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
smy61       varchar2(5),             /*对应杂发单别                           */
smy62       varchar2(10),            /*属性群组                               */
smy63       varchar2(5),             /*对应检验单别                           */
smy64       varchar2(1),             /*GPM整合单据控管方式                    */
smy65       varchar2(1),             /*是否抛转MES  ( N. 不抛转, Y. 要        */
smy69       varchar2(5),
smy70       varchar2(5),
smy71       varchar2(5),
smy67       varchar2(5),             /*报工单对应入库单别                     */
smy68       varchar2(5),             /*报工单对应FQC单别                      */
smy72       varchar2(10),            /*单据型态                               */
smyoriu     varchar2(10),            /*资料建立者                             */
smyorig     varchar2(10),            /*资料建立部门                           */
smy73       varchar2(1),             /*组合拆解单否                           */
smy74       varchar2(1) DEFAULT 'N', /*no use                                 */
smy75       varchar2(5),             /*对应PBI单别                            */
smy76       varchar2(5),             /*报工单对应委外采购单别                 */
smy77       varchar2(5),             /*报工单对应委外收货单别                 */
smy78       varchar2(5),             /*底稿类别产生方式                       */
smy79       varchar2(10),            /*在制盘差处理仓                         */
smyud01     varchar2(255),           /*自订字段                               */
smyud02     varchar2(40),            /*自订字段                               */
smyud03     varchar2(40),            /*自订字段                               */
smyud04     varchar2(40),            /*自订字段                               */
smyud05     varchar2(40),            /*自订字段                               */
smyud06     varchar2(255),           /*自订字段                               */
smyud07     number(15,3),            /*自订字段                               */
smyud08     number(15,3),            /*自订字段                               */
smyud09     number(15,3),            /*自订字段                               */
smyud10     number(10),              /*自订字段                               */
smyud11     number(10),              /*自订字段                               */
smyud12     number(10),              /*自订字段                               */
smyud13     date,                    /*自订字段                               */
smyud14     date,                    /*自订字段                               */
smyud15     date,                    /*自订字段                               */
smy80       varchar2(10)             /*预设机器编号                           */
);

alter table smy_file add  constraint smy_pk primary key  (smyslip) enable validate;
grant select on smy_file to tiptopgp;
grant update on smy_file to tiptopgp;
grant delete on smy_file to tiptopgp;
grant insert on smy_file to tiptopgp;
grant index on smy_file to public;
grant select on smy_file to ods;
