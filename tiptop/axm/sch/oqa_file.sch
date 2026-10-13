/*
================================================================================
檔案代號:oqa_file
檔案名稱:估价单单头资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oqa_file
(
oqa01       varchar2(20) NOT NULL,   /*估价单号                               */
                                     /*估價單號                               */
oqa02       date,                    /*日期                                   */
oqa03       varchar2(40),            /*产品编号                               */
                                     /*產品編號                               */
oqa031      varchar2(120),           /*品名                                   */
oqa032      varchar2(120),           /*规格                                   */
                                     /*規格                                   */
oqa04       varchar2(255),           /*内容说明1                              */
                                     /*內容說明1                              */
oqa041      varchar2(255),           /*内容说明2                              */
                                     /*內容說明2                              */
oqa042      varchar2(255),           /*内容说明3                              */
                                     /*內容說明3                              */
oqa05       varchar2(10),            /*部门编号                               */
                                     /*部門編號                               */
oqa06       varchar2(10),            /*客户编号                               */
                                     /*客戶編號                               */
oqa07       varchar2(10),            /*业务员编号                             */
                                     /*業務員編號                             */
oqa08       varchar2(4),             /*估价币种                               */
                                     /*估價幣別                               */
oqa09       number(20,10),           /*汇率                                   */
                                     /*匯率                                   */
oqa10       number(15,3),            /*数量                                   */
                                     /*數量                                   */
oqa11       date,                    /*单价参考起始日期                       */
                                     /*單價參考起始日期                       */
oqa12       date,                    /*有效期间                               */
                                     /*有效期間                               */
oqa13       number(20,6),            /*材料估价金额                           */
                                     /*材料估價金額                           */
oqa14       number(20,6),            /*人工估价金额                           */
                                     /*人工估價金額                           */
oqa15       number(20,6),            /*制费估价金额                           */
                                     /*製費估價金額                           */
oqa16       number(20,6),            /*其他费用金额                           */
                                     /*其他費用金額                           */
oqa17       number(20,6),            /*总金额                                 */
                                     /*總金額                                 */
oqaconf     varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X)                          */
oqaacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oqauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oqagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oqamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oqadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oqaud01     varchar2(255),           /*自订字段-Textedit                      */
oqaud02     varchar2(40),            /*自订字段-文字                          */
oqaud03     varchar2(40),            /*自订字段-文字                          */
oqaud04     varchar2(40),            /*自订字段-文字                          */
oqaud05     varchar2(40),            /*自订字段-文字                          */
oqaud06     varchar2(40),            /*自订字段-文字                          */
oqaud07     number(15,3),            /*自订字段-数值                          */
oqaud08     number(15,3),            /*自订字段-数值                          */
oqaud09     number(15,3),            /*自订字段-数值                          */
oqaud10     number(10),              /*自订字段-整数                          */
oqaud11     number(10),              /*自订字段-整数                          */
oqaud12     number(10),              /*自订字段-整数                          */
oqaud13     date,                    /*自订字段-日期                          */
oqaud14     date,                    /*自订字段-日期                          */
oqaud15     date,                    /*自订字段-日期                          */
oqaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oqalegal    varchar2(10) NOT NULL,   /*所属法人                               */
oqaoriu     varchar2(10),            /*资料建立者                             */
oqaorig     varchar2(10),            /*资料建立部门                           */
oqa18       varchar2(20)             /*特性代码                               */
);

alter table oqa_file add  constraint oqa_pk primary key  (oqa01) enable validate;
grant select on oqa_file to tiptopgp;
grant update on oqa_file to tiptopgp;
grant delete on oqa_file to tiptopgp;
grant insert on oqa_file to tiptopgp;
grant index on oqa_file to public;
grant select on oqa_file to ods;
