/*
================================================================================
檔案代號:fap_file
檔案名稱:固定资产历史资料档
檔案目的:
上游檔案:
下游檔案:
檔案類型:S
多語系檔案:N
============.========================.==========================================
*/
create table fap_file
(
fap01       varchar2(10),            /*序号                                   */
fap02       varchar2(10) NOT NULL,   /*财产编号                               */
fap021      varchar2(4) NOT NULL,    /*财产附号                               */
fap03       varchar2(1) NOT NULL,    /*异动编号                               */
fap04       date NOT NULL,           /*异动日期                               */
fap05       varchar2(1),             /*资产状态                               */
fap06       varchar2(1),             /*折旧方法                               */
fap07       number(5),               /*未使用年限                             */
fap08       number(20,6),            /*预估残值                               */
fap09       number(20,6),            /*本币成本                               */
fap10       number(20,6),            /*调整成本                               */
fap101      number(20,6),            /*未折减额                               */
fap11       number(20,6),            /*累计折旧                               */
fap12       varchar2(24),            /*资产科目                               */
fap13       varchar2(24),            /*累折科目                               */
fap14       varchar2(24),            /*折旧科目                               */
fap15       varchar2(1),             /*分摊方式                               */
fap16       varchar2(10),            /*分摊部门编号                           */
fap17       varchar2(10),            /*保管部门                               */
fap18       varchar2(10),            /*保管人员                               */
fap19       varchar2(10),            /*存放位置                               */
fap20       number(5),               /*数量                                   */
fap201      number(5),               /*在外数量                               */
fap21       number(5),               /*销帐数量                               */
fap22       number(20,6),            /*销帐成本(异动前-历史资料)              */
fap23       number(20,6),            /*销帐累折                               */
fap24       varchar2(1),             /*折毕再提否                             */
fap25       number(20,6),            /*再提金额                               */
fap26       number(5),               /*折毕再提年限                           */
fap30       varchar2(1),             /*税签折旧方法                           */
fap31       number(5),               /*税签未用年限                           */
fap32       number(20,6),            /*税签预估残值                           */
fap33       number(20,6),            /*税签成本                               */
fap34       number(20,6),            /*税签调整成本                           */
fap341      number(20,6),            /*税签未折减额                           */
fap35       number(20,6),            /*税签累计折旧                           */
fap36       number(20,6),            /*税签销帐成本                           */
fap37       number(20,6),            /*税签销帐累折                           */
fap38       varchar2(1),             /*税签折毕再提否                         */
fap39       number(20,6),            /*税签再提金额                           */
fap40       number(5),               /*税签折毕再提年限                       */
fap41       date,                    /*最近异动日期                           */
fap42       varchar2(1),             /*税签资产状态                           */
fap43       varchar2(20),            /*No Use                                 */
fap44       varchar2(1),             /*资产停用否                             */
fap45       number(20,6),            /*No Use                                 */
fap50       varchar2(20) NOT NULL,   /*异动单号                               */
fap501      number(5),               /*异动序号                               */
fap51       varchar2(1),             /*折旧方法                               */
fap52       number(5),               /*未用年限                               */
fap53       number(20,6),            /*预估残值                               */
fap54       number(20,6),            /*调整成本                               */
fap55       number(20,6),            /*累计折旧                               */
fap56       number(20,6),            /*销帐成本(异动值)                       */
fap57       number(20,6),            /*销帐累折                               */
fap58       varchar2(24),            /*资产科目                               */
fap59       varchar2(24),            /*累折科目                               */
fap60       varchar2(24),            /*折旧科目                               */
fap61       varchar2(1),             /*分摊方式                               */
fap62       varchar2(10),            /*分摊部门                               */
fap63       varchar2(20),            /*保管部门                               */
fap64       varchar2(10),            /*保管人员                               */
fap65       varchar2(20),            /*存放位置 (外送时存外送地点)            */
fap66       number(5),               /*数量                                   */
fap661      number(20,6),            /*本币成本                               */
fap67       number(5),               /*销帐数量                               */
fap68       varchar2(1),             /*税签折旧方法                           */
fap69       number(5),               /*税签未用月数                           */
fap70       number(20,6),            /*税签预估残值                           */
fap71       number(20,6),            /*税签调整成本                           */
fap711      number(20,6),            /*税签本币成本                           */
fap72       number(20,6),            /*税签累计折旧                           */
fap73       number(20,6),            /*税签销帐成本                           */
fap74       number(20,6),            /*税签销帐累折                           */
fap75       varchar2(10),            /*资本化后财产编号                       */
fap76       varchar2(4),             /*资本化后财产附号                       */
fap77       varchar2(1),             /*资产状态                               */
fap78       number(20,6),            /*税签减值准备                           */
                                     /*Depreciation-Tax Devalue Preparative(fap80)     #No:A099*/
fap79       number(20,6),            /*税签销帐减值                           */
                                     /*Depreciation-Tax Charge off Devalue(fap45) #No:A099*/
fap80       number(20,6),            /*已计提减值准备金额                     */
                                     /*Listed  Devalue Preparative Amount #No:A099*/
fap121      varchar2(24),            /*资产科目二                             */
fap131      varchar2(24),            /*累折科目二                             */
fap141      varchar2(24),            /*折旧科目二                             */
fap581      varchar2(24),            /*资产科目二                             */
fap591      varchar2(24),            /*累折科目二                             */
fap601      varchar2(24),            /*折旧科目二                             */
faplegal    varchar2(10) NOT NULL,   /*所属法人                               */
fap052      varchar2(1) DEFAULT '0' NOT NULL, /*资产状态(财签二)*/
fap062      varchar2(1) DEFAULT '1' NOT NULL, /*折旧方法(财签二)*/
fap072      number(5),               /*未使用年限(财签二)                     */
fap082      number(20,6) DEFAULT '0' NOT NULL, /*预估残值(财签二)*/
fap092      number(20,6) DEFAULT '0' NOT NULL, /*本币成本(财签二)*/
fap1012     number(20,6) DEFAULT '0' NOT NULL, /*未折减额(财签二)*/
fap112      number(20,6) DEFAULT '0' NOT NULL, /*累计折旧(财签二)*/
fap152      varchar2(1) DEFAULT '1' NOT NULL, /*分摊方式(财签二)*/
fap162      varchar2(10),            /*分摊部门编号(财签二)                   */
fap212      number(5),               /*销账数量(财签二)                       */
fap222      number(20,6) DEFAULT '0' NOT NULL, /*销账成本(异动前-历史资料)(财*/
fap232      number(20,6) DEFAULT '0' NOT NULL, /*销账累折(财签二)*/
fap242      varchar2(1) DEFAULT 'N' NOT NULL, /*折毕再提否(财签二)*/
fap252      number(20,6) DEFAULT '0' NOT NULL, /*再提金额(财签二)*/
fap262      number(5),               /*折毕再提年限(财签二)                   */
fap512      varchar2(1) DEFAULT '1' NOT NULL, /*折旧方法(财签二)*/
fap522      number(5),               /*未用年限(财签二)                       */
fap532      number(20,6) DEFAULT '0' NOT NULL, /*预估残值(财签二)*/
fap552      number(20,6) DEFAULT '0' NOT NULL, /*累计折旧(财签二)*/
fap562      number(20,6) DEFAULT '0' NOT NULL, /*销账成本(异动值)(财签二)*/
fap572      number(20,6) DEFAULT '0' NOT NULL, /*销账累折(财签二)*/
fap612      varchar2(1) DEFAULT '1' NOT NULL, /*分摊方式(财签二)*/
fap622      varchar2(10),            /*分摊部门(财签二)                       */
fap6612     number(20,6) DEFAULT '0' NOT NULL, /*本币成本(财签二)*/
fap672      number(5),               /*销账数量(财签二)                       */
fap772      varchar2(1) DEFAULT '0' NOT NULL, /*资产状态(财签二)*/
fap802      number(20,6) DEFAULT '0' NOT NULL, /*已计提减值准备金额(财签二)*/
fap542      number(20,6) DEFAULT '0' NOT NULL, /*调整成本(财签二)*/
fap103      number(20,6) DEFAULT '0' NOT NULL, /*调整成本(财签二)*/
fap042      date,                    /*异动日期(财签二)                       */
fap27       varchar2(10),            /*异动前族群编号                         */
fap81       varchar2(10),            /*异动后族群编号                         */
fap28       varchar2(10),            /*异动前资产类别                         */
fap82       varchar2(10),            /*异动后资产类别                         */
fap83       number(5),               /*异动前耐用年限(财二)                   */
fap832      number(5),               /*异动前耐用年限(财二)                   */
fap84       number(5),               /*异动前耐用年限(税签)                   */
fap93       number(5),               /*异动后耐用年限(财签)                   */
fap932      number(5),               /*异动后耐用年限(财二)                   */
fap94       number(5)                /*异动后耐用年限(税签)                   */
);

alter table fap_file add  constraint fap_pk primary key  (fap02,fap021,fap03,fap04,fap50) enable validate;
grant select on fap_file to tiptopgp;
grant update on fap_file to tiptopgp;
grant delete on fap_file to tiptopgp;
grant insert on fap_file to tiptopgp;
grant index on fap_file to public;
grant select on fap_file to ods;
