/*
================================================================================
檔案代號:coe_file
檔案名稱:合同进口料件基本资料
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table coe_file
(
coe01       varchar2(20) NOT NULL,   /*申请编号                               */
coe02       number(5) NOT NULL,      /*序号                                   */
coe03       varchar2(40),            /*商品编号                               */
coe04       varchar2(10),            /*海关编号                               */
coe05       number(15,3),            /*申请数量                               */
coe051      number(15,3),            /*合同转入                               */
coe06       varchar2(4),             /*单位                                   */
coe07       number(20,6),            /*单价                                   */
coe08       number(20,6),            /*金额                                   */
coe09       number(15,3),            /*结转进口数量                           */
coe091      number(15,3),            /*结转耗用                               */
coe10       number(15,3),            /*加签数量                               */
coe101      number(15,3),            /*转厂进口                               */
coe102      number(15,3),            /*转厂耗用                               */
coe103      number(15,3),            /*退港原料或废料进口                     */
coe104      number(15,3),            /*退港原料或废料出口                     */
coe105      number(15,3),            /*报废数量                               */
coe106      number(15,3),            /*内销耗用                               */
coe11       varchar2(10),            /*产地                                   */
coe12       varchar2(10),            /*征免性质                               */
coe107      number(15,3),            /*内购数量                               */
coe108      number(15,3),            /*国内采购数量                           */
coe109      number(15,3),            /*转厂退货数量                           */
coeud01     varchar2(255),           /*自订字段-Textedit                      */
coeud02     varchar2(40),            /*自订字段-文字                          */
coeud03     varchar2(40),            /*自订字段-文字                          */
coeud04     varchar2(40),            /*自订字段-文字                          */
coeud05     varchar2(40),            /*自订字段-文字                          */
coeud06     varchar2(40),            /*自订字段-文字                          */
coeud07     number(15,3),            /*自订字段-数值                          */
coeud08     number(15,3),            /*自订字段-数值                          */
coeud09     number(15,3),            /*自订字段-数值                          */
coeud10     number(10),              /*自订字段-整数                          */
coeud11     number(10),              /*自订字段-整数                          */
coeud12     number(10),              /*自订字段-整数                          */
coeud13     date,                    /*自订字段-日期                          */
coeud14     date,                    /*自订字段-日期                          */
coeud15     date,                    /*自订字段-日期                          */
coeplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
coelegal    varchar2(10) NOT NULL    /*所属法人                               */
);

create        index coe_02 on coe_file (coe03,coe04);
alter table coe_file add  constraint coe_pk primary key  (coe01,coe02) enable validate;
grant select on coe_file to tiptopgp;
grant update on coe_file to tiptopgp;
grant delete on coe_file to tiptopgp;
grant insert on coe_file to tiptopgp;
grant index on coe_file to public;
grant select on coe_file to ods;
