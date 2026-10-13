/*
================================================================================
檔案代號:tqa_file
檔案名稱:基础代码档
檔案目的: 纪录公司内部所有组织机构的信息,用于业绩归属和费用归属
上游檔案:
下游檔案:
檔案類型:B
多語系檔案:N
============.========================.==========================================
*/
create table tqa_file
(
tqa01       varchar2(10) NOT NULL,   /*代码                                   */
tqa02       varchar2(80),            /*代码描述                               */
tqa03       varchar2(10) NOT NULL,   /*代码类型                               */
                                     /*Category                               */
                                     /*1:Item Type 2:Item Brand 3:Series 4:Item Model 5:Spec 6:Property */
                                     /*7:Expenses Payment Mode 8:Expenses Payment Object 9:Balance Type */
                                     /*10:System Code 11:System Area Code 12:Customer Type 13:Bonded Type */
                                     /*14:Inst Type 15:Promotion Type 16:Exhibit Type 17:Period Type */
                                     /*18:Promotion Category 19:Channel Description 20:Crediter's Description*/
tqaacti     varchar2(1),             /*资料有效码                             */
tqauser     varchar2(10),            /*资料所有者                             */
tqagrup     varchar2(10),            /*资料所有部门                           */
tqamodu     varchar2(10),            /*资料更改者                             */
tqadate     date,                    /*最近更改日                             */
tqa04       number(5),               /*层级                                   */
tqaorig     varchar2(10),            /*资料建立部门                           */
tqaoriu     varchar2(10),            /*资料建立者                             */
tqa05       number(20,6) DEFAULT '0' NOT NULL, /*层级*/
tqa06       number(20,6) DEFAULT '0' NOT NULL, /*结束价格*/
tqapos      varchar2(1) DEFAULT '1' NOT NULL, /*已传POS否*/
tqa07       varchar2(10),            /*上级品牌编号                           */
tqa08       varchar2(10),            /*厂家编号                               */
tqa09       varchar2(10)             /*品牌等級                               */
);

alter table tqa_file add  constraint tqa_pk primary key  (tqa01,tqa03) enable validate;
grant select on tqa_file to tiptopgp;
grant update on tqa_file to tiptopgp;
grant delete on tqa_file to tiptopgp;
grant insert on tqa_file to tiptopgp;
grant index on tqa_file to public;
grant select on tqa_file to ods;
