/*
================================================================================
檔案代號:loa_file
檔案名稱:合同变更数据档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table loa_file
(
loa01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同编号*/
loa02       varchar2(20) DEFAULT ' ' NOT NULL, /*合同版本号*/
loa03       date,                    /*签订日期                               */
loa04       varchar2(10),            /*商户号                                 */
loa05       varchar2(1),             /*是否战盟                               */
loa06       varchar2(20),            /*摊位号                                 */
loa07       varchar2(10),            /*no use                                 */
loa08       varchar2(10),            /*楼栋编号                               */
loa09       varchar2(10),            /*楼层编号                               */
loa10       number(20,2),            /*经营面积                               */
loa11       number(20,2),            /*建筑面积                               */
loa12       varchar2(10),            /*结算商户号                             */
loa13       varchar2(1) DEFAULT ' ' NOT NULL, /*代收银返款方式*/
loa14       number(20,2),            /*按金额                                 */
loa15       varchar2(10),            /*租金付款方式                           */
loa16       varchar2(1) DEFAULT ' ' NOT NULL, /*租赁类型*/
loa17       date,                    /*租赁期限起日                           */
loa18       date,                    /*租赁期限止日                           */
loa19       date,                    /*免租期限起日                           */
loa20       date,                    /*免租期限止日                           */
loa21       date,                    /*计租期限起日                           */
loa22       date,                    /*计租期限起日                           */
loa23       date,                    /*变更发出日期                           */
loa24       varchar2(1),             /*是否签核                               */
loa25       varchar2(1) DEFAULT ' ' NOT NULL, /*签核状态*/
loa26       varchar2(1) DEFAULT ' ' NOT NULL, /*审核状态*/
loa27       varchar2(10),            /*初审人                                 */
loa28       date,                    /*初审日期                               */
loa29       varchar2(50),            /*备注                                   */
loa30       varchar2(10),            /*主品牌                                 */
loa31       varchar2(10),            /*No Use                                 */
loa32       varchar2(10),            /*No Use                                 */
loa33       varchar2(10),            /*产品分类                               */
loa34       varchar2(10),            /*变更发出人                             */
loa35       varchar2(4),             /*税种                                   */
loa36       number(9,4),             /*税率                                   */
loa37       varchar2(1),             /*含税否                                 */
loa38       varchar2(1),             /*展开类型                               */
loa39       number(5),               /*租赁期限                               */
loa40       varchar2(20),            /*关联合同号                             */
loa41       varchar2(20),            /*关联合同版本号                         */
loa42       number(6,2),             /*增长率                                 */
loa43       varchar2(1),             /*零头是是否已处理                       */
loa44       varchar2(1),             /*保底按                                 */
loa45       varchar2(1),             /*是否整月                               */
loa46       date,                    /*终审日期                               */
loa47       varchar2(10),            /*终审人                                 */
loa48       varchar2(1),             /*状态                                   */
loa49       varchar2(10),            /*原因码                                 */
loa50       varchar2(1),             /*保底金额基准                           */
loa51       number(5),               /*免租天数                               */
loa52       date,                    /*末期起始日期                           */
loa53       date,                    /*末期截止日期                           */
loaacti     varchar2(1),             /*资料有效码                             */
loacrat     date,                    /*资料创建日                             */
loadate     date,                    /*最近更改日                             */
loagrup     varchar2(10),            /*资料所有群                             */
loalegal    varchar2(10) NOT NULL,   /*所属法人                               */
loamodu     varchar2(10),            /*资料更改人                             */
loaplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
loauser     varchar2(10),            /*资料所有者                             */
loaoriu     varchar2(10),            /*资料建立者                             */
loaorig     varchar2(10),            /*资料建立部门                           */
loa54       varchar2(1) DEFAULT ' ' NOT NULL /*发票性质*/
);

alter table loa_file add  constraint loa_pk primary key  (loa01,loa02) enable validate;
grant select on loa_file to tiptopgp;
grant update on loa_file to tiptopgp;
grant delete on loa_file to tiptopgp;
grant insert on loa_file to tiptopgp;
grant index on loa_file to public;
grant select on loa_file to ods;
