/*
================================================================================
檔案代號:ccr_file
檔案名稱:每月工单工艺在制成本档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table ccr_file
(
ccr01       varchar2(20) NOT NULL,   /*工单编号                               */
                                     /*工單編號                               */
ccr02       number(5) NOT NULL,      /*年度                                   */
ccr03       number(5) NOT NULL,      /*月份                                   */
ccr031      number(5) NOT NULL,      /*工艺序                                 */
                                     /*製程序                                 */
ccr032      varchar2(6) NOT NULL,    /*作业编号                               */
                                     /*作業編號                               */
ccr04       varchar2(40) NOT NULL,   /*主件料号                               */
                                     /*主件料號                               */
ccr11       number(15,3) NOT NULL,   /*上月结存数量                           */
                                     /*上月結存數量                           */
ccr12       number(20,6) NOT NULL,   /*上月结存金额(a+b+c+d+e)                */
                                     /*上月結存金額(a+b+c+d+e)                */
ccr12a      number(20,6) NOT NULL,   /*上月结存金额-材料   (a)                */
                                     /*上月結存金額-材料   (a)                */
ccr12b      number(20,6) NOT NULL,   /*上月结存金额-人工   (b)                */
                                     /*上月結存金額-人工   (b)                */
ccr12c      number(20,6) NOT NULL,   /*上月结存金额-制费   (c)                */
                                     /*上月結存金額-製費   (c)                */
ccr12d      number(20,6) NOT NULL,   /*上月结存金额-加工   (d)                */
                                     /*上月結存金額-加工   (d)                */
ccr12e      number(20,6) NOT NULL,   /*上月结存金额-其他   (e)                */
                                     /*上月結存金額-其他   (e)                */
ccr13       number(15,3) NOT NULL,   /*上工艺转入数量                         */
                                     /*上製程轉入數量                         */
ccr14       number(20,6) NOT NULL,   /*上工艺转入金额(a+b+c+d+e)              */
                                     /*上製程轉入金額(a+b+c+d+e)              */
ccr14a      number(20,6) NOT NULL,   /*上工艺转入金额-材料   (a)              */
                                     /*上製程轉入金額-材料   (a)              */
ccr14b      number(20,6) NOT NULL,   /*上工艺转入月结存金额-人工              */
ccr14c      number(20,6) NOT NULL,   /*上工艺转入月结存金额-制费              */
ccr14d      number(20,6) NOT NULL,   /*上工艺转入月结存金额-加工              */
ccr14e      number(20,6) NOT NULL,   /*上工艺转入月结存金额-其他              */
ccr20       number(15,3) NOT NULL,   /*本月投入工时                           */
                                     /*本月投入工時                           */
ccr21       number(15,3) NOT NULL,   /*本月投入数量                           */
                                     /*本月投入數量                           */
ccr22       number(20,6) NOT NULL,   /*本月本阶投入金额(a+b+c+d+e) 原         */
                                     /*本月本階投入金額(a+b+c+d+e) 原料       */
ccr22a      number(20,6) NOT NULL,   /*本月本阶投入金额-材料   (a)            */
                                     /*本月本階投入金額-材料   (a)            */
ccr22b      number(20,6) NOT NULL,   /*本月本阶投入金额-人工   (b)            */
                                     /*本月本階投入金額-人工   (b)            */
ccr22c      number(20,6) NOT NULL,   /*本月本阶投入金额-制费   (c)            */
                                     /*本月本階投入金額-製費   (c)            */
ccr22d      number(20,6) NOT NULL,   /*本月本阶投入金额-加工   (d)            */
                                     /*本月本階投入金額-加工   (d)            */
ccr22e      number(20,6) NOT NULL,   /*本月本阶投入金额-其他   (e)            */
                                     /*本月本階投入金額-其他   (e)            */
ccr23       number(20,6) NOT NULL,   /*本月平均单价(a+b+c+d+e)                */
                                     /*本月平均單價(a+b+c+d+e)                */
ccr23a      number(20,6) NOT NULL,   /*本月平均单价-材料   (a)                */
                                     /*本月平均單價-材料   (a)                */
ccr23b      number(20,6) NOT NULL,   /*本月平均单价-人工   (b)                */
                                     /*本月平均單價-人工   (b)                */
ccr23c      number(20,6) NOT NULL,   /*本月平均单价-制费   (c)                */
                                     /*本月平均單價-製費   (c)                */
ccr23d      number(20,6) NOT NULL,   /*本月平均单价-加工   (d)                */
                                     /*本月平均單價-加工   (d)                */
