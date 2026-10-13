/*
================================================================================
檔案代號:rto_file
檔案名稱:采购合约资料单头档
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table rto_file
(
rto01       varchar2(20) DEFAULT ' ' NOT NULL, /*合约编号*/
rto02       number(5) DEFAULT '0' NOT NULL, /*版本号*/
rto03       varchar2(10) DEFAULT ' ' NOT NULL, /*签订营运中心*/
rto04       varchar2(20),            /*文档编号                               */
rto05       varchar2(10),            /*供应商代码                             */
rto06       varchar2(1),             /*经营方式                               */
                                     /*Running Mode 1:Sell 2:Sell Goods On a Commission Basis (Cost) */
                                     /*3:Sell Goods On a Commission Basis (Deduction%) 4:Pool*/
rto07       varchar2(10),            /*付款方式                               */
rto08       date,                    /*生效日期                               */
rto09       date,                    /*终止日期                               */
rto10       date,                    /*签订日期                               */
rto11       date,                    /*废止日期                               */
rto12       number(5,2),             /*促销分摊比例%                          */
rto13       number(5,2),             /*会员卡分摊比例？                       */
rto14       number(5,2),             /*产品损耗供应商承担比例%                */
rto15       varchar2(20),            /*经营面积                               */
rto16       number(5),               /*三包期                                 */
rto17       varchar2(10),            /*签订人（供应商）                       */
rto18       varchar2(10),            /*签订人（内部）                         */
rto19       varchar2(80),            /*签约地点                               */
rto20       varchar2(255),           /*备注                                   */
rto900      varchar2(1),             /*状况码                                 */
                                     /*Status Code                            */
                                     /*0:Open 1:Confirmed 9:Void R:Transfer for Approval S:Rejected W:Withdraw*/
rtoacti     varchar2(1),             /*资料有效码                             */
rtocond     date,                    /*审核日期                               */
rtoconf     varchar2(1),             /*审核码                                 */
rtoconu     varchar2(10),            /*审核人员                               */
rtocrat     date,                    /*资料创建日                             */
rtodate     date,                    /*最近更改日                             */
rtodays     number(5),               /*签核完成天数                           */
rtogrup     varchar2(10),            /*资料所有部门                           */
rtolegal    varchar2(10) NOT NULL,   /*所属法人                               */
rtomksg     varchar2(1),             /*是否签核                               */
rtomodu     varchar2(10),            /*资料更改者                             */
rtoplant    varchar2(10) DEFAULT ' ' NOT NULL, /*所属营运中心*/
rtoprit     number(5),               /*签核优先等级                           */
rtosign     varchar2(4),             /*签核等级                               */
rtosmax     number(5),               /*应签核顺序                             */
rtosseq     number(5),               /*已签核顺序                             */
rtouser     varchar2(10),            /*资料所有者                             */
rtoorig     varchar2(10),            /*资料建立部门                           */
rtooriu     varchar2(10)             /*资料建立者                             */
);

alter table rto_file add  constraint rto_pk primary key  (rto01,rto02,rto03,rtoplant) enable validate;
grant select on rto_file to tiptopgp;
grant update on rto_file to tiptopgp;
grant delete on rto_file to tiptopgp;
grant insert on rto_file to tiptopgp;
grant index on rto_file to public;
grant select on rto_file to ods;
