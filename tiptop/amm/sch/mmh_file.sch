/*
================================================================================
檔案代號:mmh_file
檔案名稱:备料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table mmh_file
(
mmh01       varchar2(20) NOT NULL,   /*开发运行单编号                         */
                                     /*開發執行單編號 mmg01                   */
mmh011      varchar2(20) NOT NULL,   /*模治具工单编号                         */
                                     /*模治具工單編號 mmg02                   */
mmh02       number(5),               /*开发运行单项次                         */
mmh03       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*Item# ima01                            */
                                     /*Down Level Item# Of The Developing Run Document Storage, Should Be Item# Of Input Product*/
mmh04       number(15,3) NOT NULL,   /*原发数量                               */
                                     /*Original Issued Qty                    */
                                     /*Save the original quantity of the developing run document*/
                                     /*allotted item which producted by product construct.It is*/
                                     /*came out by the way of add wastage ratio into the*/
                                     /*standard used quantity on the base of production quantity.*/
mmh05       number(15,3) NOT NULL,   /*应发数量                               */
                                     /*Save the quantity of the developing run document allotted*/
                                     /*item that has been altered by users. It should be same*/
                                     /*with the original issued quantity.     */
mmh06       number(15,3) NOT NULL,   /*已发数量                               */
                                     /*Issued Qty                             */
                                     /*Store Issued Qty Of The Developing Run Document Allotment Item*/
mmh061      number(15,3) NOT NULL,   /*已领数量                               */
                                     /*Withdrawn Qty                          */
                                     /*Store Withdrawn Qty Of The Developing Run Document Allotment Item*/
mmh062      number(15,3) NOT NULL,   /*超领数量                               */
                                     /*Qty Over-Withdrawn                     */
                                     /*Store Over-Withdrawn Qty Of The Developing Run Document Allotment Item*/
mmh063      number(15,3) NOT NULL,   /*报废数量                               */
                                     /*Scrap Qty                              */
                                     /*Store Scraped Qty Of The Developing Run Document Allotment Item*/
mmh064      number(15,3) NOT NULL,   /*盘损数量                               */
                                     /*盤損數量                               */
                                     /*儲存該開發執行單備料料件，盤點時的減少數*/
mmh065      number(15,3) NOT NULL,   /*委外代买量                             */
                                     /*委外代買量                             */
                                     /*儲存該開發執行單備料料件，委外代買數量 */
mmh066      number(15,3) NOT NULL,   /*委外代买已交量                         */
                                     /*委外代買已交量                         */
                                     /*儲存該開發執行單備料料件，委外代買已交數*/
mmh07       number(15,3) NOT NULL,   /*欠料数量                               */
                                     /*欠料數量                               */
                                     /*儲存該開發執行單備料料件，預期會產生的短*/
                                     /*，可由人為或系統自動維護               */
mmh08       varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*Task Code                              */
                                     /*Save the task codes that contain the developing run*/
                                     /*document allotted item and anticipated production.*/
                                     /*The code is combined by the production code in*/
                                     /*Developing Run Table and the construct of the product.*/
mmh09       number(5),               /*前置时间调整                           */
                                     /*前置時間調整(天)                       */
                                     /*表示自開發運行單起始生產日算起,需多少時間*/
                                     /*若為正值表示多少天後                   */
                                     /*若為負值表示多少天前                   */
mmh10       varchar2(5),             /*前置时间调整                           */
                                     /*前置時間調整(時:分)                    */
                                     /*儲存經備料前置調整後，對該日的時間調整 */
                                     /*若為正值表示多少時間後                 */
                                     /*若為負值表示多少時間前                 */
                                     /*量產系統專用                           */
mmh11       varchar2(1),             /*旗标                                   */
                                     /*旗標                                   */
                                     /*儲存備料料件的來源特性                 */
                                     /*正確值 E/U/V/R/N                       */
                                     /*E: 消耗性料件                          */
                                     /*U: 大宗自製料件                        */
                                     /*V: 大宗採購料件                        */
                                     /*R: 在製途料件                          */
                                     /*N: 除外一般料件                        */
                                     /*--------單位換算率----------------------*/
mmh12       varchar2(4) NOT NULL,    /*发料单位                               */
                                     /*Issuing Unit                           */
                                     /*Store Issuing Unit Of The Developing Run Document Allotment Item，Come Whith BOM*/
mmh13       number(20,8),            /*发料单位/库存单位换算率                */
                                     /*發料單位/庫存單位換算率                */
                                     /*ex.發料單位=kg 庫存單位=g              */
                                     /* 1000/1=1000(換算率)                   */
mmh14       varchar2(4),             /*成本单位                               */
                                     /*成本單位                               */
                                     /*儲存該開發執行單備料料件的發料單位，將由*/
                                     /*件主檔] 產生而來                       */
