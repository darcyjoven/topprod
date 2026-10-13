/*
================================================================================
檔案代號:nms_file
檔案名稱:ANM-部门缺省会计科目档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table nms_file
(
nms01       varchar2(10) NOT NULL,   /*部门编号                               */
                                     /*部門編號                               */
                                     /*當 NMZ#11 設定為'N':不區分部門編號, 則本*/
                                     /*欄位值固定為 ' '                       */
nms12       varchar2(24),            /*汇兑收益科目                           */
                                     /*匯兌收益科目                           */
nms13       varchar2(24),            /*汇兑损失科目                           */
                                     /*匯兌損失科目                           */
nms14       varchar2(24),            /*应付开票借方缺省科目                   */
                                     /*應付開票借方預設科目                   */
nms15       varchar2(24),            /*应付票据科目                           */
                                     /*應付票據科目                           */
nms16       varchar2(24),            /*应付票据退票贷方科目                   */
                                     /*應付票據退票貸方科目                   */
nms17       varchar2(24),            /*应付票据撤票贷方科目                   */
                                     /*應付票據撤票貸方科目                   */
nms18       varchar2(24),            /*应付票据作废贷方科目                   */
                                     /*應付票據作廢貸方科目                   */
nms19       varchar2(24),            /*No Use                                 */
nms20       varchar2(24),            /*No Use                                 */
nms21       varchar2(24),            /*应收收票贷方缺省科目                   */
                                     /*應收收票貸方預設科目                   */
nms22       varchar2(24),            /*应收票据科目                           */
                                     /*應收票據科目                           */
nms23       varchar2(24),            /*应收票据托收借方科目                   */
                                     /*應收票據託收借方科目                   */
nms24       varchar2(24),            /*应收票据质押借方科目                   */
                                     /*應收票據質押借方科目                   */
nms25       varchar2(24),            /*应收票据票贴借方科目                   */
                                     /*應收票據票貼借方科目                   */
nms26       varchar2(24),            /*应收票据退票借方科目                   */
                                     /*應收票據退票借方科目                   */
nms27       varchar2(24),            /*应收票据撤票借方科目                   */
                                     /*應收票據撤票借方科目                   */
nms28       varchar2(24),            /*暂收款科目                             */
nms29       varchar2(24),            /*No Use                                 */
nms50       varchar2(24),            /*应付利息                               */
                                     /*應付利息                               */
nms51       varchar2(24),            /*应收票据作废借方                       */
                                     /*應收票據作廢借方                       */
nms52       varchar2(24),            /*No Use                                 */
nms53       varchar2(24),            /*No Use                                 */
nms54       varchar2(24),            /*No Use                                 */
nms55       varchar2(24),            /*长期贷款                               */
                                     /*長期貸款                               */
nms56       varchar2(24),            /*外销贷款                               */
                                     /*外銷貸款                               */
nms57       varchar2(24),            /*信用贷款                               */
                                     /*信用貸款                               */
nms58       varchar2(24),            /*本票汇票手续费                         */
                                     /*本票匯票手續費                         */
nms59       varchar2(24),            /*应付商用本票折价                       */
                                     /*應付商用本票折價                       */
nms60       varchar2(24),            /*利息费用                               */
                                     /*利息費用                               */
nms61       varchar2(24),            /*应付承兑汇票折价                       */
                                     /*應付承兌匯票折價                       */
nms62       varchar2(24),            /*应付承兑汇票                           */
                                     /*應付承兌匯票                           */
nms63       varchar2(24),            /*应付商业本票                           */
                                     /*應付商業本票                           */
nms64       varchar2(24),            /*应付利息暂估                           */
                                     /*應付利息暫估                           */
nms65       varchar2(24),            /*购料贷款                               */
                                     /*購料貸款                               */
nms66       varchar2(24),            /*应付保证票                             */
                                     /*應付保証票                             */
nms67       varchar2(24),            /*存出保证票                             */
                                     /*存出保証票                             */
nms68       varchar2(24),            /*定期存款                               */
nms69       varchar2(24),            /*存入保证票                             */
                                     /*存入保証票                             */
nms70       varchar2(24),            /*利息收入                               */
                                     /*利息收入       (01/04/17)              */
nms71       varchar2(24),            /*应收利息                               */
                                     /*應收利息       (01/04/17)              */
nmsacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
nmsuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
nmsgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
nmsmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
nmsdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
nms121      varchar2(24),            /*汇兑收益科目二                         */
nms131      varchar2(24),            /*汇兑损失科目二                         */
nms141      varchar2(24),            /*应付开票借方缺省科目二                 */
nms151      varchar2(24),            /*应付票据科目二                         */
nms161      varchar2(24),            /*应付票据退票贷方科目二                 */
nms171      varchar2(24),            /*应付票据撤票贷方科目二                 */
nms181      varchar2(24),            /*应付票据作废贷方科目二                 */
nms211      varchar2(24),            /*应收收票贷方缺省科目二                 */
nms221      varchar2(24),            /*应收票据科目二                         */
nms231      varchar2(24),            /*应收票据托收借方科目二                 */
nms241      varchar2(24),            /*应收票据质押借方科目二                 */
nms251      varchar2(24),            /*应收票据票贴借方科目二                 */
nms261      varchar2(24),            /*应收票据退票借方科目二                 */
nms271      varchar2(24),            /*应收票据撤票借方科目二                 */
nms281      varchar2(24),            /*暂收款科目二                           */
nms501      varchar2(24),            /*应付利息二                             */
nms511      varchar2(24),            /*应收票据作废借方二                     */
nms551      varchar2(24),            /*长期贷款二                             */
nms561      varchar2(24),            /*外销贷款二                             */
nms571      varchar2(24),            /*信用贷款二                             */
nms581      varchar2(24),            /*本票汇票手续费二                       */
nms591      varchar2(24),            /*应付商用本票折价二                     */
nms601      varchar2(24),            /*利息费用二                             */
nms611      varchar2(24),            /*应付承兑汇票折价二                     */
nms621      varchar2(24),            /*应付承兑汇票二                         */
nms631      varchar2(24),            /*应付商业本票二                         */
nms641      varchar2(24),            /*应付利息暂估二                         */
nms651      varchar2(24),            /*购料贷款二                             */
nms661      varchar2(24),            /*应付保证票二                           */
nms671      varchar2(24),            /*存出保证票二                           */
nms681      varchar2(24),            /*定期存款二                             */
nms691      varchar2(24),            /*存入保证票二                           */
nms701      varchar2(24),            /*利息收入二                             */
nms711      varchar2(24),            /*应收利息二                             */
nmsoriu     varchar2(10),            /*资料建立者                             */
nmsorig     varchar2(10)             /*资料建立部门                           */
);

alter table nms_file add  constraint nms_pk primary key  (nms01) enable validate;
grant select on nms_file to tiptopgp;
grant update on nms_file to tiptopgp;
grant delete on nms_file to tiptopgp;
grant insert on nms_file to tiptopgp;
grant index on nms_file to public;
grant select on nms_file to ods;
