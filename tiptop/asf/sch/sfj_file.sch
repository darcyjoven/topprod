/*
================================================================================
檔案代號:sfj_file
檔案名稱:备料档历史档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sfj_file
(
sfj01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
sfj02       number(5),               /*工单类型                               */
                                     /*Work Order Type                        */
                                     /*Store the type of work order.          */
                                     /*Choice Valid: 1/2/5/7/11/12            */
                                     /*1 : General Work Order                 */
                                     /*2 : FAS W/O Allotment Qty              */
                                     /*5 : Reprocess Work Order               */
                                     /*7 : Subcontracting Work Order          */
                                     /*11: Disassembly Work Orde              */
                                     /*12: Multi-Plant Work Order             */
sfj03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
                                     /*儲存該工單所屬下階料件編號，應為被發放 */
                                     /*投入生產的料件編號                     */
sfj04       number(15,3) NOT NULL,   /*原发数量                               */
                                     /*原發數量                               */
                                     /*儲存該工單備料料件，由產品結構產生而來 */
                                     /*之原有數量；在與生產數量對比上使用標準 */
                                     /*用量加上損耗率，延展而來               */
sfj05       number(15,3) NOT NULL,   /*应发数量                               */
                                     /*應發數量                               */
                                     /*儲存該工單備料料件，使用者經過修改後， */
                                     /*決定的備料量；開始時，應與原發數量相同 */
sfj06       number(15,3) NOT NULL,   /*已发数量                               */
                                     /*已發數量                               */
                                     /*儲存該工單備料料件，已經被發放的數量； */
                                     /*可逐次累加                             */
sfj061      number(15,3) NOT NULL,   /*已领数量                               */
                                     /*已領數量                               */
                                     /*儲存該工單備料料件，已經被領料的數量； */
                                     /*可逐次累加                             */
sfj062      number(15,3) NOT NULL,   /*超领数量                               */
                                     /*超領數量                               */
                                     /*儲存該工單備料料件，被超領料的數量     */
                                     /*可逐次累加                             */
sfj063      number(15,3) NOT NULL,   /*报废数量                               */
                                     /*報廢數量                               */
                                     /*儲存該工單備料料件，被報廢料的數量     */
                                     /*可逐次累加                             */
sfj064      number(15,3) NOT NULL,   /*盘点差异量                             */
                                     /*盤點差異量                             */
                                     /*儲存該工單備料料件，盤點時的差異數量   */
sfj065      number(15,3) NOT NULL,   /*委外代买量                             */
                                     /*委外代買量                             */
                                     /*儲存該工單備料料件，委外代買數量       */
sfj066      number(15,3) NOT NULL,   /*委外代买已交量                         */
                                     /*委外代買已交量                         */
                                     /*儲存該工單備料料件，委外代買已交數量   */
sfj07       number(15,3) NOT NULL,   /*缺料数量                               */
                                     /*缺料數量                               */
                                     /*儲存該工單備料料件，預期會產生的短缺量 */
                                     /*，可由人為或系統自動維護               */
sfj08       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存該工單備料料件，預期投入生產的作業 */
                                     /*所屬作業編號；可由[工單檔]指定的製程編 */
                                     /*號及產品結構而得                       */
sfj09       number(5),               /*前置时间调整                           */
                                     /*前置時間調整(天)                       */
                                     /*表示自工單起始生產日算起,需多少時間備料*/
                                     /*若為正值表示多少天後                   */
                                     /*若為負值表示多少天前                   */
sfj10       varchar2(5),             /*前置时间调整                           */
                                     /*前置時間調整(時:分)                    */
                                     /*儲存經備料前置調整後，對該日的時間調整 */
                                     /*若為正值表示多少時間後                 */
                                     /*若為負值表示多少時間前                 */
                                     /*量產系統專用                           */
sfj11       varchar2(1),             /*旗标                                   */
                                     /*旗標                                   */
                                     /*儲存備料料件的來源特性                 */
                                     /*正確值 E/U/V/R/N                       */
                                     /*E: 消耗性料件                          */
                                     /*U: 大宗自製料件                        */
                                     /*V: 大宗採購料件                        */
                                     /*R: 在製途料件                          */
                                     /*N: 除外一般料件                        */
                                     /*--------單位換算率----------------------*/
sfj12       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*發料單位                               */
                                     /*儲存該工單備料料件的發料單位，將由產品 */
                                     /*產品結構產生而來                       */
sfj13       number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sfj14       varchar2(4),             /*成本单位                               */
                                     /*成本單位                               */
                                     /*儲存該工單備料料件的發料單位，將由 [料 */
                                     /*件主檔] 產生而來                       */
sfj15       number(20,8),            /*成本单位/材料成本档成本单位            */
                                     /*成本單位/材料成本檔成本單位之換算率    */
                                     /*ex.成本單位=g 成本單位=kg              */
                                     /* 1/1000=0.001(換算率)                  */
sfj16       number(16,8),            /*标准单位用量                           */
                                     /*標準單位用量(QPA)                      */
                                     /*儲存該工單備料料件的標準單位用量，將由 */
                                     /*產品結構產生而來                       */
                                     /*系統自動維護,不能修改                  */
sfj161      number(16,8),            /*储存该工单料件在备料时所使             */
                                     /*儲存該工單料件在備料時所使用的單位用量.*/
                                     /*若備料時, 系統使用損耗率, 則單位用量   */
                                     /*會加上損耗率; 若不使用損耗率, 則單位用量*/
                                     /*等於標準單位用量.                      */
                                     /*系統自動維護,不能修改                  */
sfj25       number(15,3) NOT NULL,   /*未备料量                               */
                                     /*未備料量                               */
                                     /*儲存該工單備料料件的應發數量大於 [料件 */
                                     /*主檔] 的可被備料量，而又無其他可替代料 */
                                     /*的數量；亦即未能備料量                 */
sfj26       varchar2(1),             /*资料来源                               */
                                     /*資料來源                               */
                                     /*儲存該工單備料料件的為原始組合的下階料 */
                                     /*件或採用取/替代料件                    */
                                     /*正確值 S/U/N                           */
                                     /*S: 替代料件                            */
                                     /*U: 取代料件                            */
                                     /*N: 原始料件                            */
sfj27       varchar2(40) NOT NULL,   /*被替代料号                             */
sfj28       number(15,3) NOT NULL,   /*替代料                                 */
sfj29       varchar2(40),            /*上阶料号                               */
sfj30       varchar2(10),            /*指定仓库                               */
sfj31       varchar2(10),            /*指定库位                               */
sfj91       varchar2(1),             /*用户自订                               */
sfj92       varchar2(1),             /*用户自订                               */
sfj93       varchar2(1),             /*用户自订                               */
sfj94       varchar2(1),             /*用户自订                               */
sfj95       varchar2(1),             /*用户自订                               */
sfj96       varchar2(1),             /*用户自订                               */
sfj97       varchar2(1),             /*用户自订                               */
sfj98       varchar2(1),             /*用户自订                               */
sfj99       varchar2(1),             /*用户自订                               */
sfj100      number(9,4),             /*发料误差允许率                         */
                                     /*發料誤差允許率           010622 No.B625*/
sfjacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
sfjplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfjlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index sfj_02 on sfj_file (sfj03);
alter table sfj_file add  constraint sfj_pk primary key  (sfj01,sfj03,sfj08,sfj12) enable validate;
grant select on sfj_file to tiptopgp;
grant update on sfj_file to tiptopgp;
grant delete on sfj_file to tiptopgp;
grant insert on sfj_file to tiptopgp;
grant index on sfj_file to public;
grant select on sfj_file to ods;
