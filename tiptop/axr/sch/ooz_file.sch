/*
================================================================================
檔案代號:ooz_file
檔案名稱:应收系统参数档
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table ooz_file
(
ooz00       varchar2(1) NOT NULL,    /*KEY VALUE = '0'                        */
ooz01       varchar2(1),             /*当前应收系统是否可开放用户             */
                                     /*目前應收系統是否可開放使用者使用(Y/N)? */
                                     /*Y: 正常使用                            */
                                     /*N: 僅供使用者列印查詢                  */
                                     /*   不可作資料的新增,修改,查詢,刪除     */
ooz02       varchar2(1),             /*是否与总帐管理系统连线                 */
                                     /*是否與總帳管理系統連線(Y.是/N.否)      */
ooz02p      varchar2(10),            /*总帐管理系统所在营运中心编             */
                                     /*TIPTOP-AGL Plant No.                   */
ooz02b      varchar2(5),             /*总帐管理系统使用帐套编号               */
                                     /*總帳管理系統使用帳別編號               */
ooz03       varchar2(1),             /*是否与制造管理系统连线                 */
                                     /*是否與製造管理系統連線(Y.是/N.否)      */
ooz04       varchar2(1),             /*是否与票据管理系统连线                 */
                                     /*是否與票據管理系統連線(Y.是/N.否)      */
ooz05       number(5),               /*月底重评价年度                         */
ooz06       number(5),               /*月底重评价月份                         */
ooz07       varchar2(1),             /*月底重评价当月认列汇差,次月            */
ooz08       varchar2(10),            /*应收帐款缺省科目类型                   */
                                     /*應收帳款預設科目類別   modi  99/11/22  */
ooz09       date,                    /*关帐日期                               */
                                     /*關帳日期                               */
ooz10       varchar2(1),             /*是否回写出货单汇率                     */
ooz11       varchar2(1),             /*多笔应收帐款可否合并开立发             */
                                     /*多筆應收帳款可否合併開立發票(Y/N)      */
ooz121      number(5),               /*内销应收帐款出货单身储存最             */
                                     /*內銷應收帳款出貨單身儲存最大筆數       */
ooz122      number(5),               /*外销应收帐款出货单身储存最             */
                                     /*外銷應收帳款出貨單身儲存最大筆數       */
ooz13       varchar2(1),             /*出货单自动生成应收后审核方             */
                                     /*出貨單自動產生應收後確認方式           */
                                     /*  1.立刻確認                           */
                                     /*  2.詢問確認否                         */
                                     /*  3.事後再整批確認                     */
ooz14       varchar2(1),             /*No Use                                 */
                                     /*No use                           No.7050*/
ooz15       varchar2(1),             /*月底重评价分录底稿生成方式             */
ooz16       varchar2(1),             /*应收审核时是否将应收单价更             */
                                     /*應收確認時是否將應收單價更新回出貨單(Y/N*/
ooz17       varchar2(1),             /*内销应收立帐汇率采用方式               */
                                     /*內銷應收立帳匯率採用方式               */
                                     /*B:銀行買入 S:銀行賣出                  */
                                     /*C:海關買入 D:海關賣出                  */
ooz18       varchar2(1),             /*No Use                                 */
ooz19       varchar2(1),             /*无出货单可否开立出货发票               */
                                     /*無出貨單可否開立出貨發票(Y/N)          */
ooz20       varchar2(1),             /*应收帐款是否须审核后才可开             */
                                     /*應收帳款是否須確認後才可開立發票97/08/01*/
ooz21       varchar2(5),             /*预收帐款缺省单别                       */
                                     /*預收帳款預設單別                       */
ooz22       varchar2(5),             /*溢收帐款缺省单别                       */
                                     /*溢收帳款預設單別                       */
ooz23       varchar2(1),             /*收款冲帐作业是否需同时录入             */
                                     /*收款沖帳作業是否需同時輸入票據資料(Y/N)*/
ooz24       varchar2(1),             /*收款冲帐作业是否需同时录入             */
                                     /*收款沖帳作業是否需同時輸入銀行收支(Y/N)*/
ooz25       number(5),               /*No Use                                 */
ooz41       number(5),               /*应收帐龄第一段天数                     */
                                     /*應收帳齡第一段天數                     */
ooz42       number(5),               /*应收帐龄第二段天数                     */
                                     /*應收帳齡第二段天數                     */
ooz43       number(5),               /*应收帐龄第三段天数                     */
                                     /*應收帳齡第三段天數                     */
ooz44       number(5),               /*应收帐龄第四段天数                     */
                                     /*應收帳齡第四段天數                     */
ooz61       varchar2(80),            /*营业人申报适用零税率销售额             */
                                     /*營業人申報適用零稅率銷售額清單之受文者 */
ooz62       varchar2(1),             /*收款冲帐作业是否需冲至应收             */
                                     /*收款沖帳作業是否需沖至應收帳款項次(Y/N)*/
ooz63       varchar2(1),             /*外销应收立帐汇率采用方式               */
                                     /*外銷應收立帳匯率採用方式               */
                                     /*B:銀行買入 S:銀行賣出                  */
                                     /*C:海關買入 D:海關賣出                  */
ooz64       varchar2(1),             /*外销是否开立发票                       */
ooz02c      varchar2(5),             /*第二默认账套                           */
ooz65       varchar2(1),             /*出货应收包含销退折让                   */
ooz66       varchar2(1) DEFAULT 'N', /*预收/暂收不做月底重评价                */
ooz26       varchar2(5),             /*應收調帳缺省單別                       */
ooz27       varchar2(1),             /*轉銷科目類型                           */
ooz28       varchar2(10),            /*轉銷科目分類碼                         */
ooz29       varchar2(1) DEFAULT 'N' NOT NULL, /*調賬是否走中間過渡科目*/
oozud01     varchar2(255),           /*自订字段                               */
oozud02     varchar2(40),            /*自订字段                               */
oozud03     varchar2(40),            /*自订字段                               */
oozud04     varchar2(40),            /*自订字段                               */
oozud05     varchar2(40),            /*自订字段                               */
oozud06     varchar2(255),           /*自订字段                               */
oozud07     number(15,3),            /*自订字段                               */
oozud08     number(15,3),            /*自订字段                               */
oozud09     number(15,3),            /*自订字段                               */
oozud10     number(10),              /*自订字段                               */
oozud11     number(10),              /*自订字段                               */
oozud12     number(10),              /*自订字段                               */
oozud13     date,                    /*自订字段                               */
oozud14     date,                    /*自订字段                               */
oozud15     date,                    /*自订字段                               */
ooz30       varchar2(5),             /*待抵调账单别                           */
ooz32       varchar2(1) DEFAULT ' ' NOT NULL, /*是否做发票管理*/
ooz33       varchar2(1) DEFAULT 'N' NOT NULL /*订金是否认列收入*/
);

alter table ooz_file add  constraint ooz_pk primary key  (ooz00) enable validate;
grant select on ooz_file to tiptopgp;
grant update on ooz_file to tiptopgp;
grant delete on ooz_file to tiptopgp;
grant insert on ooz_file to tiptopgp;
grant index on ooz_file to public;
grant select on ooz_file to ods;
