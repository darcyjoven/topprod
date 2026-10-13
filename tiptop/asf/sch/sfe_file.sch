/*
================================================================================
檔案代號:sfe_file
檔案名稱:工单料账历史档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table sfe_file
(
sfe01       varchar2(40),            /*工单单号                               */
                                     /*W/O No.                                */
                                     /*Store Transacted W/O No.(ASR The Field Is Item#(asri210,asri220))*/
sfe02       varchar2(20),            /*异动单据编号                           */
                                     /*異動單據編號                           */
                                     /*儲存該筆異動的異動單據號碼             */
                                     /*異動單據可為發料單、退料單號、超領單號 */
sfe03       varchar2(20),            /*料表批号                               */
                                     /*料表批號                               */
                                     /*儲存異動工單所屬的料表批號             */
sfe04       date,                    /*异动日期                               */
                                     /*異動日期                               */
                                     /*儲存該筆異動日期                       */
sfe05       varchar2(8),             /*异动时间                               */
                                     /*異動時間                               */
                                     /*儲存該筆異動日期的時間                 */
sfe06       varchar2(1),             /*异动别                                 */
                                     /*異動別                                 */
                                     /*0. 工單下階料件報廢       -- 領料系統  */
                                     /*1.工單發料                -- 發料系統  */
                                     /*2. 完工扣帳 - 消耗料件    -- 發料系統  */
                                     /*3. 工單超領               -- 發料系統  */
                                     /*4. 工單退料               -- 發料系統  */
                                     /*5. 工單下階料件報廢       -- 發料系統  */
                                     /*6. 庫存移轉               -- 領料系統  */
                                     /*7. 完工扣帳               -- 領料系統  */
                                     /*8. 工單超領               -- 領料系統  */
                                     /*9. 工單退料               -- 領料系統  */
                                     /*A. 工單發料 - 代買料件    -- 發料系統  */
                                     /*B. 工單退料 - 代買料件    -- 發料系統  */
                                     /*系統維護                               */
sfe07       varchar2(40),            /*异动料件编号                           */
                                     /*異動料件編號                           */
                                     /*儲存該筆異動的料件編號                 */
sfe08       varchar2(10),            /*异动仓库                               */
                                     /*異動倉庫別                             */
                                     /*儲存該筆異動來源的倉庫編號             */
sfe09       varchar2(10),            /*异动库位                               */
                                     /*異動儲位                               */
                                     /*儲存該筆異動來源的儲位                 */
sfe10       varchar2(24),            /*异动批号                               */
                                     /*異動批號                               */
                                     /*儲存該筆異動來源的批號                 */
sfe11       varchar2(255),           /*备注                                   */
sfe12       varchar2(10),            /*No Use                                 */
sfe13       varchar2(24),            /*No Use                                 */
sfe14       varchar2(6),             /*作业编号                               */
                                     /*作業編號                               */
                                     /*儲存該筆異動的作業編號                 */
sfe15       varchar2(10),            /*工作站编号                             */
                                     /*工作站編號                             */
                                     /*儲存該筆異動的工作站編號               */
sfe16       number(15,3),            /*异动数量                               */
                                     /*異動數量                               */
                                     /*儲存該筆異動的異動數量                 */
sfe17       varchar2(4),             /*异动单位                               */
                                     /*異動單位                               */
                                     /*儲存該筆異動的異動單位                 */
                                     /*使用工單備料檔上的單位                 */
sfe18       number(20,6),            /*直接材料成本                           */
sfe19       number(20,6),            /*间接材料成本                           */
                                     /*間接材料成本                           */
sfe20       number(20,6),            /*直接人工成本                           */
sfe21       number(20,6),            /*间接人工成本                           */
                                     /*間接人工成本                           */
sfe22       number(20,6),            /*委外加工材料成本                       */
                                     /*廠外加工材料成本                       */
sfe23       number(20,6),            /*委外加工人工成本                       */
                                     /*廠外加工人工成本                       */
sfe24       varchar2(20),            /*异动指令                               */
                                     /*異動命令                               */
sfe25       varchar2(10),            /*异动人                                 */
                                     /*異動人                                 */
sfe26       varchar2(10),            /*理由码                                 */
                                     /*理由碼                                 */
sfe27       varchar2(40),            /*被替代料号                             */
                                     /*post to abx system flag                */
                                     /*'Y':確認                               */
                                     /*'N':未確認                             */
sfe28       number(5),               /*单据项次                               */
                                     /*單據項次                               */
sfe91       varchar2(1),             /*No Use                                 */
sfe92       varchar2(1),             /*No Use                                 */
sfe93       varchar2(1),             /*No Use                                 */
sfe94       varchar2(1),             /*No Use                                 */
sfe95       varchar2(1),             /*No Use                                 */
sfe30       varchar2(4),             /*单位一                                 */
sfe31       number(20,8),            /*单位一换算率(与生产单位)               */
sfe32       number(15,3),            /*单位一数量                             */
sfe33       varchar2(4),             /*单位二                                 */
sfe34       number(20,8),            /*单位二换算率(与生产单位)               */
sfe35       number(15,3),            /*单位二数量                             */
sfe930      varchar2(10),            /*成本中心                               */
sfe36       varchar2(24),            /*厂牌                                   */
sfeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
sfelegal    varchar2(10) NOT NULL,   /*所属法人                               */
sfe012      varchar2(10),            /*工艺段号                               */
sfe013      number(5),               /*工艺序                                 */
sfe014      varchar2(23) DEFAULT ' ' NOT NULL, /*Run Card*/
sfeud01     varchar2(255),           /*自订字段-Textedit                      */
sfeud02     varchar2(40),            /*原材仓                                 */
sfeud03     varchar2(40),            /*自订字段-文字                          */
sfeud04     varchar2(40),            /*自订字段-文字                          */
sfeud05     varchar2(40),            /*自订字段-文字                          */
sfeud06     varchar2(40),            /*自订字段-文字                          */
sfeud07     number(15,3),            /*自订字段-数值                          */
sfeud08     number(15,3),            /*自订字段-数值                          */
sfeud09     number(15,3),            /*自订字段-数值                          */
sfeud10     number(10),              /*自订字段-整数                          */
sfeud11     number(10),              /*自订字段-整数                          */
sfeud12     number(10),              /*自订字段-整数                          */
sfeud13     date,                    /*自订字段-日期                          */
sfeud14     date,                    /*自订字段-日期                          */
sfeud15     date,                    /*自订字段-日期                          */
sfe37       varchar2(10)             /*理由码                                 */
);

create        index sfe_03 on sfe_file (sfe04);
create        index sfe_04 on sfe_file (sfe07);
create        index sfe_01 on sfe_file (sfe01);
create        index sfe_02 on sfe_file (sfe02);
grant select on sfe_file to tiptopgp;
grant update on sfe_file to tiptopgp;
grant delete on sfe_file to tiptopgp;
grant insert on sfe_file to tiptopgp;
grant index on sfe_file to public;
grant select on sfe_file to ods;
