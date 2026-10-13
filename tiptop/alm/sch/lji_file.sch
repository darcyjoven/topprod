/*
================================================================================
檔案代號:lji_file
檔案名稱:合同变更单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table lji_file
(
lji01       varchar2(20) DEFAULT ' ' NOT NULL, /*合同变更单号*/
lji02       varchar2(1) DEFAULT ' ' NOT NULL, /*变更类型*/
lji03       varchar2(20),            /*变更申请单号                           */
lji04       varchar2(20),            /*合约单号                               */
lji05       number(5),               /*合同版本号                             */
lji06       date,                    /*签订日期                               */
lji07       varchar2(10),            /*商户编号                               */
lji08       varchar2(20),            /*摊位编号                               */
lji09       varchar2(10),            /*攤位用途                               */
lji10       varchar2(200),           /*門牌號                                 */
lji11       varchar2(10),            /*楼栋编号                               */
lji12       varchar2(10),            /*楼层编号                               */
lji13       varchar2(10),            /*区域编号                               */
lji14       number(20,6),            /*建筑面积                               */
lji141      number(20,6),            /*新建筑面积                             */
lji15       number(20,6),            /*測量面積                               */
lji151      number(20,6),            /*新测量面积                             */
lji16       number(20,6),            /*经营面积                               */
lji161      number(20,6),            /*新经营面积                             */
lji17       varchar2(1) DEFAULT ' ' NOT NULL, /*租赁类型*/
lji18       varchar2(1) DEFAULT ' ' NOT NULL, /*发票性质*/
lji19       varchar2(1) DEFAULT ' ' NOT NULL, /*账期按自然月*/
lji20       varchar2(1) DEFAULT ' ' NOT NULL, /*首零合并*/
lji21       varchar2(1) DEFAULT ' ' NOT NULL, /*尾零合并*/
lji22       date,                    /*租赁期限起日                           */
lji23       date,                    /*租赁期限止日                           */
lji24       number(5),               /*免租天数                               */
lji25       date,                    /*计租期限起日                           */
lji26       date,                    /*计租期限止日                           */
lji27       date,                    /*延期截止日                             */
lji28       date,                    /*面积更改日                             */
lji29       date,                    /*终止清算日                             */
lji30       varchar2(10),            /*业务人员                               */
lji31       varchar2(10),            /*部门                                   */
lji32       number(20,6),            /*合同费用                               */
lji33       number(20,6),            /*优惠金额                               */
lji34       number(20,6),            /*质保金                                 */
lji35       number(20,6),            /*终止费用                               */
lji36       number(20,6),            /*抹零金额                               */
lji37       number(20,6),            /*合计                                   */
lji38       varchar2(10),            /*主品牌                                 */
lji381      varchar2(10),            /*新主品牌                               */
lji39       varchar2(20),            /*预租协议号                             */
lji40       varchar2(20),            /*合同费用项方案                         */
lji41       number(5),               /*人数                                   */
lji42       varchar2(255),           /*备注                                   */
lji43       varchar2(1) DEFAULT ' ' NOT NULL, /*状态*/
lji44       varchar2(10),            /*初审人                                 */
lji45       date,                    /*初审日期                               */
lji46       varchar2(10),            /*终审人                                 */
lji47       date,                    /*终审日期                               */
lji48       varchar2(1) DEFAULT ' ' NOT NULL, /*统一收银*/
lji49       varchar2(10),            /*经营大类                               */
lji50       varchar2(10),            /*经营中类                               */
lji51       varchar2(10),            /*经营小类                               */
lji52       varchar2(4),             /*税种                                   */
lji53       number(9,4),             /*税率                                   */
lji54       varchar2(1) DEFAULT ' ' NOT NULL, /*含税否*/
ljiacti     varchar2(1) DEFAULT ' ' NOT NULL, /*资料有效码*/
ljicrat     date,                    /*资料创建日                             */
ljidate     date,                    /*最近更改日                             */
ljigrup     varchar2(10),            /*资料所有部门                           */
ljilegal    varchar2(10) DEFAULT ' ' NOT NULL, /*法人*/
ljimksg     varchar2(1) DEFAULT ' ' NOT NULL, /*是否签核*/
ljimodu     varchar2(10),            /*资料更改者                             */
ljiorig     varchar2(10),            /*资料建立部门                           */
ljioriu     varchar2(10),            /*资料建立者                             */
ljiplant    varchar2(10) DEFAULT ' ' NOT NULL, /*门店编号*/
ljiuser     varchar2(10),            /*资料所有者                             */
ljiconf     varchar2(1) DEFAULT ' ' NOT NULL /*确认码*/
);

alter table lji_file add  constraint lji_pk primary key  (lji01) enable validate;
grant select on lji_file to tiptopgp;
grant update on lji_file to tiptopgp;
grant delete on lji_file to tiptopgp;
grant insert on lji_file to tiptopgp;
grant index on lji_file to public;
grant select on lji_file to ods;
