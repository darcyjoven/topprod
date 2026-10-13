/*
================================================================================
檔案代號:lnt_file
檔案名稱:合同资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lnt_file
(
lnt01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
lnt02       varchar2(20),            /*合同版本号                             */
lnt03       date,                    /*签订日期                               */
lnt04       varchar2(10),            /*商户号                                 */
lnt05       varchar2(1),             /*是否战盟                               */
lnt06       varchar2(20),            /*摊位号                                 */
lnt07       varchar2(10),            /*no use                                 */
lnt08       varchar2(10),            /*楼栋编号                               */
lnt09       varchar2(10),            /*楼层编号                               */
lnt10       number(20,6),            /*经营面积                               */
lnt11       number(20,6),            /*建筑面积                               */
lnt12       varchar2(10),            /*结算商户号                             */
lnt13       varchar2(1),             /*代收银返款方式                         */
lnt14       number(20,6),            /*按金额                                 */
lnt15       varchar2(10),            /*租金付款方式                           */
lnt16       varchar2(1) DEFAULT ' ' NOT NULL, /*租赁类型*/
lnt17       date,                    /*租赁期限起日                           */
lnt18       date,                    /*租赁期限止日                           */
lnt19       date,                    /*免租期限起日                           */
lnt20       date,                    /*免租期限止日                           */
lnt21       date,                    /*计租期限起日                           */
lnt22       date,                    /*计租期限起日                           */
lnt23       date,                    /*合同终止日期                           */
lnt24       varchar2(1),             /*是否签核                               */
lnt25       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
lnt26       varchar2(1) DEFAULT ' ' NOT NULL, /*确认码*/
lnt27       varchar2(10),            /*初审人                                 */
lnt28       date,                    /*初审日期                               */
lnt29       varchar2(50),            /*备注                                   */
lnt30       varchar2(10),            /*主品牌                                 */
lnt31       varchar2(10),            /*经营大类                               */
lnt32       varchar2(10),            /*经营中类                               */
lnt33       varchar2(10),            /*产品分类                               */
lnt34       varchar2(10),            /*合同中止人                             */
lnt35       varchar2(4),             /*税种                                   */
lnt36       number(9,4),             /*税率                                   */
lnt37       varchar2(1),             /*含税否                                 */
lnt38       varchar2(1) DEFAULT ' ' NOT NULL, /*展开类型*/
lnt39       number(5),               /*租赁期限                               */
lnt40       varchar2(20),            /*关联合同号                             */
lnt41       varchar2(20),            /*关联合同版本号                         */
lnt42       number(6,2),             /*增长率                                 */
lnt43       varchar2(1),             /*零头是是否已处理                       */
lnt44       varchar2(1),             /*保底按                                 */
lnt45       varchar2(1),             /*是否整月                               */
lnt46       date,                    /*终审日期                               */
lnt47       varchar2(10),            /*终审人                                 */
lnt48       varchar2(1),             /*状态                                   */
lnt49       varchar2(10),            /*原因码                                 */
lnt50       varchar2(1),             /*保底金额基准                           */
lnt51       number(5),               /*免租天数                               */
lnt52       date,                    /*末期起始日期                           */
lnt53       date,                    /*末期截止日期                           */
lntacti     varchar2(1),             /*资料有效码                             */
lntcrat     date,                    /*资料创建日                             */
lntdate     date,                    /*最近更改日                             */
lntgrup     varchar2(10),            /*资料所有群                             */
lntlegal    varchar2(10) NOT NULL,   /*所属法人                               */
lntmodu     varchar2(10),            /*资料更改人                             */
lntuser     varchar2(10),            /*资料所有者                             */
lntoriu     varchar2(10),            /*资料建立者                             */
lntorig     varchar2(10),            /*资料建立部门                           */
lntplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
lnt54       varchar2(1) DEFAULT ' ' NOT NULL, /*发票性质*/
lntpos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
lnt55       varchar2(10),            /*攤位用途                               */
lnt56       varchar2(200),           /*門牌號                                 */
lnt57       varchar2(1) DEFAULT ' ' NOT NULL, /*統一收銀否*/
lnt58       varchar2(1) DEFAULT ' ' NOT NULL, /*首零合并*/
lnt59       varchar2(1) DEFAULT ' ' NOT NULL, /*尾零合并*/
lnt60       varchar2(10),            /*区域编号                               */
lnt61       number(20,6),            /*測量面積                               */
lnt62       varchar2(10),            /*业务人员                               */
lnt63       varchar2(10),            /*部门                                   */
lnt64       number(20,6),            /*合同费用                               */
lnt65       number(20,6),            /*优惠金额                               */
lnt66       number(20,6),            /*质量保金额                             */
lnt67       number(20,6),            /*终止费用                               */
lnt68       number(20,6),            /*抹零金额                               */
lnt69       number(20,6),            /*合计                                   */
lnt70       varchar2(20),            /*预租协议                               */
lnt71       varchar2(20),            /*合同费用项方案                         */
lnt72       number(5),               /*人数                                   */
lnt73       varchar2(1) DEFAULT ' ' NOT NULL /*结案否*/
);

alter table lnt_file add  constraint lnt_pk primary key  (lnt01) enable validate;
grant select on lnt_file to tiptopgp;
grant update on lnt_file to tiptopgp;
grant delete on lnt_file to tiptopgp;
grant insert on lnt_file to tiptopgp;
grant index on lnt_file to public;
grant select on lnt_file to ods;