mmh15       number(20,8),            /*成本单位/材料成本档成本单位            */
                                     /*成本單位/材料成本檔成本單位之換算率    */
                                     /*ex.成本單位=g 成本單位=kg              */
                                     /* 1/1000=0.001(換算率)                  */
mmh16       number(16,8),            /*标准单位用量                           */
                                     /*Standard Qty Per Assembly(QPA)         */
                                     /*Store Standard Qty Per Assembly Of The Developing Run Document Allotment Item，Come Whith BOM Auto Maintain When Allot ,Can Not Modified*/
mmh161      number(16,8),            /*实际单位用量 (Actual QPA)              */
                                     /*實際單位用量 (Actual QPA)              */
                                     /*系統若使用損耗率, 則本用量會加上損耗率 */
                                     /*系統若不用損耗率, 則本用量不加上損耗率 */
                                     /*系統若不用損耗率, 則本用量等於標準用量.*/
                                     /*系統於備料時自動維護,不能修改          */
mmh25       number(15,3) NOT NULL,   /*未备料量                               */
                                     /*Unallotted Qty                         */
                                     /*Store the quantity that the quantity of the developing*/
                                     /*run document allotted item to issue is more than the*/
                                     /*available allotted quantity of the main document,*/
                                     /*and have no other item quantity can be replaced. In other*/
                                     /*words, it is the quantity of unavailable allotment.*/
mmh26       varchar2(1),             /*替代码                                 */
                                     /*Replace code                           */
                                     /*Save the developing run document allotted item which*/
                                     /*is the next item of original combination or replaced*/
                                     /*item.                                  */
                                     /*Available Chioce: 0/1/2/3/4/S/U        */
                                     /*0: Original item, couldn't be replaced */
                                     /*1: New item, can replace the past item (Update to '3'*/
                                     /*   after replace)                      */
                                     /*2: Master item, can replace the sub-item (Update to '4'*/
                                     /*   after replace)                      */
                                     /*3: New item, already been replaced     */
                                     /*4: Master item, already been replaced  */
                                     /*U: Past item (Replace item)            */
                                     /*S: Sub-item (Replace item)             */
mmh27       varchar2(40) NOT NULL,   /*被替代料号                             */
                                     /*Replaced Item Code                     */
                                     /* If mmh26='01234', the value of the field is same with*/
                                     /* mmh03                                 */
                                     /* If mmh26='S/U',the value of the field is the replaced*/
                                     /* item code                             */
mmh28       number(15,3) NOT NULL,   /*替代率                                 */
                                     /*當 mmh26='01234'時,本欄位=1            */
                                     /*當 mmh26='S/U'  時,本欄位儲存替代率    */
mmh29       varchar2(40),            /*上阶料号                               */
                                     /*上階料號                               */
mmh30       varchar2(10),            /*指定仓库                               */
                                     /*指定倉庫                               */
mmh31       varchar2(10),            /*指定库位                               */
                                     /*指定儲位                               */
mmh91       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh92       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh93       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh94       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh95       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh96       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh97       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh98       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmh99       varchar2(1),             /*用户自订                               */
                                     /*User Defined(USER DEFINE)              */
mmhacti     varchar2(1),             /*资料有效码                             */
                                     /*Data Valid Code                        */
                                     /*System Maintain                        */
mmhud01     varchar2(255),           /*自订字段-Textedit                      */
mmhud02     varchar2(40),            /*自订字段-文字                          */
mmhud03     varchar2(40),            /*自订字段-文字                          */
mmhud04     varchar2(40),            /*自订字段-文字                          */
mmhud05     varchar2(40),            /*自订字段-文字                          */
mmhud06     varchar2(40),            /*自订字段-文字                          */
mmhud07     number(15,3),            /*自订字段-数值                          */
mmhud08     number(15,3),            /*自订字段-数值                          */
mmhud09     number(15,3),            /*自订字段-数值                          */
mmhud10     number(10),              /*自订字段-整数                          */
mmhud11     number(10),              /*自订字段-整数                          */
mmhud12     number(10),              /*自订字段-整数                          */
mmhud13     date,                    /*自订字段-日期                          */
mmhud14     date,                    /*自订字段-日期                          */
mmhud15     date,                    /*自订字段-日期                          */
mmhplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
mmhlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index mmh_02 on mmh_file (mmh03);
alter table mmh_file add  constraint mmh_pk primary key  (mmh01,mmh011,mmh03,mmh08,mmh12) enable validate;
grant select on mmh_file to tiptopgp;
grant update on mmh_file to tiptopgp;
grant delete on mmh_file to tiptopgp;
grant insert on mmh_file to tiptopgp;
grant index on mmh_file to public;
grant select on mmh_file to ods;
