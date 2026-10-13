/*
================================================================================
檔案代號:amd_file
檔案名稱:进销项凭证资料维护
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table amd_file
(
amd01       varchar2(20) NOT NULL,   /*账款单号                               */
amd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
amd021      varchar2(1) NOT NULL,    /*来源类型                               */
                                     /*來源類別                               */
                                     /*1 : 總帳(GL)                           */
                                     /*2 : 應付折讓(AP)                       */
                                     /*3 : 應收(AR)                           */
                                     /*4.: 其他(OT)                           */
                                     /*5.: 應付(AP)                           */
amd03       varchar2(20),            /*发票号码                               */
                                     /*發票號碼                               */
                                     /*格式28,29則輸入海關代徵營業稅繳納證號碼*/
amd04       varchar2(20),            /*厂商税号                               */
                                     /*廠商統一編號                           */
amd05       date,                    /*发票日期/凭证日期                      */
                                     /*發票日期/憑證日期                      */
amd06       number(20,6) NOT NULL,   /*含税金额                               */
                                     /*含稅金額                               */
amd07       number(20,6) NOT NULL,   /*税                                     */
                                     /*稅                                     */
amd08       number(20,6) NOT NULL,   /*税前金额                               */
                                     /*未稅金額                               */
amd09       varchar2(1),             /*汇加注记                               */
                                     /*彙加註記                               */
amd10       varchar2(1),             /*通关注记                               */
                                     /*洋菸酒註記                             */
amd17       varchar2(1),             /*扣抵区分                               */
                                     /*扣抵區分 (1,2,3,4)                     */
                                     /* 1.可扣扺之進貨及費用                  */
                                     /* 2.可扣扺之固定資產                    */
                                     /* 3.不可扣抵之進貨及費用                */
                                     /* 4.不可扣抵之固定資產                  */
amd171      varchar2(2),             /*格式                                   */
                                     /*Format   (21,22,23,24,25,26,27,28,29)  */
                                     /*         (31,32,33,34,35,36)           */
amd172      varchar2(1),             /*课税种                                 */
                                     /*課稅別   (1.應稅 2.零稅率 3.免稅 D.空白未使用發票 F.作廢)*/
                                     /* 1.應稅                                */
                                     /* 2.零稅                                */
                                     /* 3.免稅                                */
                                     /* D.空白未使用發票                      */
                                     /* F.作廢                                */
amd173      number(5),               /*资料年                                 */
                                     /*資料年                                 */
                                     /*空白發票時須要                         */
amd174      number(5),               /*资料月份                               */
                                     /*資料月份                               */
                                     /*空白發票時須要                         */
amd175      number(10),              /*申报流水编号                           */
                                     /*申報流水編號                           */
amd22       varchar2(10),            /*申报部门                               */
                                     /*申報部門                               */
amd25       varchar2(20),            /*来源营运中心                           */
                                     /*工廠編號                               */
amd26       number(5),               /*申报年度                               */
                                     /*申報年度                               */
amd27       number(5),               /*申报月份                               */
                                     /*申報月份                               */
amd28       varchar2(20),            /*凭证号码                               */
                                     /*傳票號碼  98/10/22 modify              */
amd29       varchar2(1),             /*是否检查发票字首                       */
                                     /*是否檢查發票字軌(1檢查/2不檢查)        */
amd30       varchar2(1),             /*确认码                                 */
                                     /*確認碼                                 */
amd35       varchar2(1),             /*外销方式                               */
                                     /*外銷方式(1/2/3/4/5/6/7)  01/04/23 add  */
amd36       varchar2(40),            /*非经海关证明文件名称                   */
                                     /*非經海關証明文件名稱     01/04/23 add  */
amd37       varchar2(16),            /*非经海关证明文件号码                   */
                                     /*非經海關証明文件號碼     01/04/23 add  */
amd38       varchar2(10),            /*出口报单类型                           */
                                     /*出口報單類別             01/04/23 add  */
amd39       varchar2(30),            /*出口报单号码                           */
                                     /*出口報單號碼             01/04/23 add  */
amd40       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                 01/05/24 add  */
amd41       varchar2(40),            /*客户简称                               */
                                     /*客戶簡稱                 01/05/24 add  */
amd42       date,                    /*帐款日期/出货日期                      */
                                     /*帳款日期/出貨日期        01/05/24 add  */
amd43       date,                    /*结关日期                               */
                                     /*結關日期                 01/05/24 add  */
amdacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
                                     /*系統維護                               */
amduser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
                                     /*系統維護                               */
amdgrup     varchar2(10),            /*资料所有群                             */
                                     /*資料所有群                             */
                                     /*系統維護                               */
amdmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料更改者                             */
                                     /*系統維護                               */
amddate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
                                     /*系統維護                               */
amd031      varchar2(1),             /*发票联数                               */
amd11       varchar2(1),             /*直接扣抵类型                           */
amdud01     varchar2(255),           /*自订字段-Textedit                      */
amdud02     varchar2(40),            /*自订字段-文字                          */
amdud03     varchar2(40),            /*自订字段-文字                          */
amdud04     varchar2(40),            /*自订字段-文字                          */
amdud05     varchar2(40),            /*自订字段-文字                          */
amdud06     varchar2(40),            /*自订字段-文字                          */
amdud07     number(15,3),            /*自订字段-数值                          */
amdud08     number(15,3),            /*自订字段-数值                          */
amdud09     number(15,3),            /*自订字段-数值                          */
amdud10     number(10),              /*自订字段-整数                          */
amdud11     number(10),              /*自订字段-整数                          */
amdud12     number(10),              /*自订字段-整数                          */
amdud13     date,                    /*自订字段-日期                          */
amdud14     date,                    /*自订字段-日期                          */
amdud15     date,                    /*自订字段-日期                          */
amd44       varchar2(1) DEFAULT '3' NOT NULL, /*销售固定资产*/
amdlegal    varchar2(10) NOT NULL,   /*所属法人                               */
amdoriu     varchar2(10),            /*资料建立者                             */
amdorig     varchar2(10),            /*资料建立部门                           */
amd032      varchar2(20),
amd033      varchar2(1) DEFAULT '1' NOT NULL, /*开立方式*/
amd126      varchar2(10)             /*POS机号                                */
);

create        index amd_03 on amd_file (amd01);
create        index amd_02 on amd_file (amd03);
alter table amd_file add  constraint amd_pk primary key  (amd01,amd02,amd021) enable validate;
grant select on amd_file to tiptopgp;
grant update on amd_file to tiptopgp;
grant delete on amd_file to tiptopgp;
grant insert on amd_file to tiptopgp;
grant index on amd_file to public;
grant select on amd_file to ods;
