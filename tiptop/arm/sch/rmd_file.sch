/*
================================================================================
檔案代號:rmd_file
檔案名稱:RMA 用料明细档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rmd_file
(
rmd01       varchar2(20) NOT NULL,   /*RMA单号                                */
                                     /*RMA單號                                */
rmd02       number(5) NOT NULL,      /*项次                                   */
                                     /*項次                                   */
rmd03       number(5) NOT NULL,      /*RET No.                                */
                                     /*指向rmc_file之項次                     */
rmd031      number(5),               /*索引--当索引相同时表示对同             */
                                     /*索引--當索引相同時表示對同一零件       */
                                     /*      所作的維修紀錄                   */
rmd04       varchar2(40),            /*料件编号                               */
                                     /*料件編號                               */
rmd05       varchar2(4),             /*单位                                   */
                                     /*單位                                   */
rmd06       varchar2(120),           /*品名                                   */
rmd061      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
rmd07       varchar2(15),            /*S/N                                    */
rmd08       varchar2(1),             /*用退码                                 */
                                     /*用退碼                                 */
                                     /* 1.用料 : 修復使用材料                 */
                                     /* 2.退料 : 修復剩餘材料                 */
rmd12       number(15,3) NOT NULL,   /*数量                                   */
                                     /*數量                                   */
rmd13       number(20,6) NOT NULL,   /*成本单价-料工费                        */
                                     /*成本單價-料工費                        */
                                     /* 用料 : RMA倉之材料成本                */
                                     /* 拆除 : 須人工輸入                     */
rmd14       number(20,6) NOT NULL,   /*成本金额                               */
                                     /* 成本金額 = rmd12*rmd13                */
rmd15       varchar2(10),            /*仓库                                   */
                                     /*倉庫別 : 保留不用                      */
rmd16       varchar2(10),            /*库位别                                 */
                                     /*儲位別 : 保留不用                      */
rmd17       varchar2(24),            /*批号                                   */
                                     /*批號   : 保留不用  No.+024             */
rmd21       varchar2(20),            /*杂项领退料单单号                       */
                                     /*雜項領退料單單號                       */
rmd22       number(5),               /*杂项领退料单项次                       */
                                     /*雜項領退料單項次                       */
rmd23       varchar2(10),            /*不良现象代码                           */
                                     /*不良現象代碼(cause code)               */
rmd24       varchar2(80),            /*不良现象额外说明                       */
                                     /*不良現象額外說明                       */
rmd25       varchar2(10),            /*不良原因代码                           */
                                     /*不良原因代碼(repair action  code)      */
rmd26       varchar2(80),            /*不良原因额外说明                       */
                                     /*不良原因額外說明                       */
rmd27       varchar2(1),             /*责任归属                               */
                                     /*責任歸屬 A.公司 U.客戶                 */
rmd31       varchar2(20),            /*不良分析单单号                         */
                                     /*不良分析單單號                         */
rmd32       number(5),               /*不良品分析单项次                       */
                                     /*不良品分析單項次                       */
rmd33       varchar2(1),             /*检验结果                               */
                                     /*檢驗結果--0/1/2/3                      */
rmd34       varchar2(20),            /*调拨单号                               */
                                     /*調撥單號                               */
rmdud01     varchar2(255),           /*自订字段-Textedit                      */
rmdud02     varchar2(40),            /*自订字段-文字                          */
rmdud03     varchar2(40),            /*自订字段-文字                          */
rmdud04     varchar2(40),            /*自订字段-文字                          */
rmdud05     varchar2(40),            /*自订字段-文字                          */
rmdud06     varchar2(40),            /*自订字段-文字                          */
rmdud07     number(15,3),            /*自订字段-数值                          */
rmdud08     number(15,3),            /*自订字段-数值                          */
rmdud09     number(15,3),            /*自订字段-数值                          */
rmdud10     number(10),              /*自订字段-整数                          */
rmdud11     number(10),              /*自订字段-整数                          */
rmdud12     number(10),              /*自订字段-整数                          */
rmdud13     date,                    /*自订字段-日期                          */
rmdud14     date,                    /*自订字段-日期                          */
rmdud15     date,                    /*自订字段-日期                          */
rmdplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
rmdlegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index rmd_02 on rmd_file (rmd31,rmd32);
alter table rmd_file add  constraint rmd_pk primary key  (rmd01,rmd03,rmd02) enable validate;
grant select on rmd_file to tiptopgp;
grant update on rmd_file to tiptopgp;
grant delete on rmd_file to tiptopgp;
grant insert on rmd_file to tiptopgp;
grant index on rmd_file to public;
grant select on rmd_file to ods;
