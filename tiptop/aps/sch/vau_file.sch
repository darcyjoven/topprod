/*
================================================================================
檔案代號:vau_file
檔案名稱:APS需求订单
檔案目的:
上游檔案:
下游檔案:
檔案類型:T
多語系檔案:N
============.========================.==========================================
*/
create table vau_file
(
vau01       varchar2(60) DEFAULT ' ',/*APS版本                                */
vau02       varchar2(10) NOT NULL,   /*储存版本                               */
vau03       varchar2(60) NOT NULL,   /*需求订单编号                           */
vau04       date,                    /*交期                                   */
vau05       number(1),               /*可否耗用                               */
vau06       varchar2(10),            /*客户编号                               */
vau07       number(1),               /*是否能排程                             */
vau08       varchar2(1),             /*需求订单类型                           */
vau09       varchar2(40),            /*产品族群编号                           */
vau10       number(9),               /*优先顺序                               */
vau11       varchar2(60),            /*销售订单编号                           */
vau12       varchar2(60),
vau13       number(15,3),
vau14       varchar2(4),
vau15       varchar2(10),
vau16       varchar2(10),
vau17       number(20,8),
vau18       date,
vau19       varchar2(60),
vau20       number(9),
vau21       varchar2(60),
vau22       number(1),               /*是否严守交期                           */
vau23       varchar2(40),            /*料号                                   */
vau24       number(15,3),            /*订购品项之数量                         */
vauplant    varchar2(10) NOT NULL,   /*所属营运中心                           */
vaulegal    varchar2(10) NOT NULL,   /*所属法人                               */
vau25       varchar2(60),            /*APS保留字段文字                        */
vau26       varchar2(60),            /*APS保留字段文字                        */
vau27       varchar2(60),            /*APS保留字段文字                        */
vau28       number(9),               /*APS保留字段数值                        */
vau29       number(18,8),            /*APS保留字段浮点数                      */
vau30       number(18,8),            /*APS保留字段浮点数                      */
vau31       date,                    /*APS保留字段日期                        */
vau32       date                     /*APS保留字段日期                        */
);

grant select on vau_file to tiptopgp;
grant update on vau_file to tiptopgp;
grant delete on vau_file to tiptopgp;
grant insert on vau_file to tiptopgp;
grant index on vau_file to public;
grant select on vau_file to ods;
