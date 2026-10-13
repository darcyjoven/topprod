/*
================================================================================
檔案代號:cma_file
檔案名稱:LCM 料件价格单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table cma_file
(
cma01       varchar2(40) NOT NULL,   /*料件编号                               */
                                     /*料件編號                               */
cma02       date,                    /*计算基准日                             */
                                     /*計算基準日                             */
cma03       varchar2(1),             /*类型                                   */
                                     /*類別  0.原料  2.成品                   */
cma04       varchar2(1),             /*材料分类 A/B                           */
                                     /*材料分類 A/B     (註:B類表其他類)      */
cma05       varchar2(1),             /*取价类型                               */
                                     /*取價類別                               */
                                     /*I:進價   S:售價   B:Bom Rollup         */
                                     /*C:成本月平均單價                       */
cma11       number(20,6),            /*进货单价                               */
                                     /*進貨單價                               */
cma12       number(20,6),            /*销售单价                               */
                                     /*銷售單價                               */
cma13       number(20,6),            /*ROLLUP 单价                            */
                                     /*ROLLUP 單價                            */
cma14       number(20,6),            /*成本月平均单价                         */
                                     /*成本月平均單價                         */
cma15       number(15,3),            /*库存量                                 */
                                     /*庫存量 (不含除外倉之庫存量)            */
cma16       date,                    /*最近异动日                             */
                                     /*最近異動日                             */
cmauser     varchar2(10),            /*资料所有者                             */
                                     /*資料所有者                             */
cmagrup     varchar2(10),            /*资料所有部门                           */
                                     /*資料所有部門                           */
cmamodu     varchar2(10),            /*资料更改者                             */
                                     /*資料修改者                             */
cmadate     date,                    /*最近更改日                             */
                                     /*最近修改日                             */
cma021      number(5) DEFAULT '0' NOT NULL, /*年度*/
cma022      number(5) DEFAULT '0' NOT NULL, /*期别*/
cma24       varchar2(1),             /*净变现计算类别                         */
cma25       number(20,6),            /*净变现单价                             */
cma26       number(20,6),            /*净变现市价                             */
cma27       varchar2(20),            /*净变现参考单号                         */
cma28       number(5),               /*净变现参考项次                         */
cma29       varchar2(40),            /*净变现逆推成品料号                     */
cma30       varchar2(10),            /*净变现逆推顺序                         */
cma31       varchar2(1),             /*净变现销售费用率类别                   */
cma32       number(15,3),            /*净变现销售费用率                       */
cma271      date,                    /*净变现单据参考日期                     */
cma291      number(20,6),            /*逆推成品平均成本单价                   */
cma292      number(20,6),            /*逆推成品平均净变现单价                 */
cmaoriu     varchar2(10),            /*资料建立者                             */
cmaorig     varchar2(10),            /*资料建立部门                           */
cma07       varchar2(1) DEFAULT '1' NOT NULL, /*成本计算类型*/
cma08       varchar2(40) DEFAULT ' ' NOT NULL, /*类别代号(批次号/专案号/利润 */
cmalegal    varchar2(10) NOT NULL,   /*所属法人                               */
cma293      number(16,8)             /*逆推成品平均QPA                        */
);

alter table cma_file add  constraint cma_pk primary key  (cma01,cma021,cma022,cma07,cma08) enable validate;
grant select on cma_file to tiptopgp;
grant update on cma_file to tiptopgp;
grant delete on cma_file to tiptopgp;
grant insert on cma_file to tiptopgp;
grant index on cma_file to public;
grant select on cma_file to ods;
