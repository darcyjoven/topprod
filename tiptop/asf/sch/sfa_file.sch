/*
================================================================================
檔案代號:sfa_file
檔案名稱:备料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table sfa_file
(
sfa01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號 sfb01                         */
sfa02       number(5),               /*工单类型                               */
                                     /*工單型態 (同sfb02)                     */
sfa03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號 ima01                         */
                                     /*儲存該工單所屬下階料件編號，應為被發放 */
                                     /*投入生產的料件編號                     */
sfa04       number(15,3) NOT NULL,   /*原发数量                               */
                                     /*原發數量                               */
                                     /*儲存該工單備料料件，由產品結構產生而來 */
                                     /*之原有數量；在與生產數量對比上使用標準 */
                                     /*用量加上損耗率，延展而來               */
sfa05       number(15,3) NOT NULL,   /*应发数量                               */
                                     /*應發數量                               */
                                     /*儲存該工單備料料件，使用者經過修改後， */
                                     /*決定的備料量；開始時，應與原發數量相同 */
sfa06       number(15,3) NOT NULL,   /*已发数量                               */
                                     /*已發數量                               */
                                     /*儲存該工單備料料件，已經被發料的數量； */
sfa061      number(15,3) NOT NULL,   /*已领数量                               */
                                     /*已領數量                               */
                                     /*儲存該工單備料料件，已經被領料的數量； */
sfa062      number(15,3) NOT NULL,   /*超领数量                               */
                                     /*超領數量                               */
                                     /*儲存該工單備料料件，被超領料的數量     */
sfa063      number(15,3) NOT NULL,   /*报废数量                               */
                                     /*報廢數量                               */
                                     /*儲存該工單備料料件，被報廢料的數量     */
sfa064      number(15,3) NOT NULL,   /*盘损数量                               */
                                     /*盤損數量                               */
                                     /*儲存該工單備料料件，盤點時的減少數量   */
sfa065      number(15,3) NOT NULL,   /*委外代买量                             */
                                     /*委外代買量                             */
                                     /*儲存該工單備料料件，委外代買數量       */
sfa066      number(15,3) NOT NULL,   /*委外代买已交量                         */
                                     /*委外代買已交量                         */
                                     /*儲存該工單備料料件，委外代買已交數量   */
sfa07       number(15,3),            /*欠料量                                 */
                                     /*No Use (for GP5.2)                     */
sfa08       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存該工單備料料件，預期投入生產的作業 */
                                     /*所屬作業編號；可由[工單檔]指定的製程編 */
                                     /*號及產品結構而得                       */
sfa09       number(5),               /*前置时间调整                           */
                                     /*前置時間調整(天)                       */
                                     /*表示自工單起始生產日算起,需多少時間備料*/
                                     /*若為正值表示多少天後                   */
                                     /*若為負值表示多少天前                   */
sfa10       varchar2(5),             /*前置时间调整                           */
                                     /*前置時間調整(時:分)                    */
                                     /*儲存經備料前置調整後，對該日的時間調整 */
                                     /*若為正值表示多少時間後                 */
                                     /*若為負值表示多少時間前                 */
                                     /*量產系統專用                           */
sfa11       varchar2(1),             /*旗标                                   */
                                     /*旗標                                   */
                                     /*儲存備料料件的來源特性                 */
                                     /*正確值 E/U/V/R/N                       */
                                     /*E: 消耗性料件                          */
                                     /*U: 大宗自製料件                        */
                                     /*V: 大宗採購料件                        */
                                     /*R: 在製途料件                          */
                                     /*N: 除外一般料件                        */
                                     /*--------單位換算率----------------------*/
sfa12       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*發料單位                               */
                                     /*儲存該工單備料料件的發料單位，將由產品 */
                                     /*產品結構產生而來                       */
sfa13       number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
sfa14       varchar2(4),             /*成本单位                               */
                                     /*成本單位                               */
                                     /*儲存該工單備料料件的發料單位，將由 [料 */
                                     /*件主檔] 產生而來                       */
sfa15       number(20,8),            /*成本单位/材料成本档成本单位            */
                                     /*成本單位/材料成本檔成本單位之換算率    */
                                     /*ex.成本單位=g 成本單位=kg              */
                                     /* 1/1000=0.001(換算率)                  */
sfa16       number(16,8),            /*标准单位用量                           */
                                     /*標準單位用量 (Standard QPA)            */
                                     /*儲存該工單備料料件的標準單位用量，由BOM*/
                                     /*產品結構產生而來                       */
                                     /*系統於備料時自動維護,不能修改          */
sfa161      number(16,8),            /*实际单位用量 (Actual QPA)              */
                                     /*實際單位用量 (Actual QPA)              */
                                     /*系統若使用損耗率, 則本用量會加上損耗率 */
                                     /*系統若不用損耗率, 則本用量不加上損耗率 */
                                     /*系統若不用損耗率, 則本用量等於標準用量.*/
                                     /*系統於備料時自動維護,不能修改          */
