/*
================================================================================
檔案代號:oqt_file
檔案名稱:报价单单头资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqt_file
(
oqt01       varchar2(20) NOT NULL,   /*报价单号                               */
                                     /*報價單號                               */
oqt02       date,                    /*日期                                   */
oqt03       varchar2(20),            /*客户单号                               */
                                     /*客戶單號                               */
oqt04       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
oqt041      varchar2(80),            /*客户全名                               */
                                     /*客戶全名     char(40)->char(72) 01/12/27*/
oqt051      varchar2(255),           /*客户地址1                              */
                                     /*客戶地址1                              */
oqt052      varchar2(255),           /*客户地址2                              */
                                     /*客戶地址2                              */
oqt053      varchar2(255),           /*客户地址3                              */
                                     /*客戶地址3                              */
oqt054      varchar2(255),           /*客户地址4                              */
                                     /*客戶地址4                              */
oqt06       varchar2(10),            /*部门                                   */
                                     /*部門                                   */
oqt07       varchar2(10),            /*业务员编号                             */
                                     /*業務員編號                             */
oqt08       varchar2(80),            /*目的地                                 */
oqt09       varchar2(4),             /*币种                                   */
                                     /*幣別                                   */
oqt091      varchar2(4),             /*No Use                                 */
oqt10       varchar2(8),             /*价格条件                               */
                                     /*交易條件                               */
oqt11       varchar2(10),            /*运输方式                               */
                                     /*運輸方式                               */
oqt12       varchar2(1),             /*分量计价                               */
                                     /*分量計價 Y/N                           */
oqt13       varchar2(80),            /*抬头                                   */
                                     /*抬頭                                   */
oqt141      varchar2(255),           /*文件内容1                              */
                                     /*文件內容1                              */
oqt142      varchar2(255),           /*文件内容2                              */
                                     /*文件內容2                              */
oqt143      varchar2(255),           /*文件内容3                              */
                                     /*文件內容3                              */
oqt151      varchar2(255),           /*收款-1                                 */
oqt152      varchar2(255),           /*收款-2                                 */
oqt161      varchar2(255),           /*出货-1                                 */
                                     /*出貨-1                                 */
oqt162      varchar2(255),           /*出货-2                                 */
                                     /*出貨-2                                 */
oqt171      varchar2(255),           /*包装-1                                 */
                                     /*包裝-1                                 */
oqt172      varchar2(255),           /*包装-2                                 */
                                     /*包裝-2                                 */
oqt173      varchar2(255),           /*包装-3                                 */
                                     /*包裝-3                                 */
oqt181      varchar2(255),           /*保险-1                                 */
                                     /*保險-1                                 */
oqt182      varchar2(255),           /*保险-2                                 */
                                     /*保險-2                                 */
oqt191      varchar2(255),           /*有效码-1                               */
                                     /*有效碼-1                               */
oqt192      varchar2(255),           /*有效码-2                               */
                                     /*有效碼-2                               */
oqt20       varchar2(40),            /*签名人                                 */
                                     /*簽名人                                 */
oqt21       varchar2(1),             /*状况码                                 */
                                     /*狀況碼:                 #no:6686       */
                                     /*0: 開立(Open)                          */
                                     /*1: 已核准                              */
                                     /*S: 送簽                                */
                                     /*R: 送簽退回                            */
                                     /*W: 抽單                                */
oqt22       varchar2(1),             /*签核否                                 */
                                     /*簽核否                  #no:6686       */
oqtconf     varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X)                          */
oqtacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oqtuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oqtgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oqtmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oqtdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oqt23       varchar2(20),            /*估价单号                               */
oqt055      varchar2(255),           /*客户地址-5                             */
oqtud01     varchar2(255),           /*自订字段-Textedit                      */
oqtud02     varchar2(40),            /*自订字段-文字                          */
oqtud03     varchar2(40),            /*自订字段-文字                          */
oqtud04     varchar2(40),            /*自订字段-文字                          */
oqtud05     varchar2(40),            /*自订字段-文字                          */
oqtud06     varchar2(40),            /*自订字段-文字                          */
oqtud07     number(15,3),            /*自订字段-数值                          */
oqtud08     number(15,3),            /*自订字段-数值                          */
oqtud09     number(15,3),            /*自订字段-数值                          */
oqtud10     number(10),              /*自订字段-整数                          */
oqtud11     number(10),              /*自订字段-整数                          */
oqtud12     number(10),              /*自订字段-整数                          */
oqtud13     date,                    /*自订字段-日期                          */
oqtud14     date,                    /*自订字段-日期                          */
oqtud15     date,                    /*自订字段-日期                          */
oqtplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqtlegal    varchar2(10) NOT NULL,   /*所属法人                               */
oqtoriu     varchar2(10),            /*资料建立者                             */
oqtorig     varchar2(10),            /*资料建立部门                           */
oqt24       varchar2(4),             /*税种                                   */
oqt25       varchar2(6),             /*收款条件                               */
oqt26       varchar2(10),            /*起运地                                 */
oqt27       varchar2(10)             /*到达地                                 */
);

alter table oqt_file add  constraint oqt_pk primary key  (oqt01) enable validate;
grant select on oqt_file to tiptopgp;
grant update on oqt_file to tiptopgp;
grant delete on oqt_file to tiptopgp;
grant insert on oqt_file to tiptopgp;
grant index on oqt_file to public;
grant select on oqt_file to ods;
