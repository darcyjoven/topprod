/*
================================================================================
檔案代號:cxh_file
檔案名稱:每月工艺元件在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cxh_file
(
cxh01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
cxh011      varchar2(10) NOT NULL,   /*成本中心编号                           */
                                     /*成本中心編號                           */
cxh012      varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
cxh02       number(5) NOT NULL,      /*年度                                   */
cxh03       number(5) NOT NULL,      /*月份                                   */
cxh04       varchar2(40) NOT NULL,   /*元件料号                               */
                                     /*元件料號                               */
cxh05       varchar2(1) NOT NULL,    /*元件料号类型                           */
                                     /*元件料號類別 (Purchase/Make/Rework)    */
cxh11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量(製程轉出單位之結存量)     */
cxh12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
cxh12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
cxh12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
cxh12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
cxh12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
cxh12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
cxh21       number(15,3) NOT NULL,   /*本月本站投入数量                       */
                                     /*Current Month This Station Input Qty(Routing Trans-in Unit Input Qty )*/
cxh22       number(20,6) NOT NULL,   /*本月本站投入金额(a+b+c+d+e)            */
                                     /*本月本站投入金額(a+b+c+d+e)            */
cxh22a      number(20,6) NOT NULL,   /*本月本站投入金额-材料   (a)            */
                                     /*本月本站投入金額-材料   (a)            */
cxh22b      number(20,6) NOT NULL,   /*本月本站投入金额-人工   (b)            */
                                     /*本月本站投入金額-人工   (b)            */
cxh22c      number(20,6) NOT NULL,   /*本月本站投入金额-制费   (c)            */
                                     /*本月本站投入金額-製費   (c)            */
cxh22d      number(20,6) NOT NULL,   /*本月本站投入金额-加工   (d)            */
                                     /*本月本站投入金額-加工   (d)            */
cxh22e      number(20,6) NOT NULL,   /*本月本站投入金额-其他   (e)            */
                                     /*本月本站投入金額-其他   (e)            */
cxh24       number(15,3) NOT NULL,   /*本月前工艺入                           */
                                     /*Routing In Before Current Month(Routing Trans-in Unit Input Qty)*/
cxh25       number(15,3) NOT NULL,   /*本月前工艺入(a+b+c+d+e)                */
                                     /*本月前製程入(a+b+c+d+e)                */
cxh25a      number(20,6) NOT NULL,   /*本月前工艺入-材料   (a)                */
                                     /*本月前製程入-材料   (a)                */
cxh25b      number(20,6) NOT NULL,   /*本月前工艺入-人工   (b)                */
                                     /*本月前製程入-人工   (b)                */
cxh25c      number(20,6) NOT NULL,   /*本月前工艺投入金额-制费一 (c           */
                                     /*本月前製程入-製費   (c)                */
cxh25d      number(20,6) NOT NULL,   /*本月前工艺入-加工   (d)                */
                                     /*本月前製程入-加工   (d)                */
cxh25e      number(20,6) NOT NULL,   /*本月前工艺投入金额-制费二  (           */
                                     /*本月前製程入-其他   (e)                */
cxh26       number(15,3) NOT NULL,   /*工单转入量                             */
                                     /*工單轉入量                             */
cxh27       number(20,6) NOT NULL,   /*工单转入金额(a+b+c+d+e)                */
                                     /*工單轉入金額(a+b+c+d+e)                */
cxh27a      number(20,6) NOT NULL,   /*工单转入金额-材料   (a)                */
                                     /*工單轉入金額-材料   (a)                */
cxh27b      number(20,6) NOT NULL,   /*工单转入金额-人工   (b)                */
                                     /*工單轉入金額-人工   (b)                */
cxh27c      number(20,6) NOT NULL,   /*工单转入金额-制费   (c)                */
                                     /*工單轉入金額-製費   (c)                */
cxh27d      number(20,6) NOT NULL,   /*工单转入金额-加工   (d)                */
                                     /*工單轉入金額-加工   (d)                */
cxh27e      number(20,6) NOT NULL,   /*工单转入金额-其他   (e)                */
                                     /*工單轉入金額-其他   (e)                */
cxh28       number(15,3) NOT NULL,   /*重流转入量                             */
                                     /*重流轉入量                             */
cxh29       number(20,6) NOT NULL,   /*重流转入金额(a+b+c+d+e)                */
                                     /*重流轉入金額(a+b+c+d+e)                */
cxh29a      number(20,6) NOT NULL,   /*重流转入金额-材料   (a)                */
                                     /*重流轉入金額-材料   (a)                */
