/*
================================================================================
檔案代號:pmca_file
檔案名稱:供应商申请主档
檔案目的:
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table pmca_file
(
pmca00      varchar2(1),             /*申请类型(I:新增 U:更改)                */
pmcano      varchar2(80) NOT NULL,   /*申请单号                               */
pmca011     varchar2(10),            /*申请供应厂商编号                       */
pmca01      varchar2(10),            /*供应厂商编号                           */
pmca02      varchar2(10),            /*厂商分类                               */
pmca03      varchar2(40),            /*简称                                   */
pmca04      varchar2(10),            /*付款厂商编号                           */
pmca05      varchar2(1),             /*交易状况                               */
pmca06      varchar2(10),            /*区域编号                               */
pmca07      varchar2(10),            /*国家编号                               */
pmca081     varchar2(80),            /*全名 (第一行)                          */
pmca082     varchar2(80),            /*全名 (第二行)                          */
pmca091     varchar2(255),           /*地址(第一行)                           */
pmca092     varchar2(255),           /*地址(第二行)                           */
pmca093     varchar2(255),           /*地址(第三行)                           */
pmca094     varchar2(255),           /*地址(第四行)                           */
pmca095     varchar2(255),           /*地址(第五行)                           */
pmca10      varchar2(40),            /*电话号码                               */
pmca11      varchar2(40),            /*传真号码                               */
pmca12      varchar2(40),            /*电传号码                               */
pmca13      varchar2(1),             /*vat feature                            */
pmca14      varchar2(1),             /*资料性质                               */
pmca15      varchar2(10),            /*送货地址                               */
pmca16      varchar2(10),            /*帐单地址                               */
pmca17      varchar2(10),            /*付款方式                               */
pmca18      varchar2(1),             /*厂商评鉴/ABC 等级                      */
pmca19      varchar2(1),             /*厂商评鉴/交货等级                      */
pmca20      varchar2(1),             /*厂商评鉴/质量等级                      */
pmca21      varchar2(1),             /*厂商评鉴/价格等级                      */
pmca22      varchar2(4),             /*采购币种                               */
pmca23      varchar2(1),             /*是否签核                               */
pmca24      varchar2(20),            /*税号                                   */
pmca25      varchar2(2),             /*付款行事历别                           */
pmca26      varchar2(24),            /*应付帐款会计科目                       */
pmca27      varchar2(1),             /*票据寄领方式                           */
pmca28      number(5),               /*邮资/手续费                            */
pmca30      varchar2(1),             /*厂商性质                               */
pmca40      date,                    /*No Use                                 */
pmca41      date,                    /*No Use                                 */
pmca42      date,                    /*No Use                                 */
pmca43      date,                    /*No Use                                 */
pmca44      date,                    /*No Use                                 */
pmca45      number(13,2),            /*No Use                                 */
pmca46      number(13,2),            /*No Use                                 */
pmca47      varchar2(4),             /*惯用税种                               */
pmca48      varchar2(1),             /*付款票据是否禁止背书                   */
pmca49      varchar2(20),            /*惯用价格条件                           */
pmca50      number(5),               /*现金票据到期日为每月的第几             */
pmca51      number(5),               /*远期票据到期日为每月的第几             */
pmca52      varchar2(255),           /*发票/折让单地                          */
pmca53      varchar2(255),           /*寄票地                                 */
pmca54      varchar2(10),            /*惯用佣金编号                           */
pmca55      varchar2(20),            /*汇款银行编号                           */
pmca56      varchar2(30),            /*银行帐号                               */
pmca901     varchar2(10),            /*出货厂商                               */
pmca902     varchar2(1),             /*是否缴交切结书                         */
pmca903     varchar2(1),             /*是否为关系人                           */
pmca904     varchar2(10),            /*邮递区号                               */
pmca905     varchar2(1),             /*检验水准                               */
pmca906     varchar2(1),             /*检验程度                               */
pmca907     varchar2(1),             /*级数                                   */
pmca908     varchar2(10),            /*地区别                                 */
pmca909     varchar2(30),            /*No Use                                 */
pmca910     varchar2(30),            /*No Use                                 */
pmca911     varchar2(1),             /*惯用语言别                             */
pmcaacti    varchar2(1),             /*资料有效码                             */
pmcauser    varchar2(10),            /*资料所有者                             */
pmcagrup    varchar2(10),            /*资料所有部门                           */
pmcamodu    varchar2(10),            /*资料更改者                             */
pmcadate    date,                    /*最近更改日                             */
pmcaud01    varchar2(255),           /*自订字段                               */
pmcaud02    varchar2(40),            /*自订字段                               */
pmcaud03    varchar2(40),            /*自订字段                               */
pmcaud04    varchar2(40),            /*自订字段                               */
pmcaud05    varchar2(40),            /*自订字段                               */
pmcaud06    varchar2(40),            /*自订字段                               */
pmcaud07    number(15,3),            /*自订字段                               */
pmcaud08    number(15,3),            /*自订字段                               */
pmcaud09    number(15,3),            /*自订字段                               */
pmcaud10    number(10),              /*自订字段                               */
pmcaud11    number(10),              /*自订字段                               */
pmcaud12    number(10),              /*自订字段                               */
pmcaud13    date,                    /*自订字段                               */
pmcaud14    date,                    /*自订字段                               */
pmcaud15    date,                    /*自订字段                               */
pmcaoriu    varchar2(10),            /*资料建立者                             */
pmcaorig    varchar2(10),            /*资料建立部门                           */
pmca914     varchar2(1) DEFAULT 'N' NOT NULL, /*VMI管理否*/
pmca915     varchar2(10),            /*VMI库存仓库                            */
pmca916     varchar2(10),            /*VMI库存储位                            */
pmca917     varchar2(10),            /*VMI结算仓库                            */
pmca918     varchar2(10),            /*VMI结算储位                            */
pmca919     varchar2(5),             /*VMI结算收货单别                        */
pmca920     varchar2(5),             /*VMI结算入库单别                        */
pmca921     varchar2(5),             /*VMI结算退货单别                        */
pmca922     varchar2(5),             /*VMI库存杂发单别                        */
pmca923     varchar2(5),             /*VMI库存杂收单别                        */
pmca281     varchar2(1)
);

alter table pmca_file add  constraint pmca_pk primary key  (pmcano) enable validate;
grant select on pmca_file to tiptopgp;
grant update on pmca_file to tiptopgp;
grant delete on pmca_file to tiptopgp;
grant insert on pmca_file to tiptopgp;
grant index on pmca_file to public;
grant select on pmca_file to ods;
