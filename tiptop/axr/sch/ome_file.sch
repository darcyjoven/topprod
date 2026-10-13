/*
================================================================================
檔案代號:ome_file
檔案名稱:销项 GUI 档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table ome_file
(
ome00       varchar2(1) NOT NULL,    /*发票类型                               */
                                     /*Invoice Cate 1.Sales Invoice           */
                                     /*             3.Not Receivable Invoice  */
ome01       varchar2(20) NOT NULL,   /*发票号码                               */
                                     /*發票號碼                               */
ome02       date,                    /*发票日期                               */
                                     /*發票日期                               */
ome04       varchar2(10),            /*发票客户编号                           */
                                     /*發票客戶編號                           */
ome042      varchar2(20),            /*发票客户税号                           */
                                     /*發票客戶統一編號                       */
ome043      varchar2(80),            /*发票客户全名                           */
                                     /*發票客戶全名                           */
ome044      varchar2(255),           /*发票客户地址                           */
                                     /*發票客戶Addr                           */
ome05       varchar2(5),             /*发票别                                 */
                                     /*發票別                                 */
ome08       varchar2(1),             /*1.内销 2.外销                          */
                                     /*1.內銷 2.外銷                          */
ome16       varchar2(20),            /*帐单号码                               */
                                     /*帳單號碼                               */
ome17       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分 (1/2)       No:6374           */
ome171      varchar2(2),             /*格式                                   */
                                     /*格式 (31/32/33/34/35)                  */
ome172      varchar2(1),             /*课税种                                 */
                                     /*課稅別 (1/2/3/D/F)                     */
ome173      number(5),               /*申报年度                               */
                                     /*申報年度(西元)                         */
ome174      number(5),               /*申报月份                               */
                                     /*申報月份                               */
ome175      number(10),              /*申报流水编号                           */
                                     /*申報流水編號                           */
ome21       varchar2(4),             /*税种                                   */
                                     /*稅別                                   */
ome211      number(9,4),             /*税率                                   */
                                     /*稅率   (由稅別檔預設,不可改)           */
ome212      varchar2(1),             /*联数                                   */
                                     /*聯數   (由稅別檔預設,不可改)           */
ome213      varchar2(1),             /*含税否                                 */
                                     /*含稅否 (由稅別檔預設,不可改)           */
ome32       date,                    /*报关日期                               */
                                     /*報關日期                               */
ome33       date,                    /*放行日期                               */
ome34       date,                    /*出口日期                               */
ome35       varchar2(1),             /*外销方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7) -> no use      */
ome38       varchar2(1),             /*出口文件类型                           */
                                     /*出口文件類別            -> no use      */
                                     /* 1.出口報單                            */
                                     /* 2.快捷郵件 3.攜出證明 4.零稅率證明聯  */
ome39       varchar2(20),            /*出口文件号码                           */
                                     /*出口文件號碼            -> no use      */
ome59       number(20,6) NOT NULL,   /*本币发票税前金额                       */
                                     /*本幣發票未稅金額                       */
ome59x      number(20,6) NOT NULL,   /*本币发票税额                           */
                                     /*本幣發票稅額                           */
ome59t      number(20,6) NOT NULL,   /*本币发票含税金额                       */
                                     /*本幣發票含稅金額                       */
omevoid     varchar2(1),             /*作废否                                 */
                                     /*作廢否 (Y/N)                           */
omevoid2    varchar2(10),            /*作废理由码                             */
                                     /*作廢理由碼                             */
omevoidu    varchar2(10),            /*作废人员                               */
                                     /*作廢人員                               */
omevoidd    date,                    /*作废日期                               */
                                     /*作廢日期                               */
omeprsw     number(5),               /*打印次数                               */
                                     /*列印次數                               */
omeuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
omegrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
omemodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
omemodd     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
omedate     date,                    /*资料录入日                             */
                                     /*資料輸入日                             */