cxh29b      number(20,6) NOT NULL,   /*重流转入金额-人工   (b)                */
                                     /*重流轉入金額-人工   (b)                */
cxh29c      number(20,6) NOT NULL,   /*重流转入金额-制费   (c)                */
                                     /*重流轉入金額-製費   (c)                */
cxh29d      number(20,6) NOT NULL,   /*重流转入金额-加工   (d)                */
                                     /*重流轉入金額-加工   (d)                */
cxh29e      number(20,6) NOT NULL,   /*重流转入金额-其他   (e)                */
                                     /*重流轉入金額-其他   (e)                */
cxh31       number(15,3) NOT NULL,   /*本月转下工艺(良品转出量+BONUS          */
cxh32       number(15,3) NOT NULL,   /*本月转下工艺(a+b+c+d+e)                */
                                     /*本月轉下製程(a+b+c+d+e)                */
cxh32a      number(20,6) NOT NULL,   /*本月转下工艺-材料   (a)                */
                                     /*本月轉下製程-材料   (a)                */
cxh32b      number(20,6) NOT NULL,   /*本月转下工艺-人工   (b)                */
                                     /*本月轉下製程-人工   (b)                */
cxh32c      number(20,6) NOT NULL,   /*本月转下工艺-制费   (c)                */
                                     /*本月轉下製程-製費   (c)                */
cxh32d      number(20,6) NOT NULL,   /*本月转下工艺-加工   (d)                */
                                     /*本月轉下製程-加工   (d)                */
cxh32e      number(20,6) NOT NULL,   /*本月转下工艺-其他   (e)                */
                                     /*本月轉下製程-其他   (e)                */
cxh33       number(15,3) NOT NULL,   /*本月报废数量                           */
                                     /*Current Month Scrap Qty(Routing Trans-out Unit Scrap Qty)*/
cxh34       number(20,6) NOT NULL,   /*本月报废金额(a+b+c+d+e)                */
                                     /*本月報廢金額(a+b+c+d+e)                */
cxh34a      number(20,6) NOT NULL,   /*本月报废金额-材料   (a)                */
                                     /*本月報廢金額-材料   (a)                */
cxh34b      number(20,6) NOT NULL,   /*本月报废金额-人工   (b)                */
                                     /*本月報廢金額-人工   (b)                */
cxh34c      number(20,6) NOT NULL,   /*本月报废金额-制费   (c)                */
                                     /*本月報廢金額-製費   (c)                */
cxh34d      number(20,6) NOT NULL,   /*本月报废金额-加工   (d)                */
                                     /*本月報廢金額-加工   (d)                */
cxh34e      number(20,6) NOT NULL,   /*本月报废金额-其他   (e)                */
                                     /*本月報廢金額-其他   (e)                */
cxh35       number(15,3) NOT NULL,   /*工单转出量                             */
                                     /*工單轉出量                             */
cxh36       number(20,6) NOT NULL,   /*工单转出金额(a+b+c+d+e)                */
cxh36a      number(20,6) NOT NULL,   /*工单转出金额-材料   (a)                */
cxh36b      number(20,6) NOT NULL,   /*工单转出金额-人工   (b)                */
cxh36c      number(20,6) NOT NULL,   /*工单转出金额-制费   (c)                */
cxh36d      number(20,6) NOT NULL,   /*工单转出金额-加工   (d)                */
cxh36e      number(20,6) NOT NULL,   /*工单转出金额-其他   (e)                */
cxh37       number(15,3) NOT NULL,   /*本月当站下线数量                       */
                                     /*本月當站下線數量                       */
cxh38       number(20,6) NOT NULL,   /*本月当站下线金额(a+b+c+d+e)            */
                                     /*本月當站下線金額(a+b+c+d+e)            */
cxh38a      number(20,6) NOT NULL,   /*本月当站下线金额-材料   (a)            */
                                     /*本月當站下線金額-材料   (a)            */
cxh38b      number(20,6) NOT NULL,   /*本月当站下线金额-人工   (b)            */
                                     /*本月當站下線金額-人工   (b)            */
cxh38c      number(20,6) NOT NULL,   /*本月当站下线金额-制费   (c)            */
cxh38d      number(20,6) NOT NULL,   /*本月当站下线金额-加工   (d)            */
                                     /*本月當站下線金額-加工   (d)            */
cxh38e      number(20,6) NOT NULL,   /*本月当站下线金额-其他   (e)            */
                                     /*本月當站下線金額-其他   (e)            */