ccr23e      number(20,6) NOT NULL,   /*本月平均单价-其他   (e)                */
                                     /*本月平均單價-其他   (e)                */
ccr24       number(15,3) NOT NULL,   /*本月其他工单投入数量                   */
                                     /*本月其他工單投入數量                   */
ccr25       number(20,6) NOT NULL,   /*本月其他工单转入金额(a+b+c+d+e         */
                                     /*本月其他工單轉入金額(a+b+c+d+e)        */
ccr25a      number(20,6) NOT NULL,   /*本月其他工单转入金额-材料              */
                                     /*本月其他工單轉入金額-材料   (a)        */
ccr25b      number(20,6) NOT NULL,   /*本月其他工单转入金额-人工              */
                                     /*本月其他工單轉入金額-人工   (b)        */
ccr25c      number(20,6) NOT NULL,   /*本月其他工单转入金额-制费              */
                                     /*本月其他工單轉入金額-製費   (c)        */
ccr25d      number(20,6) NOT NULL,   /*本月其他工单转入金额-加工              */
                                     /*本月其他工單轉入金額-加工   (d)        */
ccr25e      number(20,6) NOT NULL,   /*本月其他工单转入金额-其他              */
                                     /*本月其他工單轉入金額-其他   (e)        */
ccr31       number(15,3) NOT NULL,   /*本月转出数量                           */
                                     /*本月轉出數量                           */
ccr32       number(20,6) NOT NULL,   /*本月转出金额(a+b+c+d+e)                */
                                     /*本月轉出金額(a+b+c+d+e)                */
ccr32a      number(20,6) NOT NULL,   /*本月转出金额-材料   (a)                */
                                     /*本月轉出金額-材料   (a)                */
ccr32b      number(20,6) NOT NULL,   /*本月转出金额-人工   (b)                */
                                     /*本月轉出金額-人工   (b)                */
ccr32c      number(20,6) NOT NULL,   /*本月转出金额-制费   (c)                */
                                     /*本月轉出金額-製費   (c)                */
ccr32d      number(20,6) NOT NULL,   /*本月转出金额-加工   (d)                */
                                     /*本月轉出金額-加工   (d)                */
ccr32e      number(20,6) NOT NULL,   /*本月转出金额-其他   (e)                */
                                     /*本月轉出金額-其他   (e)                */
ccr33       number(15,3) NOT NULL,   /*本月转出至其他工单数量                 */
                                     /*本月轉出至其他工單數量                 */
ccr34       number(20,6) NOT NULL,   /*本月转出至其他工单金额(a+b+c+          */
                                     /*本月轉出至其他工單金額(a+b+c+d+e)      */
ccr34a      number(20,6) NOT NULL,   /*本月转出至其他工单金额-材料            */
                                     /*本月轉出至其他工單金額-材料   (a)      */
ccr34b      number(20,6) NOT NULL,   /*本月转出至其他工单金额-人工            */
                                     /*本月轉出至其他工單金額-人工   (b)      */
ccr34c      number(20,6) NOT NULL,   /*本月转出至其他工单金额-制费            */
                                     /*本月轉出至其他工單金額-製費   (c)      */
ccr34d      number(20,6) NOT NULL,   /*本月转出至其他工单金额-加工            */
                                     /*本月轉出至其他工單金額-加工   (d)      */
ccr34e      number(20,6) NOT NULL,   /*本月转出至其他工单金额-其他            */
                                     /*本月轉出至其他工單金額-其他   (e)      */
ccr41       number(15,3) NOT NULL,   /*差异转出数量                           */
                                     /*差異轉出數量                           */
ccr42       number(20,6) NOT NULL,   /*差异转出金额                           */
                                     /*差異轉出金額 (標準成本制下的標準差異)  */
ccr42a      number(20,6) NOT NULL,   /*差异转出金额-材料   (a)                */
                                     /*差異轉出金額-材料   (a)                */
ccr42b      number(20,6) NOT NULL,   /*差异转出金额-人工   (b)                */
                                     /*差異轉出金額-人工   (b)                */
ccr42c      number(20,6) NOT NULL,   /*差异转出金额-制费   (c)                */
                                     /*差異轉出金額-製費   (c)                */
ccr42d      number(20,6) NOT NULL,   /*差异转出金额-加工   (d)                */
                                     /*差異轉出金額-加工   (d)                */
ccr42e      number(20,6) NOT NULL,   /*差异转出金额-其他   (e)                */
                                     /*差異轉出金額-其他   (e)                */
ccr91       number(15,3) NOT NULL,   /*本月结存数量                           */
                                     /*本月結存數量                           */