omeud01     varchar2(255),           /*自订字段-Textedit                      */
omeud02     varchar2(40),            /*自订字段-文字                          */
omeud03     varchar2(40),            /*自订字段-文字                          */
omeud04     varchar2(40),            /*自订字段-文字                          */
omeud05     varchar2(40),            /*自订字段-文字                          */
omeud06     varchar2(40),            /*自订字段-文字                          */
omeud07     number(15,3),            /*自订字段-数值                          */
omeud08     number(15,3),            /*自订字段-数值                          */
omeud09     number(15,3),            /*自订字段-数值                          */
omeud10     number(10),              /*自订字段-整数                          */
omeud11     number(10),              /*自订字段-整数                          */
omeud12     number(10),              /*自订字段-整数                          */
omeud13     date,                    /*自订字段-日期                          */
omeud14     date,                    /*自订字段-日期                          */
omeud15     date,                    /*自订字段-日期                          */
omelegal    varchar2(10) NOT NULL,   /*所属法人                               */
ome60       varchar2(20),            /*申报税号                               */
omeoriu     varchar2(10),            /*资料建立者                             */
omeorig     varchar2(10),            /*资料建立部门                           */
ome011      varchar2(20),            /*发票截止号码                           */
ome70       varchar2(1) DEFAULT 'N' NOT NULL, /*POS开立否*/
ome71       varchar2(10),            /*POS机号                                */
ome72       varchar2(20),            /*POS单号                                */
ome73       varchar2(10),            /*营运中心编号                           */
ome74       number(20,6) DEFAULT '0' NOT NULL, /*礼券已开发票金额*/
ome75       number(20,6) DEFAULT '0' NOT NULL, /*礼券已开发票税额*/
ome76       number(20,6) DEFAULT '0' NOT NULL, /*已开发票留抵税额*/
ome77       varchar2(1) DEFAULT ' ' NOT NULL, /*开立方式*/
ome78       number(20,6) DEFAULT '0' NOT NULL, /*应税金额*/
ome79       number(20,6) DEFAULT '0' NOT NULL, /*零税金额*/
ome80       number(20,6) DEFAULT '0' NOT NULL, /*免税金额*/
ome03       varchar2(20) DEFAULT ' ' NOT NULL, /*发票代码*/
ome22       varchar2(1) DEFAULT 'N' NOT NULL, /*电子发票否*/
ome23       varchar2(6),             /*载具类别号码                           */
ome24       varchar2(80),            /*载具显码ID                             */
ome25       varchar2(10),            /*爱心码                                 */
ome241      varchar2(80),            /*载具隐码ID                             */
ome26       varchar2(4),             /*发票防伪随机码                         */
omecncl     varchar2(1) DEFAULT ' ' NOT NULL, /*注销否*/
omecncl2    varchar2(10),            /*注销理由码                             */
omecncld    date,                    /*注销日期                               */
omecnclm    varchar2(255),           /*注销备注                               */
omecnclt    varchar2(8),             /*注销时间                               */
omecnclu    varchar2(10),            /*注销人员                               */
omevoidm    varchar2(255),           /*作废备注                               */
omevoidn    varchar2(60),            /*项目作废核准文号                       */
omevoidt    varchar2(8),             /*作废时间                               */
omexml      varchar2(20),            /*电子发票导出序号                       */
ome81       varchar2(1) DEFAULT ' ' NOT NULL, /*电子发票导出状态*/
                                     /*1.未汇出过,2.已汇出过                  */
ome82       varchar2(8)              /*发票时间                               */
);

create        index ome_02 on ome_file (ome02);
create        index ome_03 on ome_file (ome16);
alter table ome_file add  constraint ome_pk primary key  (ome00,ome01,ome03) enable validate;
grant select on ome_file to tiptopgp;
grant update on ome_file to tiptopgp;
grant delete on ome_file to tiptopgp;
grant insert on ome_file to tiptopgp;
grant index on ome_file to public;
grant select on ome_file to ods;