cxh39       number(15,3) NOT NULL,   /*本月重流数量                           */
                                     /*Current Rework Qty(Routing Trans-out Unit Manufacture Rework Qty)*/
cxh40       number(20,6) NOT NULL,   /*本月重流金额(a+b+c+d+e)                */
                                     /*本月重流金額(a+b+c+d+e)                */
cxh40a      number(20,6) NOT NULL,   /*本月重流金额-材料   (a)                */
                                     /*本月重流金額-材料   (a)                */
cxh40b      number(20,6) NOT NULL,   /*本月重流金额-人工   (b)                */
                                     /*本月重流金額-人工   (b)                */
cxh40c      number(20,6) NOT NULL,   /*本月重流金额-制费   (c)                */
                                     /*本月重流金額-製費   (c)                */
cxh40d      number(20,6) NOT NULL,   /*本月重流金额-加工   (d)                */
                                     /*本月重流金額-加工   (d)                */
cxh40e      number(20,6) NOT NULL,   /*本月重流金额-其他   (e)                */
                                     /*本月重流金額-其他   (e)                */
cxh41       number(15,3) NOT NULL,   /*差异转出数量                           */
                                     /*Variation Transfer-out Qty(Routing Trans-out Unit Variation Qty)*/
cxh42       number(20,6) NOT NULL,   /*差异转出金额(a+b+c+d+e)                */
                                     /*差異轉出金額(a+b+c+d+e)                */
cxh42a      number(20,6) NOT NULL,   /*差异转出金额-材料   (a)                */
                                     /*差異轉出金額-材料   (a)                */
cxh42b      number(20,6) NOT NULL,   /*差异转出金额-人工   (b)                */
                                     /*差異轉出金額-人工   (b)                */
cxh42c      number(20,6) NOT NULL,   /*差异转出金额-制费   (c)                */
                                     /*差異轉出金額-製費   (c)                */
cxh42d      number(20,6) NOT NULL,   /*差异转出金额-加工   (d)                */
                                     /*差異轉出金額-加工   (d)                */
cxh42e      number(20,6) NOT NULL,   /*差异转出金额-其他   (e)                */
                                     /*差異轉出金額-其他   (e)                */
cxh51       number(15,3) NOT NULL,   /*累计投入数量                           */
                                     /*Accumulated Input Qty(Routing Trans-in Unit Input Qty)*/
cxh52       number(20,6) NOT NULL,   /*累计投入金额(a+b+c+d+e)                */
                                     /*累計投入金額(a+b+c+d+e)                */
cxh52a      number(20,6) NOT NULL,   /*累计投入金额-材料   (a)                */
                                     /*累計投入金額-材料   (a)                */
cxh52b      number(20,6) NOT NULL,   /*累计投入金额-人工   (b)                */
                                     /*累計投入金額-人工   (b)                */
cxh52c      number(20,6) NOT NULL,   /*累计投入金额-制费   (c)                */
                                     /*累計投入金額-製費   (c)                */
cxh52d      number(20,6) NOT NULL,   /*累计投入金额-加工   (d)                */
                                     /*累計投入金額-加工   (d)                */
cxh52e      number(20,6) NOT NULL,   /*累计投入金额-其他   (e)                */
                                     /*累計投入金額-其他   (e)                */
cxh53       number(15,3) NOT NULL,   /*累计转出数量                           */
                                     /*Accumulated Transfer-out Qty(Routing Trans-in Unit Transfer-out Qty)*/
cxh54       number(20,6) NOT NULL,   /*累计转出金额(a+b+c+d+e)                */
                                     /*累計轉出金額(a+b+c+d+e)                */
cxh54a      number(20,6) NOT NULL,   /*累计转出金额-材料   (a)                */
                                     /*累計轉出金額-材料   (a)                */
cxh54b      number(20,6) NOT NULL,   /*累计转出金额-人工   (b)                */
                                     /*累計轉出金額-人工   (b)                */
cxh54c      number(20,6) NOT NULL,   /*累计转出金额-制费   (c)                */
                                     /*累計轉出金額-製費   (c)                */
cxh54d      number(20,6) NOT NULL,   /*累计转出金额-加工   (d)                */
                                     /*累計轉出金額-加工   (d)                */
cxh54e      number(20,6) NOT NULL,   /*累计转出金额-其他   (e)                */
                                     /*累計轉出金額-其他   (e)                */
cxh55       number(15,3) NOT NULL,   /*累计超领退数量                         */
                                     /*累計超領退數量(製程轉入單位之超領退量) */
