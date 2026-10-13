/*
================================================================================
檔案代號:oep_file
檔案名稱:订单变更单单头
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table oep_file
(
oep01       varchar2(20) NOT NULL,   /*订单单号                               */
                                     /*訂單單號                               */
oep02       number(5) NOT NULL,      /*变更序号                               */
                                     /*變更序號  99/07/23 modify              */
oep04       date,                    /*变更日期                               */
                                     /*變更日期                               */
oep05       varchar2(1),             /*No Use                                 */
oep06       varchar2(10),            /*送货地址                               */
                                     /*送貨地址         #no.7214 alter        */
oep06b      varchar2(10),            /*变更送货地址                           */
                                     /*變更送貨地址     #no.7214 alter        */
oep07       varchar2(6),             /*原收款条件                             */
                                     /*原收款條件                             */
oep07b      varchar2(6),             /*变更收款条件                           */
                                     /*變更收款條件                           */
oep08       varchar2(4),             /*原币种                                 */
                                     /*原幣別                                 */
oep08b      varchar2(4),             /*变更币种                               */
                                     /*變更幣別                               */
oep09       varchar2(1),             /*状况码                                 */
                                     /*狀況碼:0.送簽中  1.已核淮    2.發出    */
                                     /*#6686  S.送簽    R.送簽退回  W.抽單    */
oepmksg     varchar2(1),             /*是否签核                               */
                                     /*是否簽核                               */
                                     /*本欄位可控制此張訂購變更單是否需簽核， */
                                     /*如需簽核為自動賦與簽核等級或自行設定簽核*/
                                     /*等級可在單據性質檔中控制，因此簽核的控制*/
                                     /*亦可利用單據性質檔來控制               */
oepsign     varchar2(4),             /*签核等级                               */
                                     /*簽核等級                               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepdays     number(5),               /*签核完成天数                           */
                                     /*簽核完成天數                           */
oepprit     number(5),               /*签核优先等级                           */
                                     /*簽核優先等級                           */
oepsseq     number(5),               /*已签核顺序                             */
                                     /*已簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購變更單已簽的人數               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepsmax     number(5),               /*应签核顺序                             */
                                     /*應簽核順序                             */
                                     /*系統自動維護                           */
                                     /*此張訂購變更單應簽的人數               */
                                     /*本系統將簽核作業獨立另一畫面顯示       */
                                     /*當此張訂購變更單需作簽核處理時才顯示   */
oepconf     varchar2(1),             /*审核否                                 */
                                     /*確認否(Y/N/X)                          */
oepacti     varchar2(1),             /*资料有效码                             */
                                     /*資料有效碼                             */
oepuser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
oepgrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
oepmodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
oepdate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
oep10       varchar2(6),             /*价格条件                               */
oep10b      varchar2(6),             /*变更价格条件                           */
oep11       varchar2(20),            /*交运方式                               */
oep11b      varchar2(20),            /*变更交运方式                           */
oepud01     varchar2(255),           /*自订字段-Textedit                      */
oepud02     varchar2(40),            /*自订字段-文字                          */
oepud03     varchar2(40),            /*自订字段-文字                          */
oepud04     varchar2(40),            /*自订字段-文字                          */
oepud05     varchar2(40),            /*自订字段-文字                          */
oepud06     varchar2(40),            /*自订字段-文字                          */
oepud07     number(15,3),            /*自订字段-数值                          */
oepud08     number(15,3),            /*自订字段-数值                          */
oepud09     number(15,3),            /*自订字段-数值                          */
oepud10     number(10),              /*自订字段-整数                          */
oepud11     number(10),              /*自订字段-整数                          */
oepud12     number(10),              /*自订字段-整数                          */
oepud13     date,                    /*自订字段-日期                          */
oepud14     date,                    /*自订字段-日期                          */
oepud15     date,                    /*自订字段-日期                          */
oepplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
oeplegal    varchar2(10) NOT NULL,   /*所属法人                               */
oeporiu     varchar2(10),            /*资料建立者                             */
oeporig     varchar2(10),            /*资料建立部门                           */
oep12       varchar2(10),            /*变更人员                               */
oep161      number(5),               /*原訂金比率                             */
oep161b     number(5),               /*变更订金比率                           */
oep162      number(5),               /*原出貨比率                             */
oep162b     number(5),               /*变更出货比率                           */
oep163      number(5),               /*原尾款比率                             */
oep163b     number(5),               /*变更尾款比率                           */
oep261      number(20,6),            /*原訂金金額                             */
oep261b     number(20,6),            /*变更订金金额                           */
oep262      number(20,6),            /*原出貨金額                             */
oep262b     number(20,6),            /*变更出货金额                           */
oep263      number(20,6),            /*原尾款金額                             */
oep263b     number(20,6),            /*变更尾款金额                           */
oep13       varchar2(10),            /*变更理由码                             */
oep14       varchar2(4),             /*變更前稅別                             */
oep14b      varchar2(4),             /*變更後稅別                             */
oep15       varchar2(30),            /*變更前客戶訂單編號                     */
oep15b      varchar2(30),            /*變更後客戶訂單編號                     */
oep16       varchar2(1) DEFAULT ' ' NOT NULL, /*订单性质*/
oep16b      varchar2(1) DEFAULT ' ' NOT NULL, /*变更订单性质*/
oep25       varchar2(10),            /*销售分类一                             */
oep25b      varchar2(10),            /*变更销售分类一                         */
oep26       varchar2(10),            /*销售分类二                             */
oep26b      varchar2(10),            /*变更销售分类二                         */
oep41       varchar2(10),            /*起运地                                 */
oep41b      varchar2(10),            /*变更起运地                             */
oepsendd    date,
oepsendt    varchar2(8),
oepsendu    varchar2(10)
);

alter table oep_file add  constraint oep_pk primary key  (oep01,oep02) enable validate;
grant select on oep_file to tiptopgp;
grant update on oep_file to tiptopgp;
grant delete on oep_file to tiptopgp;
grant insert on oep_file to tiptopgp;
grant index on oep_file to public;
grant select on oep_file to ods;
