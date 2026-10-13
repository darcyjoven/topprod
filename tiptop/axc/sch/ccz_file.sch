/*
================================================================================
檔案代號:ccz_file
檔案名稱:成本会计系统参数
檔案目的:
上游檔案:
下游檔案:
檔案類型:P
多語系檔案:N
============.========================.==========================================
*/
create table ccz_file
(
ccz00       varchar2(1) NOT NULL,    /*KEY VALUE(0)                           */
ccz01       number(5),               /*现行成本结算年度                       */
                                     /*現行成本結算年度                       */
ccz02       number(5),               /*现行成本结算月份                       */
                                     /*現行成本結算月份                       */
ccz03       varchar2(1),             /*采购入库单价来源                       */
                                     /*採購入庫單價來源:1.標準成本 2.實際成本 */
ccz04       varchar2(1),             /*工单入库单价来源:1.标准成本            */
                                     /*工單入庫單價來源:1.標準成本 2.實際成本 */
ccz05       varchar2(1),             /*工单投入工时录入方式:                  */
                                     /*工單投入工時輸入方式:                  */
                                     /*  1.依實際輸入(人工製費期末結存套數須由*/
                                     /*               人為個別設定各工單約當量)*/
                                     /*  2.依投入套數(人工製費期末結存套數=   */
                                     /*               投入套數-產出套數)      */
                                     /*  3.依產出套數(人工製費期末無結存)     */
ccz06       varchar2(1),             /*人工制费工时录入方式                   */
                                     /*人工製費工時輸入方式                   */
                                     /*  1.區分年月                           */
                                     /*  2.區分年月成本中心                   */
                                     /*  3.區分年月作業編號                   */
                                     /*    (依製程中的作業編號(ecm04)計算)    */
                                     /*  4.區分年月工作中心                   */
                                     /*    (依製程中的工作中心(ecm06)計算)    */
ccz07       varchar2(1),             /*存货科目取得方式                       */
                                     /*存貨科目取得方式(1/2/3)                */
                                     /*  1.取自料件主檔                       */
                                     /*  2.取自料件分群檔                     */
                                     /*  3.取自倉庫檔                         */
                                     /*  4.取自倉庫儲位檔                     */
ccz08       varchar2(1),             /*杂项发料异动取价方式                   */
ccz09       varchar2(1),             /*工单结案在制转出差异是否转             */
ccz10       varchar2(1),             /*人工/制费撷取方式 1.人工录入           */
ccz11       varchar2(10),            /*总帐会计系统所在营运中心编             */
                                     /*Plant # where AGL is                   */
ccz12       varchar2(5),             /*总帐管理系统使用帐套编号               */
                                     /*總帳管理系統使用帳別編號               */
ccz13       varchar2(1),             /*联产品分摊基准方式(1/2)                */
                                     /*聯產品分攤基準方式(1/2)         No.7268*/
                                     /*  1.依工完比例                         */
                                     /*  2.依聯產品分配率                     */
cczuser     varchar2(10),            /*No Use                                 */
cczgrup     varchar2(10),            /*No Use                                 */
cczmodu     varchar2(10),            /*No Use                                 */
cczdate     varchar2(10),            /*No Use                                 */
ccz14       varchar2(24),            /*人工投入科目                           */
ccz15       varchar2(24),            /*制费投入科目                           */
ccz16       varchar2(24),            /*加工费科目                             */
ccz17       varchar2(24),            /*在制品科目                             */
ccz18       varchar2(24),            /*工单结案在制转出差异科目               */
ccz19       varchar2(24),            /*拆件式结案转出差异科目                 */
ccz20       varchar2(24),            /*人工分摊尾差科目                       */
ccz21       varchar2(24),            /*制费分摊尾差科目                       */
ccz22       varchar2(24),            /*其他分摊尾差科目                       */
ccz23       varchar2(24),            /*分摊尾差指定部门                       */
ccz24       varchar2(24),            /*盘亏科目                               */
ccz25       varchar2(24),            /*盘盈科目                               */
ccz26       number(5),               /*成本计算库存金额小数位数               */
ccz121      varchar2(5),             /*总帐管理系统使用帐套编号二             */
ccz141      varchar2(24),            /*人工投入科目二                         */
ccz151      varchar2(24),            /*制費投入科目二                         */
ccz161      varchar2(24),            /*加工费科目二                           */
ccz171      varchar2(24),            /*在制品科目二                           */
ccz181      varchar2(24),            /*工单结案在制转出差异科目二             */
ccz191      varchar2(24),            /*拆件式结案转出差异科目二               */
ccz201      varchar2(24),            /*人工分摊尾差科目二                     */
ccz211      varchar2(24),            /*制費分攤尾差科目二                     */
ccz221      varchar2(24),            /*其他分摊尾差科目二                     */
ccz241      varchar2(24),            /*盘亏科目二                             */
ccz251      varchar2(24),            /*盘盈科目二                             */
ccz27       number(5),               /*成本报表数量印出小数位数               */
ccz28       varchar2(1) DEFAULT '1' NOT NULL, /*成本计算方式*/
ccz29       varchar2(24),            /*闲置制费转销货成本科目                 */
ccz291      varchar2(24),            /*闲置制费转销货成本科目二               */
ccz231      varchar2(24),            /*分摊尾差指定部门二                     */
ccz31       varchar2(1) DEFAULT '1' NOT NULL, /*销退,退料是否影响成本*/
ccz32       varchar2(1) DEFAULT '1' NOT NULL, /*销退成本的来源*/
ccz33       varchar2(24),            /*制费二投入科目                         */
ccz331      varchar2(24),            /*制费二投入科目二                       */
ccz34       varchar2(24),            /*制费三投入科目                         */
ccz341      varchar2(24),            /*制费三投入科目二                       */
ccz35       varchar2(24),            /*制费四投入科目                         */
ccz351      varchar2(24),            /*制费四投入科目二                       */
ccz36       varchar2(24),            /*制费五投入科目                         */
ccz361      varchar2(24),            /*制费五投入科目二                       */
ccz37       varchar2(24),            /*制费二分摊尾差科目                     */
ccz371      varchar2(24),            /*制费二分摊尾差科目二                   */
ccz38       varchar2(24),            /*制费三分摊尾差科目                     */
ccz381      varchar2(24),            /*制费三分摊尾差科目二                   */
ccz39       varchar2(24),            /*制费四分摊尾差科目                     */
ccz391      varchar2(24),            /*制费四分摊尾差科目二                   */
ccz40       varchar2(24),            /*制费五分摊尾差科目                     */
ccz401      varchar2(24),            /*制费五分摊尾差科目二                   */
cczorig     varchar2(10),            /*资料建立部门                           */
cczoriu     varchar2(10),            /*资料建立者                             */
cczud01     varchar2(255),           /*自订字段                               */
cczud02     varchar2(40),            /*自订字段                               */
cczud03     varchar2(40),            /*自订字段                               */
cczud04     varchar2(40),            /*自订字段                               */
cczud05     varchar2(40),            /*自订字段                               */
cczud06     varchar2(255),           /*自订字段                               */
cczud07     number(15,3),            /*自订字段                               */
cczud08     number(15,3),            /*自订字段                               */
cczud09     number(15,3),            /*自订字段                               */
cczud10     number(10),              /*自订字段                               */
cczud11     number(10),              /*自订字段                               */
cczud12     number(10),              /*自订字段                               */
cczud13     date,                    /*自订字段                               */
cczud14     date,                    /*自订字段                               */
cczud15     date,                    /*自订字段                               */
ccz45       varchar2(1) DEFAULT ' ' NOT NULL, /*當站報廢轉出方式*/
ccz43       varchar2(1) DEFAULT ' ' NOT NULL, /*是否走委外加工物资*/
ccz44       varchar2(24),            /*委外加工物资科目                       */
ccz441      varchar2(24),            /*委外加工物资科目二                     */
ccz42       varchar2(1) DEFAULT ' '  /*no use                                 */
);

alter table ccz_file add  constraint ccz_pk primary key  (ccz00) enable validate;
grant select on ccz_file to tiptopgp;
grant update on ccz_file to tiptopgp;
grant delete on ccz_file to tiptopgp;
grant insert on ccz_file to tiptopgp;
grant index on ccz_file to public;
grant select on ccz_file to ods;