ccr92       number(20,6) NOT NULL,   /*本月结存金额(a+b+c+d+e)                */
                                     /*本月結存金額(a+b+c+d+e)                */
ccr92a      number(20,6) NOT NULL,   /*本月结存金额-材料   (a)                */
                                     /*本月結存金額-材料   (a)                */
ccr92b      number(20,6) NOT NULL,   /*本月结存金额-人工   (b)                */
                                     /*本月結存金額-人工   (b)                */
ccr92c      number(20,6) NOT NULL,   /*本月结存金额-制费   (c)                */
                                     /*本月結存金額-製費   (c)                */
ccr92d      number(20,6) NOT NULL,   /*本月结存金额-加工   (d)                */
                                     /*本月結存金額-加工   (d)                */
ccr92e      number(20,6) NOT NULL,   /*本月结存金额-其他   (e)                */
                                     /*本月結存金額-其他   (e)                */
ccruser     varchar2(10),            /*最近计算人员                           */
                                     /*最近計算人員                           */
ccrdate     date,                    /*最近计算日期                           */
                                     /*最近計算日期                           */
ccrtime     varchar2(5),             /*最近计算时间                           */
                                     /*最近計算時間                           */
ccr06       varchar2(1) DEFAULT ' ' NOT NULL, /*成本计算类型*/
ccr07       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
ccr12f      number(20,6) DEFAULT '0',/*上月结存金额-制费三   (f)              */
ccr12g      number(20,6) DEFAULT '0',/*上月结存金额-制费四   (g)              */
ccr12h      number(20,6) DEFAULT '0',/*上月结存金额-制费五   (h)              */
ccr14f      number(20,6) DEFAULT '0',/*上工艺转入月结存金额-制费三            */
ccr14g      number(20,6) DEFAULT '0',/*上工艺转入月结存金额-制费四            */
ccr14h      number(20,6) DEFAULT '0',/*上工艺转入月结存金额-制费五            */
ccr22f      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费三 (f)            */
ccr22g      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费四 (g)            */
ccr22h      number(20,6) DEFAULT '0',/*本月本阶投入金额-制费五 (h             */
ccr23f      number(20,6) DEFAULT '0',/*本月平均单价-制费三 (f)                */
ccr23g      number(20,6) DEFAULT '0',/*本月平均单价-制费四 (g)                */
ccr23h      number(20,6) DEFAULT '0',/*本月平均单价-制费五 (h)                */
ccr25f      number(20,6) DEFAULT '0',/*本月其他工单转入金额-制费三            */
ccr25g      number(20,6) DEFAULT '0',/*本月其他工单转入金额-制费四            */
ccr25h      number(20,6) DEFAULT '0',/*本月其他工单转入金额-制费五            */
ccr32f      number(20,6) DEFAULT '0',/*本月转出金额-制费三 (f)                */
ccr32g      number(20,6) DEFAULT '0',/*本月转出金额-制费四 (g)                */
ccr32h      number(20,6) DEFAULT '0',/*本月转出金额-制费五 (h)                */
ccr34f      number(20,6) DEFAULT '0',/*本月转出至其他工单金额-制费            */
ccr34g      number(20,6) DEFAULT '0',/*本月转出至其他工单金额-制费            */
ccr34h      number(20,6) DEFAULT '0',/*本月转出至其他工单金额-制费            */
ccr42f      number(20,6) DEFAULT '0',/*差异转出金额-制费三 (f)                */
ccr42g      number(20,6) DEFAULT '0',/*差异转出金额-制费四 (g)                */
ccr42h      number(20,6) DEFAULT '0',/*差异转出金额-制费五 (h)                */
ccr92f      number(20,6) DEFAULT '0',/*本月结存金额-制费三 (f)                */
ccr92g      number(20,6) DEFAULT '0',/*本月结存金额-制费四 (g)                */
ccr92h      number(20,6) DEFAULT '0',/*本月结存金额-制费五 (h)                */
ccrlegal    varchar2(10) NOT NULL,   /*所属法人                               */
ccrorig     varchar2(10),            /*资料建立部门                           */
ccroriu     varchar2(10)             /*资料建立者                             */
);

create        index ccr_02 on ccr_file (ccr04);
alter table ccr_file add  constraint ccr_pk primary key  (ccr01,ccr02,ccr03,ccr031,ccr06,ccr07) enable validate;
grant select on ccr_file to tiptopgp;
grant update on ccr_file to tiptopgp;
grant delete on ccr_file to tiptopgp;
grant insert on ccr_file to tiptopgp;
grant index on ccr_file to public;
grant select on ccr_file to ods;