sfa25       number(15,3) NOT NULL,   /*未备料量                               */
                                     /*未備料量                               */
                                     /*儲存該工單備料料件的應發數量大於 [料件 */
                                     /*主檔] 的可被備料量，而又無其他可替代料 */
                                     /*的數量；亦即未能備料量                 */
sfa26       varchar2(1),             /*替代码                                 */
                                     /*替代碼                                 */
                                     /*儲存該工單備料的料件為原始組合的下階料 */
                                     /*件或採用取/替代料件                    */
                                     /*正確值 0/1/2/3/4/S/U                   */
                                     /*0: 原始料件, 不可被取替代              */
                                     /*1: 新料, 有舊料可取代 (取代後,轉為'3') */
                                     /*2: 主料, 有副料可替代 (替代後,轉為'4') */
                                     /*3: 新料, 已經被取代                    */
                                     /*4: 主料, 已經被替代                    */
                                     /*5: 主料, 可做SET替代(SET替代號,轉為'6')*/
                                     /*                     #Add By 養生2003  */
                                     /*6: 主料, 已做SET替代 #Add By 養生2003  */
                                     /*U: 舊料(取代料件)                      */
                                     /*S: 副料(替代料件)                      */
                                     /*T: SET替代料         #Add BY 養生2003  */
sfa27       varchar2(40) NOT NULL,   /*被替代料号                             */
                                     /*被替代料號                             */
                                     /*當 sfa26='012345T'時,欄位儲存料號同sfa03*/
                                     /*當 sfa26='S/U'  時,本欄位儲存被替代料號*/
sfa28       number(15,6) NOT NULL,   /*替代率                                 */
                                     /*當 sfa26='012345'時,本欄位=1           */
                                     /*當 sfa26='S/U'  時,本欄位儲存替代率    */
                                     /*當 sfa26='T'時,儲存替代料替代量bob07   */
                                     /*               #Add BY 養生2003        */
sfa29       varchar2(40),            /*上阶料号                               */
                                     /*上階料號                               */
sfa30       varchar2(10),            /*指定仓库                               */
                                     /*指定倉庫                               */
sfa31       varchar2(10),            /*指定库位                               */
                                     /*指定儲位                               */
sfa91       varchar2(20),            /*制单号                                 */
sfa92       varchar2(1),             /*USER DEFINE                            */
sfa93       varchar2(1),             /*USER DEFINE                            */
sfa94       varchar2(1),             /*USER DEFINE                            */
sfa95       varchar2(1),             /*USER DEFINE                            */
sfa96       varchar2(1),             /*USER DEFINE                            */
sfa97       varchar2(1),             /*USER DEFINE                            */
sfa98       varchar2(1),             /*USER DEFINE                            */
sfa99       varchar2(1),             /*USER DEFINE                            */
sfa100      number(9,4),             /*发料误差允许率                         */
                                     /*發料誤差允許率           010515 No.+114*/
sfaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
sfa32       varchar2(1),             /*代买料否                               */
sfaud01     varchar2(255),           /*自订字段-Textedit                      */
sfaud02     varchar2(40),            /*自订字段-文字                          */
sfaud03     varchar2(40),            /*自订字段-文字                          */
sfaud04     varchar2(40),            /*自订字段-文字                          */
sfaud05     varchar2(40),            /*自订字段-文字                          */
sfaud06     varchar2(40),            /*自订字段-文字                          */
sfaud07     number(15,3),            /*自订字段-数值                          */
sfaud08     number(15,3),            /*良率                                   */
sfaud09     number(15,3),            /*自订字段-数值                          */
sfaud10     number(10),              /*自订字段-整数                          */
sfaud11     number(10),              /*自订字段-整数                          */
sfaud12     number(10),              /*自订字段-整数                          */
sfaud13     date,                    /*自订字段-日期                          */
sfaud14     date,                    /*自订字段-日期                          */
sfaud15     date,                    /*自订字段-日期                          */
sfa36       varchar2(24),            /*厂牌                                   */
sfaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfalegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfa012      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
sfa013      number(5) DEFAULT '0' NOT NULL /*工艺序*/
);

create        index sfa_02 on sfa_file (sfa03);
alter table sfa_file add  constraint sfa_pk primary key  (sfa01,sfa03,sfa08,sfa12,sfa27,sfa012,sfa013) enable validate;
grant select on sfa_file to tiptopgp;
grant update on sfa_file to tiptopgp;
grant delete on sfa_file to tiptopgp;
grant insert on sfa_file to tiptopgp;
grant index on sfa_file to public;
grant select on sfa_file to ods;