cxh56       number(20,6) NOT NULL,   /*累计超领退金额(a+b+c+d+e)              */
                                     /*累計超領退金額(a+b+c+d+e)              */
cxh56a      number(20,6) NOT NULL,   /*累计超领退金额-材料   (a)              */
                                     /*累計超領退金額-材料   (a)              */
cxh56b      number(20,6) NOT NULL,   /*累计超领退金额-人工   (b)              */
                                     /*累計超領退金額-人工   (b)              */
cxh56c      number(20,6) NOT NULL,   /*累计超领退金额-制费   (c)              */
                                     /*累計超領退金額-製費   (c)              */
cxh56d      number(20,6) NOT NULL,   /*累计超领退金额-加工   (d)              */
                                     /*累計超領退金額-加工   (d)              */
cxh56e      number(20,6) NOT NULL,   /*累计超领退金额-其他   (e)              */
                                     /*累計超領退金額-其他   (e)              */
cxh57       number(15,3) NOT NULL,   /*本期超领退数量(工艺转入单位            */
cxh58       number(20,6) NOT NULL,   /*本期超领退金额(a+b+c+d+e)              */
                                     /*本期超領退金額(a+b+c+d+e)              */
cxh58a      number(20,6) NOT NULL,   /*本期超领退金额-材料   (a)              */
                                     /*本期超領退金額-材料   (a)              */
cxh58b      number(20,6) NOT NULL,   /*本期超领退金额-人工   (b)              */
                                     /*本期超領退金額-人工   (b)              */
cxh58c      number(20,6) NOT NULL,   /*本期超领退金额-制费   (c)              */
                                     /*本期超領退金額-製費   (c)              */
cxh58d      number(20,6) NOT NULL,   /*本期超领退金额-加工   (d)              */
                                     /*本期超領退金額-加工   (d)              */
cxh58e      number(20,6) NOT NULL,   /*本期超领退金额-其他   (e)              */
                                     /*本期超領退金額-其他   (e)              */
cxh59       number(15,3) NOT NULL,   /*盘差数量                               */
                                     /*Inventory Difference Qty(Routing Trans-in Unit Inventory Difference Qty)*/
cxh60       number(20,6) NOT NULL,   /*盘差金额(a+b+c+d+e)                    */
                                     /*盤差金額(a+b+c+d+e)                    */
cxh60a      number(20,6) NOT NULL,   /*盘差金额-材料   (a)                    */
                                     /*盤差金額-材料   (a)                    */
cxh60b      number(20,6) NOT NULL,   /*盘差金额-人工   (b)                    */
                                     /*盤差金額-人工   (b)                    */
cxh60c      number(20,6) NOT NULL,   /*盘差金额-制费   (c)                    */
                                     /*盤差金額-製費   (c)                    */
cxh60d      number(20,6) NOT NULL,   /*盘差金额-加工   (d)                    */
                                     /*盤差金額-加工   (d)                    */
cxh60e      number(20,6) NOT NULL,   /*盘差金额-其他   (e)                    */
                                     /*盤差金額-其他   (e)                    */
cxh91       number(15,3) NOT NULL,   /*本月结存数量(工艺转出单位之            */
cxh92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
cxh92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
cxh92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
cxh92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
cxh92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
cxh92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
cxhuser     varchar2(10),            /*最近计算人员                           */
cxhdate     date,                    /*最近计算日期                           */
cxhtime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
cxh06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
cxh07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cxh12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三 (f)                */
cxh12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四 (g)                */
cxh12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五 (h)                */
cxh22f      number(20,6) DEFAULT '0',/*本月本站投入金额-制费三 (f)            */
cxh22g      number(20,6) DEFAULT '0',/*本月本站投入金额-制费四 (g)            */
cxh22h      number(20,6) DEFAULT '0',/*本月本站投入金额-制费五 (h)            */
cxh25f      number(20,6) DEFAULT '0',/*本月前工艺投入金额-制费三  (           */
cxh25g      number(20,6) DEFAULT '0',/*本月前工艺投入金额-制费四  (           */
cxh25h      number(20,6) DEFAULT '0',/*本月前工艺投入金额-制费五  (           */
cxh27f      number(20,6) DEFAULT '0',/*工单转入金额-制费三   (f)              */
cxh27g      number(20,6) DEFAULT '0',/*工单转入金额-制费四   (g)              */
cxh27h      number(20,6) DEFAULT '0',/*工单转入金额-制费五   (h)              */
cxh29f      number(20,6) DEFAULT '0',/*重流转入金额-制费三 (f)                */
cxh29g      number(20,6) DEFAULT '0',/*重流转入金额-制费四 (g)                */
cxh29h      number(20,6) DEFAULT '0',/*重流转入金额-制费五 (h)                */
cxh32f      number(20,6) DEFAULT '0',/*本月转下工艺金额-制费三 (f)            */
cxh32g      number(20,6) DEFAULT '0',/*本月转下工艺金额-制费四 (g)            */
cxh32h      number(20,6) DEFAULT '0',/*本月转下工艺金额-制费五 (h)            */
cxh34f      number(20,6) DEFAULT '0',/*本月报废金额-制费三 (f)                */
cxh34g      number(20,6) DEFAULT '0',/*本月报废金额-制费四 (g)                */
cxh34h      number(20,6) DEFAULT '0',/*本月报废金额-制费五 (h)                */
cxh36f      number(20,6) DEFAULT '0',/*工单转出金额-制费三  (f)               */
cxh36g      number(20,6) DEFAULT '0',/*工单转出金额-制费四  (g)               */
cxh36h      number(20,6) DEFAULT '0',/*工单转出金额-制费五  (h)               */
cxh38f      number(20,6) DEFAULT '0',/*本月当站下线金额-制费三 (f)            */
cxh38g      number(20,6) DEFAULT '0',/*本月当站下线金额-制费四 (g)            */
cxh38h      number(20,6) DEFAULT '0',/*本月当站下线金额-制费五 (h)            */
cxh40f      number(20,6) DEFAULT '0',/*本月重流金额-制费三 (f)                */
cxh40g      number(20,6) DEFAULT '0',/*本月重流金额-制费四 (g)                */
cxh40h      number(20,6) DEFAULT '0',/*本月重流金额-制费五 (h)                */
cxh42f      number(20,6) DEFAULT '0',/*差异转出金额-制费三 (f)                */
cxh42g      number(20,6) DEFAULT '0',/*差异转出金额-制费四 (g)                */
cxh42h      number(20,6) DEFAULT '0',/*差异转出金额-制费五 (h)                */
cxh52f      number(20,6) DEFAULT '0',/*累计投入金额-制费三                    */
cxh52g      number(20,6) DEFAULT '0',/*累计投入金额-制费四                    */
cxh52h      number(20,6) DEFAULT '0',/*累计投入金额-制费五                    */
cxh54f      number(20,6) DEFAULT '0',/*累计转出金额-制费三                    */
cxh54g      number(20,6) DEFAULT '0',/*累计转出金额-制费四                    */
cxh54h      number(20,6) DEFAULT '0',/*累计转出金额-制费五                    */
cxh56f      number(20,6) DEFAULT '0',/*累计超领退金额-制费三                  */
cxh56g      number(20,6) DEFAULT '0',/*累计超领退金额-制费四                  */
cxh56h      number(20,6) DEFAULT '0',/*累计超领退金额-制费五                  */
cxh58f      number(20,6) DEFAULT '0',/*本期超领退金额-制费三                  */
cxh58g      number(20,6) DEFAULT '0',/*本期超领退金额-制费四                  */
cxh58h      number(20,6) DEFAULT '0',/*本期超领退金额-制费五                  */
cxh60f      number(20,6) DEFAULT '0',/*盘差金额-制费三                        */
cxh60g      number(20,6) DEFAULT '0',/*盘差金额-制费四                        */
cxh60h      number(20,6) DEFAULT '0',/*盘差金额-制费五                        */
cxh92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三 (f)                */
cxh92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四 (g)                */
cxh92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五 (h)                */
cxhlegal    varchar2(10) NOT NULL,   /*所属法人                               */
cxhorig     varchar2(10),            /*资料建立部门                           */
cxhoriu     varchar2(10),            /*资料建立者                             */
cxh013      varchar2(10) DEFAULT ' ' NOT NULL, /*工艺段号*/
cxh014      number(5) DEFAULT '0' NOT NULL /*工艺序*/
);

create        index cxh_02 on cxh_file (cxh04);
alter table cxh_file add  constraint cxh_pk primary key  (cxh01,cxh011,cxh012,cxh02,cxh03,cxh04,cxh06,cxh07,cxh013,cxh014) enable validate;
grant select on cxh_file to tiptopgp;
grant update on cxh_file to tiptopgp;
grant delete on cxh_file to tiptopgp;
grant insert on cxh_file to tiptopgp;
grant index on cxh_file to public;
grant select on cxh_file to ods;
